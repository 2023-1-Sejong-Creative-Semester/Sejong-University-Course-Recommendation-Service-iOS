//
//  RoadmapView.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/05/25.
//

import SwiftUI

struct RoadmapView: View {
    @State var roadmapList: Roadmaps?
    @State private var showError: Bool = false
    @State private var error: APIError?
    
    private let roadmapColumns = [
        GridItem(.adaptive(minimum: 150, maximum: .infinity), spacing: nil, alignment: .top)
    ]
    
    var body: some View {
        ScrollView {
            if let roadmaps = roadmapList {
                LazyVGrid(columns: roadmapColumns) {
                    ForEach(roadmaps.roadmap) { roadmap in
                        subRoadmap(roadmap: roadmap)
                    }
                }
            } else {
                HStack {
                    Spacer()
                    
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(.regular)
                        .tint(Color("SejongColor"))
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .navigationTitle("로드맵")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("BackgroundColor"))
        .task {
            withAnimation(.easeInOut) {
                fetchRoadmapDetail()
            }
        }
    }
    
    @ViewBuilder
    func subRoadmap(roadmap: Roadmap) -> some View {
        NavigationLink {
            WebBrowserView(url: roadmap.link)
                .navigationBarTitleDisplayMode(.inline)
        } label: {
            VStack {
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
            .padding()
            .background() {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("ShapeBackgroundColor"))
            }
            .padding(.top)
        }
    }
    
    func fetchRoadmapDetail() {
        Task {
            do {
                let request = URLRequest(url: APIURL.roadmapDetail.url())
                
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

struct RoadmapView_Previews: PreviewProvider {
    static var previews: some View {
        RoadmapView()
    }
}
