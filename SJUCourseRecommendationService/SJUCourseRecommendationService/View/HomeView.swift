//
//  HomeView.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/03/28.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var trend: Trend?
    @State private var comparative: ActivityResponse?
    @State private var error: APIError?
    @State private var showError: Bool = false
    
    private let columns = [
        GridItem(.adaptive(minimum: 350, maximum: .infinity), spacing: nil, alignment: .top)
    ]
    
    init(trend: Trend? = nil, error: APIError? = nil) {
        self.trend = trend
        self.error = error
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                searchButton()
                
                universityActivity(title: "비교과 활동", activity: comparative?.results)
                
                recruitTrendList()
            }
            .navigationTitle("넌뭐듣냐?")
            .background(Color("BackgroundColor"))
            .task {
                withAnimation(.easeInOut) {
                    fetchTrend()
                    fetchComparative()
                }
            }
        }
        .tint(.black)
        .alert("오류", isPresented: $showError) {
            Button {
                withAnimation(.easeInOut) {
                    error = nil
                    fetchTrend()
                    fetchComparative()
                }
            } label: {
                Text("다시시도")
            }
        } message: {
            Text(error?.errorMessage ?? "")
        }
    }
    
    @ViewBuilder
    func searchButton() -> some View {
        HStack {
            NavigationLink {
                SearchView(searchType: .job)
            } label: {
                HStack {
                    Spacer()
                    
                    Text("적성 검색")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(colorScheme == .light ? .white : .black)
                        .padding()
                    
                    Spacer()
                }
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("SejongColor"))
                }
                .shadow(radius: 5)
            }
            .padding(.trailing)
            
            NavigationLink {
                SearchView(searchType: .subject)
            } label: {
                HStack {
                    Spacer()
                    
                    Text("수업 검색")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(colorScheme == .light ? .white : .black)
                        .padding()
                    
                    Spacer()
                }
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("SejongColor"))
                }
                .shadow(radius: 5)
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func titleStyle(title: String) -> some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(5)
            
            Rectangle()
                .fill(Color("SejongColor"))
                .frame(height: 3)
        }
    }
    
    @ViewBuilder
    func trendList(title: String, contents: [String]?) -> some View {
        VStack {
            titleStyle(title: title)
            
            if let list = contents {
                VStack(spacing: 10) {
                    ForEach(list, id: \.hashValue) { content in
                        HStack {
                            Text("\((list.firstIndex(of: content) ?? 0) + 1)위")
                                .fontWeight(.semibold)
                            
                            Text(content)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                    }
                }
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.regular)
            }
        }
    }
    
    @ViewBuilder
    func recruitTrendList() -> some View {
        LazyVGrid(columns: columns) {
            trendList(title: "언어", contents: trend?.recruit.stack)
                .padding()
                .background {
                    listBackgound()
                }
                .padding()
            
            trendList(title: "직군", contents: trend?.recruit.job)
                .padding()
                .background {
                    listBackgound()
                }
                .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    func universityActivity(title: String, activity: [Activity]?) -> some View {
        VStack {
            titleStyle(title: title)
            
            if let contents = activity {
                VStack(spacing: 20) {
                    ForEach(contents) { content in
                        HStack {
//                            Button {
//                                if let url = URL(string: content.url) {
//                                    UIApplication.shared.open(url)
//                                }
//                            } label: {
//                                Text(content.title)
//                                    .fontWeight(.semibold)
//                                    .lineLimit(1)
//                            }
                            
                            NavigationLink {
                                WebBrowserView(url: content.url)
                                    .navigationBarTitleDisplayMode(.inline)
                            } label: {
                                Text(content.title)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                        }
                    }
                }
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.regular)
            }
        }
        .padding()
        .background {
            listBackgound()
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func listBackgound() -> some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color("ShapeBackgroundColor"))
    }
    
    func fetchTrend() {
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: APIURL.trend.url)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                guard httpResponse.statusCode == 200 else {
                    throw APIError.responseHandling(statusCode: httpResponse.statusCode)
                }
                
                self.trend = try JSONDecoder().decode(Trend.self, from: data)
                print("success \(#function)")
            } catch {
                showError = true
                self.error = error as? APIError
                print("fail \(#function)")
                print(error)
            }
        }
    }
    
    func fetchComparative() {
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: APIURL.comparative.url)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                guard httpResponse.statusCode == 200 else {
                    throw APIError.responseHandling(statusCode: httpResponse.statusCode)
                }
                
                self.comparative = try JSONDecoder().decode(ActivityResponse.self, from: data)
                print("success \(#function)")
            } catch {
                showError = true
                self.error = error as? APIError
                print("fail \(#function)")
                print(error)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(trend: Trend(recruit: LanguageAndTech(stack: ["자바", "파이썬", "C++", "C#", "Dart"], job: ["백엔드", "프론트엔드", "게임", "인공지능", "데이터분석"]), search: LanguageAndTech(stack: ["자바", "파이썬", "C++", "C#", "Dart"], job: ["백엔드", "프론트엔드", "게임", "인공지능", "데이터분석"])))
    }
}
