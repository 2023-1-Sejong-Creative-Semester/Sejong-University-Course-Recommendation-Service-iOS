//
//  AptitudeDetailView.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/02/25.
//

import SwiftUI

struct AptitudeDetailView: View {
    enum ContentType {
        case jobInfo
        case subject
    }
    
    @Namespace var matchedEffect
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var jobRequest: IntroduceJobRequest
    @State var introduceJob: IntroduceJobResponse?
    @State var roadmapList: RoadmapJobs?
    
    @State private var contentType: ContentType = .jobInfo
    @State private var scrollOffset: CGFloat = .zero
    @State private var roadmapScrollOffest: CGFloat = .zero
    @State private var error: APIError?
    @State private var showError: Bool = false
    @State private var roadmapID: Int = 1
    
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .top) {
                image(width: reader.size.width)
                
                content(width: reader.size.width)
            }
            .alert("오류", isPresented: $showError) {
                Button {
                    withAnimation(.easeInOut) {
                        error = nil
                        fetchIntroduceJob()
                    }
                } label: {
                    Text("다시시도")
                }
            } message: {
                Text(error?.errorMessage ?? "")
            }
            .background(Color("BackgroundColor"))
            .ignoresSafeArea()
            .task {
                fetchIntroduceJob()
                fetchRoadmapJob(id: roadmapID)
            }
        }
    }
    
    @ViewBuilder
    func image(width: CGFloat) -> some View {
        GeometryReader { imageReader in
            Group {
                if let jobImage = introduceJob?.jobInfo.image {
                    AsyncImage(url: URL(string: jobImage)) { img in
                        img
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ZStack {
                            Color.secondary
                                .opacity(0.5)
                            
                            ProgressView()
                                .progressViewStyle(.circular)
                                .controlSize(.large)
                                .tint(Color("SejongColor"))
                        }
                    }
                    .onAppear() {
                        print(jobImage)
                    }
                } else {
                    Color.secondary
                        .opacity(0.5)
                }
            }
            .frame(height: width - (scrollOffset < 0 ? scrollOffset : 0))
            .overlay(alignment: .top) {
                LinearGradient(colors: [.black.opacity(0.5),
                                        .black.opacity(0.4),
                                        .black.opacity(0.3),
                                        .black.opacity(0.2),
                                        .black.opacity(0.1),
                                        .black.opacity(0.08),
                                        .black.opacity(0.06),
                                        .black.opacity(0.04),
                                        .black.opacity(0.02),
                                        .black.opacity(0)
                ], startPoint: .top, endPoint: .bottom)
                .opacity(0.6)
            }
            .overlay {
                Color(.black)
                    .opacity(scrollOffset / (width * 2))
            }
        }
    }
    
    @ViewBuilder
    func content(width: CGFloat) -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if let job = introduceJob {
                    Spacer()
                        .frame(height: width)
                    
                    VStack {
                        HStack {
                            Text(job.jobInfo.job)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                        }
                    }
                    .padding([.horizontal, .top])
                    .background(Color("BackgroundColor"))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(job.stack, id: \.hashValue) { stack in
                                titleTag(tag: stack)
                            }
                        }
                        .padding(5)
                    }
                    .padding([.leading, .vertical])
                    .background(Color("BackgroundColor"))
                    
                    Rectangle()
                        .fill(.gray.opacity(0.2))
                        .background(Color("BackgroundColor"))
                    
                    switch contentType {
                    case .jobInfo:
                        jobInformation(job: job)
                    case .subject:
                        lectureList(cName: job.cName)
                    }
                } else {
                    Spacer()
                        .frame(height: width)
                    
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(.regular)
                        .padding()
                }
            }
            .background {
                GeometryReader { reader in
                    let offset = -reader.frame(in: .named("CONTENT")).minY
                    Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: offset)
                }
            }
        }
//        .coordinateSpace(name: "CONTENT")
//        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
//            scrollOffset = value
//        }
    }
    
    @ViewBuilder
    func titleTag(tag: String) -> some View {
        Text(tag)
            .font(.caption2)
            .padding(.vertical, 3)
            .padding(.horizontal, 10)
            .foregroundColor(.secondary)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.secondary)
            }
    }
    
    @ViewBuilder
    func contentSelection() -> some View {
        HStack {
            Button {
                withAnimation(.spring()) {
                    contentType = .jobInfo
                }
            } label: {
                HStack {
                    Spacer()
                    
                    Text("직업 설명")
                        .foregroundColor(contentType == .jobInfo ? .white : .primary)
                    
                    Spacer()
                }
            }
            .padding(.vertical)
            .tint(.primary)
            .background {
                if contentType == .jobInfo {
                    Rectangle()
                        .fill(Color("SejongColor"))
                        .matchedGeometryEffect(id: "SELECT", in: matchedEffect)
                        .shadow(radius: 5)
                } else {
                    Rectangle()
                        .fill(Color("BackgroundColor"))
                }
            }
            
            Button {
                withAnimation(.spring()) {
                    contentType = .subject
                }
            } label: {
                HStack {
                    Spacer()
                    
                    Text("관련 수업")
                        .foregroundColor(contentType == .subject ? .white : .primary)
                    
                    Spacer()
                }
            }
            .padding(.vertical)
            .tint(.primary)
            .background {
                if contentType == .subject {
                    Rectangle()
                        .fill(Color("SejongColor"))
                        .matchedGeometryEffect(id: "SELECT", in: matchedEffect)
                        .shadow(radius: 5)
                } else {
                    Rectangle()
                        .fill(Color("BackgroundColor"))
                }
            }
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.secondary.opacity(colorScheme == .dark ? 0.5 : 1))
                .frame(height: 1)
        }
    }
    
    @ViewBuilder
    func jobInformation(job: IntroduceJobResponse) -> some View {
        LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
            Section {
                Text(job.jobInfo.instruction)
                    .padding()
                
                if let list = roadmapList {
                    roadmapListArea(list: list)
                }
            } header: {
                contentSelection()
                    .background(Color("BackgroundColor"))
            }
        }
        .background(Color("BackgroundColor"))
    }
    
    @ViewBuilder
    func lectureList(cName: [String]) -> some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            Section {
                ForEach(cName, id: \.hashValue) { title in
                    subLecture(title: title)
                }
            } header: {
                contentSelection()
                    .background(Color("BackgroundColor"))
            }
        }
        .background(Color("BackgroundColor"))
    }
    
    @ViewBuilder
    func subLecture(title: String) -> some View {
        VStack(spacing: 10) {
            HStack {
                Text("3학점")
                    .foregroundColor(.secondary)
                
                Text("2 - 2")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .font(.caption)
            
            HStack {
                Text("\(title)")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            Text("웹프로그래밍은 머 쓰고 뭐 쓰고 무 하고웹프로그래밍은 머 쓰고 뭐 쓰고 무 하고웹프로그래밍은 머 쓰고 뭐 쓰고 무 하고웹프로그래밍은 머 쓰고 뭐 쓰고 무 하고웹프로그래밍은 머 쓰고 뭐 쓰고 무 하고웹프로그래밍은 머 쓰고 뭐 쓰고 무 하고")
                .font(.footnote)
            
            HStack {
                titleTag(tag: "#웹")
                titleTag(tag: "#HTML")
                titleTag(tag: "#CSS")
                titleTag(tag: "#JavaScript")
                
                Spacer()
            }
        }
        .padding()
        .background(alignment: .bottom) {
            Rectangle()
                .fill(.secondary.opacity(colorScheme == .dark ? 0.5 : 1))
                .frame(height: 0.5)
        }
    }
    
    @ViewBuilder
    func subRoadmap(roadmap: RoadmapJob) -> some View {
        NavigationLink {
            WebBrowserView(url: roadmap.link)
                .navigationBarTitleDisplayMode(.inline)
        } label: {
            VStack {
                AsyncImage(url: URL(string: roadmap.image)) { image in
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
                
                Text(roadmap.name)
                    .fontWeight(.bold)
            }
        }
        .tint(.primary)
    }
    
    @ViewBuilder
    func roadmapListArea(list: RoadmapJobs) -> some View {
        VStack {
            NavigationLink {
//                WebBrowserView(url: list.homepage)
//                    .navigationBarTitleDisplayMode(.inline)
//                    .tint(Color("SejongColor"))
            } label: {
                HStack {
                    Text("로드맵")
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Spacer()
                }
            }
            .padding()
            .tint(.primary)
            
            Rectangle()
                .fill(.gray.opacity(0.2))
                .background(Color("BackgroundColor"))
            
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(list.roadmap) { roadmap in
                            subRoadmap(roadmap: roadmap)
                                .id(roadmap.id)
                        }
                    }
                    .background {
                        GeometryReader { childReader in
                            let offset = -childReader.frame(in: .named("ROADMAP")).minX
                            Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: offset)
                        }
                    }
                }
                .padding()
//                .coordinateSpace(name: "ROADMAP")
//                .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
//                    roadmapScrollOffest = value
//                }
//                .onChange(of: roadmapScrollOffest) { value in
//                    if value >= CGFloat(800 * roadmapID), roadmapID <= 5 {
//                        roadmapID += 1
//
//                        fetchRoadmapDetail(id: roadmapID)
//                    }
//                }
            
            
            Rectangle()
                .fill(.gray.opacity(0.2))
                .background(Color("BackgroundColor"))
        }
        .padding(.bottom, 50)
    }
    
    func fetchIntroduceJob() {
        Task {
            do {
                var request = URLRequest(url: APIURL.classifyJobIntroduce.url())
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try JSONEncoder().encode(jobRequest)
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                guard httpResponse.statusCode == 200 else {
                    throw APIError.responseHandling(statusCode: httpResponse.statusCode)
                }
                
                self.introduceJob = try JSONDecoder().decode(IntroduceJobResponse.self, from: data)
                print("success \(#function)")
            } catch {
                showError = true
                self.error = APIError.convert(error: error)
                print("fail \(#function)")
                print(error)
            }
        }
    }
    
    func fetchRoadmapJob(id: Int) {
        Task {
            do {
                var request = URLRequest(url: APIURL.roadmapJob.url())
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try JSONEncoder().encode(jobRequest)
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                guard httpResponse.statusCode == 200 else {
                    throw APIError.responseHandling(statusCode: httpResponse.statusCode)
                }
                
                self.roadmapList = try JSONDecoder().decode(RoadmapJobs.self, from: data)
                
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

struct AptitudeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AptitudeDetailView(jobRequest: IntroduceJobRequest(job: "풀스택 개발자", category: "웹 개발"))
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
