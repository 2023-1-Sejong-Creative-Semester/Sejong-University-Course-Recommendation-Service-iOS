//
//  SearchAptitudeView.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/02/25.
//

import SwiftUI

struct SearchView: View {
    @Namespace var heroEffect
    
    enum SearchType: String {
        case job = "적성검색"
        case subject = "수업검색"
    }
    
    enum FilterContent: String {
        case colleage = "대학"
        case language = "주언어"
        case track = "트랙"
        case semester = "학기"
        case jobCategory = "직업"
    }
    
    enum Colleage: String {
        case softwareColleage = "소프트웨어융합대학"
        case electronicColleage = "전자정보통신공학대학"
    }
    
    enum Track: String, CaseIterable {
        case electronicTrack = "전자트랙"
        case informationTrack = "정보트랙"
        case communicationTrack = "통신트랙"
    }
    
    enum Semester: String, CaseIterable {
        case first = "01-01"
        case second = "01-02"
        case third = "02-01"
        case fourth = "02-02"
        case fifth = "03-01"
        case sixth = "03-02"
        case seventh = "04-01"
        case eighth = "04-02"
    }
    
    enum JobCategory: String, Codable, CaseIterable {
        case webDeveloper = "웹 개발"
        case mobileDeveloper = "모바일 개발"
        case engineer = "엔지니어"
        case dataEngineer = "데이터"
        case gameDeveloper = "게임"
        case security = "보안"
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var searchType: SearchType
    
    @State private var error: APIError?
    @State private var showError: Bool = false
    @State private var showSelectColleage: Bool = true
    @State private var jobList: JobResponse?
    @State private var subjectList: [Subject] = [Subject]()
    @State private var currentCollege: Colleage = .softwareColleage
    @State private var currentStacks: Set<String> = ["C"]
    @State private var currentTrack: Track = .electronicTrack
    @State private var currentSemester: Semester = .first
    @State private var currentJobCategory: JobCategory = .webDeveloper
    @State private var stack: Stack?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                filterBar()
                
                aptitudeList()
            }
            .navigationTitle(showSelectColleage ? Text("") : Text(searchType.rawValue))
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("BackgroundColor"))
        }
        .tint(.primary)
        .overlay {
            if showSelectColleage {
                selectColleage()
            }
        }
        .alert("오류", isPresented: $showError) {
            Button {
                withAnimation(.easeInOut) {
                    error = nil
                    fetchJobList()
                }
            } label: {
                Text("다시시도")
            }
        } message: {
            Text(error?.errorMessage ?? "")
        }
    }
    
    @ViewBuilder
    func selectColleage() -> some View {
        VStack {
            HStack {
                Spacer()
                
                Text(searchType.rawValue)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("SejongColor"))
                
                Spacer()
            }
            .padding(.bottom)
            
            Text("대학을 선택하세요")
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
                .frame(height: 50)
            
            HStack {
                VStack {
                    Button {
                        withAnimation(.easeInOut) {
                            showSelectColleage = false
                            currentCollege = .softwareColleage
                            fetchStacks()
                            fetchJobList()
                        }
                    } label: {
                        VStack {
                            HStack {
                                Image("SoftwareIcon")
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                
                                Spacer()
                            }
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack(spacing: 0) {
                                        Text("소")
                                            .foregroundColor(Color("SejongColor"))
                                        Text("프트웨어")
                                    }
                                    
                                    HStack(spacing: 0) {
                                        Text("융")
                                            .foregroundColor(Color("SejongColor"))
                                        Text("합")
                                    }
                                    
                                    HStack(spacing: 0) {
                                        Text("대")
                                            .foregroundColor(Color("SejongColor"))
                                        Text("학")
                                    }
                                }
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                        .frame(height: 200)
                }
                
                Spacer()
                
                VStack {
                    Spacer()
                        .frame(height: 250)
                    
                    Button {
                        withAnimation(.easeInOut) {
                            showSelectColleage = false
                            currentCollege = .electronicColleage
                            
                            fetchJobList()
                        }
                    } label: {
                        VStack {
                            HStack {
                                Spacer()
                                
                                VStack(alignment: .leading) {
                                    HStack(spacing: 0) {
                                        Text("전")
                                            .foregroundColor(Color("SejongColor"))
                                        Text("자")
                                    }
                                    
                                    HStack(spacing: 0) {
                                        Text("정")
                                            .foregroundColor(Color("SejongColor"))
                                        Text("보")
                                    }
                                    
                                    HStack(spacing: 0) {
                                        Text("통")
                                            .foregroundColor(Color("SejongColor"))
                                        Text("신공학대학")
                                    }
                                }
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            }
                            
                            HStack {
                                Image("ElectronicIcon")
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding()
                }
            }
            .background {
                Rectangle()
                    .fill(Color("SejongColor"))
                    .frame(width: 1000, height: 20)
                    .rotationEffect(Angle(degrees: -45))
            }
            
            Spacer()
        }
        .background(Color("BackgroundColor"))
    }
    
    @ViewBuilder
    func filterButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            if !showSelectColleage {
                HStack {
                    Text(title)
                        .foregroundColor(isSelected ? Color("SejongColor") : .primary)
                        .matchedGeometryEffect(id: title, in: heroEffect)
                    
                    if isSelected {
                        Label("삭제", systemImage: "xmark")
                            .font(.caption)
                            .labelStyle(.iconOnly)
                            .foregroundColor(isSelected ? Color("SejongColor") : .primary)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func filterCollege(college: Colleage) -> some View {
        filterButton(title: college.rawValue, isSelected: false) {
            withAnimation(.easeInOut) {
                currentCollege = college
                
                fetchJobList()
            }
        }
    }
    
    @ViewBuilder
    func filterLanguage(stack: String) -> some View {
        filterButton(title: stack, isSelected: currentStacks.contains(stack)) {
            withAnimation(.easeInOut) {
                guard !currentStacks.contains(stack) || currentStacks.count != 1 else {
                    return
                }
                
                guard let _ = currentStacks.remove(stack) else {
                    currentStacks.insert(stack)
                    fetchJobList()
                    return
                }
                
                fetchJobList()
            }
        }
    }
    
    @ViewBuilder
    func filterTrack(track: Track) -> some View {
        filterButton(title: track.rawValue, isSelected: track == currentTrack) {
            withAnimation(.easeInOut) {
                currentTrack = track
                
                fetchJobList()
            }
        }
    }
    
    @ViewBuilder
    func filterSemester(semester: Semester) -> some View {
        filterButton(title: semester.rawValue, isSelected: semester == currentSemester) {
            withAnimation(.easeInOut) {
                currentSemester = semester
                
                fetchJobList()
            }
        }
    }
    
    @ViewBuilder
    func filterJobCategory(category: JobCategory) -> some View {
        filterButton(title: category.rawValue, isSelected: category == currentJobCategory) {
            withAnimation(.easeInOut) {
                currentJobCategory = category
                
                fetchJobList()
            }
        }
    }
    
    @ViewBuilder
    func filterBar() -> some View {
        VStack(spacing: 0) {
            filterContentBar(filterContent: .colleage)
            
            switch currentCollege {
            case .softwareColleage:
                filterContentBar(filterContent: .language)
                    .background(alignment: .top) {
                        Rectangle()
                            .fill(.secondary)
                            .frame(height: 0.25)
                    }
            case .electronicColleage:
                filterContentBar(filterContent: .track)
                    .background(alignment: .top) {
                        Rectangle()
                            .fill(.secondary)
                            .frame(height: 0.25)
                    }
            }
            
            if searchType == .subject {
                filterContentBar(filterContent: .semester)
                    .background(alignment: .top) {
                        Rectangle()
                            .fill(.secondary)
                            .frame(height: 0.5)
                    }
            }
            
            if currentCollege == .softwareColleage {
                filterContentBar(filterContent: .jobCategory)
                    .background(alignment: .top) {
                        Rectangle()
                            .fill(.secondary)
                            .frame(height: 0.25)
                    }
            }
        }
        .background(Color("ShapeBackgroundColor"))
    }
    
    @ViewBuilder
    func filterContentBar(filterContent: FilterContent) -> some View {
        HStack(spacing: 0) {
            Text(filterContent.rawValue)
                .font(.headline)
                .padding(.horizontal)
            
            Rectangle()
                .fill(Color("SejongColor"))
                .frame(width: 2, height: 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    switch filterContent {
                    case .colleage:
                        filterCollege(college: currentCollege)
                    case .language:
                        if let stacks = stack {
                            ForEach(stacks.stack, id: \.self) { stack in
                                if currentStacks.contains(stack) {
                                    filterLanguage(stack: stack)
                                }
                            }
                            
                            ForEach(stacks.stack, id: \.self) { stack in
                                if !currentStacks.contains(stack) {
                                    filterLanguage(stack: stack)
                                }
                            }
                        } else {
                            HStack {
                                Spacer()
                                
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .controlSize(.regular)
                                
                                Spacer()
                            }
                        }
                    case .track:
                        ForEach(Track.allCases, id: \.rawValue) { track in
                            if currentTrack == track {
                                filterTrack(track: track)
                            }
                        }
                        
                        ForEach(Track.allCases, id: \.rawValue) { track in
                            if currentTrack != track {
                                filterTrack(track: track)
                            }
                        }
                    case .semester:
                        ForEach(Semester.allCases, id: \.rawValue) { semester in
                            if currentSemester == semester {
                                filterSemester(semester: semester)
                            }
                        }
                        
                        ForEach(Semester.allCases, id: \.rawValue) { semester in
                            if currentSemester != semester {
                                filterSemester(semester: semester)
                            }
                        }
                        
                    case .jobCategory:
                        ForEach(JobCategory.allCases, id: \.rawValue) { jobCategory in
                            if currentJobCategory == jobCategory {
                                filterJobCategory(category: jobCategory)
                            }
                        }
                        
                        ForEach(JobCategory.allCases, id: \.rawValue) { jobCategory in
                            if currentJobCategory != jobCategory {
                                filterJobCategory(category: jobCategory)
                            }
                        }
                    }
                }
                .font(.subheadline)
                .padding(.leading)
            }
        }
        .padding(.vertical, 5)
    }
    
    @ViewBuilder
    func aptitudeList() -> some View {
        if let list = jobList {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(list.results) { job in
                        NavigationLink {
                            AptitudeDetailView(jobRequest: IntroduceJobRequest(job: job.job, category: job.category))
                                .toolbarBackground(Color("BackgroundColor").opacity(0.1), for: .navigationBar)
                                .scrollContentBackground(.hidden)
                        } label: {
                            subAptitude(job: job)
                        }
                        .tint(.primary)
                    }
                }
            }
        } else {
            Spacer()
            
            ProgressView()
                .progressViewStyle(.circular)
                .controlSize(.regular)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    func subAptitude(job: Job) -> some View {
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
                
                Text(job.instruction)
                    .font(.caption)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(job.stack, id: \.hashValue) { stack in
                            titleTag(tag: stack)
                        }
                    }
                    .padding(.horizontal, 5)
                    .padding(.vertical)
                }
            }
            .padding(.vertical, 5)
        }
        .padding()
        .background() {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("ShapeBackgroundColor"))
        }
        .padding(.horizontal)
        .padding(.top)
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
    
    func fetchJobList() {
        Task {
            do {
                let body = JobRequest(colleage: currentCollege.rawValue, stack: currentStacks, category: currentJobCategory.rawValue)
                
                var request = URLRequest(url: APIURL.classifyJob.url())
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try JSONEncoder().encode(body)
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                guard httpResponse.statusCode == 200 else {
                    throw APIError.responseHandling(statusCode: httpResponse.statusCode)
                }
                
                self.jobList = try JSONDecoder().decode(JobResponse.self, from: data)
                print("success \(#function)")
            } catch {
                showError = true
                self.error = APIError.convert(error: error)
                print("fail \(#function)")
                print(error)
            }
        }
    }
    
    func fetchStacks() {
        Task {
            do {
                let request = URLRequest(url: APIURL.introduceStack.url())
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                guard httpResponse.statusCode == 200 else {
                    throw APIError.responseHandling(statusCode: httpResponse.statusCode)
                }
                
                self.stack = try JSONDecoder().decode(Stack.self, from: data)
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

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SearchView(searchType: .job)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
