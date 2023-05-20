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
    @State private var comparative: ActivityComparativeResponse?
    @State private var curriculum: ActivityCurriculumResponse?
    @State var roadmapList: Roadmaps?
    @State private var error: APIError?
    @State private var showError: Bool = false
    
    private let columns = [
        GridItem(.adaptive(minimum: 350, maximum: .infinity), spacing: nil, alignment: .top)
    ]
    
    private let roadmapColumns = [
        GridItem(.adaptive(minimum: 150, maximum: .infinity), spacing: nil, alignment: .top)
    ]
    
    init(trend: Trend? = nil, error: APIError? = nil) {
        self.trend = trend
        self.error = error
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                searchButton()
                
                activityComparativeList(title: "비교과 활동", activity: comparative?.results)
                
                activityCurriculumList(title: "취업 지원 활동", activity: curriculum?.results)
                
                recruitTrendList()
                
                roadmapGrid()
            }
            .navigationTitle("넌뭐듣냐?")
            .background(Color("BackgroundColor"))
            .task {
                withAnimation(.easeInOut) {
                    fetchTrend()
                    fetchComparative()
                    fetchCurriculum()
                    fetchRoadmapMain()
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
                        .foregroundColor(.white)
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
                        .foregroundColor(.white)
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
    func activityComparativeList(title: String, activity: [ActivityComparative]?) -> some View {
        VStack {
            titleStyle(title: title)
            
            if let contents = activity {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(contents) { content in
                        HStack {
                            NavigationLink {
                                WebBrowserView(url: content.url)
                                    .navigationBarTitleDisplayMode(.inline)
                            } label: {
                                Text(content.title)
                                    .foregroundColor(.primary)
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
    func activityCurriculumList(title: String, activity: ActivityCurriculum?) -> some View {
        VStack {
            titleStyle(title: title)
            
            if let contents = activity {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(contents.career) { content in
                        NavigationLink {
                            WebBrowserView(url: content.url)
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(content.title)
                                    .foregroundColor(.primary)
                                    .fontWeight(.semibold)
                                    .truncationMode(.tail)
                                    .lineLimit(1)
                                
                                Text("기한 : \(content.deadline)")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .padding([.top, .leading], 5)
                            }
                        }
                    }
                    
                    ForEach(contents.employment) { content in
                        NavigationLink {
                            WebBrowserView(url: content.url)
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(content.title)
                                    .foregroundColor(.primary)
                                    .fontWeight(.semibold)
                                    .truncationMode(.tail)
                                    .lineLimit(1)
                                
                                Text("기한 : \(content.deadline)")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .padding([.top, .leading], 5)
                            }
                        }
                    }
                    
                    ForEach(contents.regional) { content in
                        NavigationLink {
                            WebBrowserView(url: content.url)
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(content.title)
                                    .foregroundColor(.primary)
                                    .fontWeight(.semibold)
                                    .truncationMode(.tail)
                                    .lineLimit(1)
                                
                                Text("기한 : \(content.deadline)")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .padding([.top, .leading], 5)
                            }
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
        .padding([.horizontal, .top])
    }
    
    @ViewBuilder
    func roadmapGrid() -> some View {
        VStack {
            titleStyle(title: "로드맵")
            
            if let roadmaps = roadmapList {
                LazyVGrid(columns: roadmapColumns) {
                    ForEach(roadmaps.roadmap) { roadmap in
                        subRoadmap(roadmap: roadmap)
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
        .padding([.horizontal, .top])
    }
    
    @ViewBuilder
    func subRoadmap(roadmap: Roadmap) -> some View {
        NavigationLink {
            WebBrowserView(url: roadmap.link)
                .navigationBarTitleDisplayMode(.inline)
        } label: {
            HStack {
                AsyncImage(url: URL(string: roadmap.logo)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ZStack {
                        Color.gray.opacity(0.2)
                        
                        ProgressView()
                            .tint(Color("SejongColor"))
                    }
                }
                .frame(width: 100, height: 100)
                
                VStack {
                    Text(roadmap.name)
                        .font(.footnote)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    func listBackgound() -> some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color("ShapeBackgroundColor"))
    }
    
    func fetchTrend() {
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: APIURL.trend.url())
                
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
                let (data, response) = try await URLSession.shared.data(from: APIURL.comparative.url())
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                guard httpResponse.statusCode == 200 else {
                    throw APIError.responseHandling(statusCode: httpResponse.statusCode)
                }
                
                self.comparative = try JSONDecoder().decode(ActivityComparativeResponse.self, from: data)
                print("success \(#function)")
            } catch {
                showError = true
                self.error = error as? APIError
                print("fail \(#function)")
                print(error)
            }
        }
    }
    
    func fetchCurriculum() {
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: APIURL.curriculum.url())
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                guard httpResponse.statusCode == 200 else {
                    throw APIError.responseHandling(statusCode: httpResponse.statusCode)
                }
                
                self.curriculum = try JSONDecoder().decode(ActivityCurriculumResponse.self, from: data)
                print("success \(#function)")
            } catch {
                showError = true
                self.error = error as? APIError
                print("fail \(#function)")
                print(error)
            }
        }
    }
    
    func fetchRoadmapMain() {
        Task {
            do {
                let request = URLRequest(url: APIURL.roadmapMain.url())
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                guard httpResponse.statusCode == 200 else {
                    throw APIError.responseHandling(statusCode: httpResponse.statusCode)
                }
                
                self.roadmapList = try JSONDecoder().decode(Roadmaps.self, from: data)
                print("success \(#function)")
            } catch {
                showError = true
                self.error = APIError.convert(error: error)
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
