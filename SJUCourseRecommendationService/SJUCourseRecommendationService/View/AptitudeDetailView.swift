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
    
    @State var jobRequest: IntroduceJobRequest?
    @State var subjectRequest: IntroduceSubjectRequest?
    @State var introduceJob: IntroduceJobResponse?
    @State var introduceSubject: IntroduceSubjectResponse?
    @State var roadmapList: RoadmapJobs?
    
    @State private var contentType: ContentType = .jobInfo
    @State private var scrollOffset: CGFloat = .zero
    @State private var roadmapScrollOffest: CGFloat = .zero
    @State private var error: APIError?
    @State private var showError: Bool = false
    
    var body: some View {
        GeometryReader { reader in
            ScrollView {
                VStack {
                    image(width: reader.size.width)
                    
                    content(width: reader.size.width)
                }
            }
            .alert("오류", isPresented: $showError) {
                Button {
                    withAnimation(.easeInOut) {
                        error = nil
                        fetchIntroduce()
                    }
                } label: {
                    Text("다시시도")
                }
            } message: {
                Text(error?.errorMessage ?? "")
            }
            .background(Color("BackgroundColor"))
            .task {
                fetchIntroduce()
                
                if jobRequest != nil {
                    fetchRoadmapJob()
                }
            }
        }
    }
    
    @ViewBuilder
    func image(width: CGFloat) -> some View {
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
            }
        }
        .frame(width: width, height: width)
        .overlay {
            Color(.black)
                .opacity(scrollOffset / (width * 2))
        }
    }
    
    @ViewBuilder
    func content(width: CGFloat) -> some View {
        LazyVStack(spacing: 0) {
            if let job = introduceJob {
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
                    lectureList(subject: job.subject)
                }
            } else if let subject = introduceSubject {
                VStack {
                    HStack {
                        Text("\(subject.element.credit)학점")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    HStack {
                        Text(subject.element.cName)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                }
                .padding([.horizontal, .top])
                .background(Color("BackgroundColor"))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(subject.element.stack, id: \.hashValue) { stack in
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
                    subjectInformation(subject: subject.element)
                case .subject:
                    jobList(job: subject.job)
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
                    
                    Text(introduceJob != nil ? "직업 설명" : "수업 설명")
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
                    
                    Text(introduceJob != nil ? "관련 수업" : "관련 직무")
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
                Text(job.jobInfo.instruction.longScript)
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
    func subjectInformation(subject: Element) -> some View {
        LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
            Section {
                Text(subject.instruction.longScript)
                    .padding()
                
            } header: {
                contentSelection()
                    .background(Color("BackgroundColor"))
            }
        }
        .background(Color("BackgroundColor"))
    }
    
    @ViewBuilder
    func lectureList(subject: [Subject]) -> some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            Section {
                ForEach(subject, id: \.element.id) { sub in
                    NavigationLink {
                        AptitudeDetailView(subjectRequest: IntroduceSubjectRequest(colleage: sub.element.collage, stack: sub.element.stack, category: sub.element.category?.first ?? "", semester: sub.element.semeter, department: sub.element.semeter, cName: sub.element.cName))
                            .tint(Color("SejongColor"))
                    } label: {
                        subLecture(subject: sub.element)
                    }
                    .tint(.primary)
                }
            } header: {
                contentSelection()
                    .background(Color("BackgroundColor"))
            }
        }
        .background(Color("BackgroundColor"))
    }
    
    @ViewBuilder
    func jobList(job: [Job]) -> some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            Section {
                ForEach(job) { elem in
                    NavigationLink {
                        AptitudeDetailView(jobRequest: IntroduceJobRequest(job: elem.job, category: elem.category))
                            .tint(Color("SejongColor"))
                    } label: {
                        subAptitudeJob(job: elem)
                    }
                    .tint(.primary)
                }
            } header: {
                contentSelection()
                    .background(Color("BackgroundColor"))
            }
        }
        .background(Color("BackgroundColor"))
    }
    
    @ViewBuilder
    func subAptitudeJob(job: Job) -> some View {
        HStack {
            AsyncImage(url: URL(string: job.image)) { img in
                img
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ZStack {
                    Color.secondary.opacity(0.5)
                    
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(Color("SejongColor"))
                }
            }
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)
            .padding(.trailing)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(job.job)
                    .font(.headline)
                
                Text(job.instruction.shortScript)
                    .multilineTextAlignment(.leading)
                    .font(.caption)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(job.stack, id: \.hashValue) { stack in
                            titleTag(tag: stack)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 5)
                    .padding(.vertical)
                }
            }
            .padding(.vertical, 5)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("ShapeBackgroundColor"))
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    @ViewBuilder
    func subLecture(subject: Element) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("\(subject.credit)학점")
                    .foregroundColor(.secondary)
                
                Text(subject.semeter)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .font(.caption)
            
            HStack {
                Text("\(subject.cName)")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            Text(subject.instruction.shortScript)
                .multilineTextAlignment(.leading)
                .font(.footnote)
            
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(subject.stack, id:\.hashValue) { stack in
                        titleTag(tag: stack)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 5)
                .padding(.vertical)
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
            
            
            Rectangle()
                .fill(.gray.opacity(0.2))
                .background(Color("BackgroundColor"))
        }
        .padding(.bottom, 50)
    }
    
    func fetchIntroduce() {
        Task {
            do {
                if let job = jobRequest {
                    var request = URLRequest(url: APIURL.classifyJobIntroduce.url())
                    request.httpMethod = "POST"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = try JSONEncoder().encode(job)
                    
                    let (data, response) = try await URLSession.shared.data(for: request)
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw APIError.invalidResponse
                    }
                    
                    guard httpResponse.statusCode == 200 else {
                        throw APIError.responseHandling(statusCode: httpResponse.statusCode)
                    }
                    
                    self.introduceJob = try JSONDecoder().decode(IntroduceJobResponse.self, from: data)
                }
                
                if let subject = subjectRequest {
                    var request = URLRequest(url: APIURL.classifySubjectIntroduce.url())
                    request.httpMethod = "POST"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = try JSONEncoder().encode(subject)
                    
                    let (data, response) = try await URLSession.shared.data(for: request)
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw APIError.invalidResponse
                    }
                    
                    guard httpResponse.statusCode == 200 else {
                        throw APIError.responseHandling(statusCode: httpResponse.statusCode)
                    }
                    
                    self.introduceSubject = try JSONDecoder().decode(IntroduceSubjectResponse.self, from: data)
                    print("success \(#function)")
                }
            } catch {
                showError = true
                self.error = APIError.convert(error: error)
                print("fail \(#function)")
                print(error)
            }
        }
    }
    
    func fetchRoadmapJob() {
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
            AptitudeDetailView(jobRequest: nil, subjectRequest: IntroduceSubjectRequest(colleage: "소프트웨어융합대학", stack: ["C", "C++", "Java"], category: "웹 개발", semester: "01-01", department: "소프트웨어학과", cName: "C프로그래밍및실습"))
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
