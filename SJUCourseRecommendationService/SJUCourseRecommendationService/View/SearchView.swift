//
//  SearchAptitudeView.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/02/25.
//

import SwiftUI

struct SearchView: View {
    enum SearchType: String {
        case job = "적성검색"
        case subject = "수업검색"
    }
    
    enum FilterContent: String {
        case colleage = "대학"
        case language = "주언어"
        case track = "트랙"
        case semester = "학기"
    }
    
    enum Colleage: String {
        case softwareColleage = "소프트웨어융합대학"
        case electronicColleage = "전자정보통신공학대학"
    }
    
    enum Language: String {
        case CLanguage = "C"
        case CPPLanguage = "C++"
        case JavaLanguage = "자바"
        case PythonLanguage = "파이썬"
    }
    
    enum Track: String {
        case electronicTrack = "전자트랙"
        case informationTrack = "정보트랙"
        case communicationTrack = "통신트랙"
    }
    
    enum Semester: String {
        case first = "1-1"
        case second = "1-2"
        case third = "2-1"
        case fourth = "2-2"
        case fifth = "3-1"
        case sixth = "3-2"
        case seventh = "4-1"
        case eighth = "4-2"
    }
    
    @Namespace var heroEffect
    
    @State private var error: APIError?
    @State private var showError: Bool = false
    @State private var showSelectColleage: Bool = true
    @State private var jobList: [Job]?
    @State private var subjectList: [Subject] = [Subject]()
    @State private var searchType: SearchType
    @State private var currentCollege: Colleage = .softwareColleage
    @State private var currentLanguage: Language = .CLanguage
    @State private var currentTrack: Track = .electronicTrack
    @State private var currentSemester: Semester = .first
    
    init(searchType: SearchType) {
        self.searchType = searchType
    }
    
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
                    .ignoresSafeArea()
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
            Spacer()
                .frame(height: 200)
            
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
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            
            Button {
                withAnimation(.easeInOut) {
                    showSelectColleage = false
                    currentCollege = .softwareColleage
                    fetchJobList()
                }
            } label: {
                Text(Colleage.softwareColleage.rawValue)
                    .font(showSelectColleage ? .title2 : nil)
                    .fontWeight(showSelectColleage ? .semibold : nil)
                    .foregroundColor(Color("BackgroundColor"))
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("SejongColor"))
                    }
                    .matchedGeometryEffect(id: Colleage.softwareColleage.rawValue, in: heroEffect)
            }
            .padding(.bottom)
            
            Button {
                withAnimation(.easeInOut) {
                    showSelectColleage = false
                    currentCollege = .electronicColleage
                    fetchJobList()
                }
            } label: {
                Text(Colleage.electronicColleage.rawValue)
                    .font(showSelectColleage ? .title2 : nil)
                    .fontWeight(showSelectColleage ? .semibold : nil)
                    .foregroundColor(Color("BackgroundColor"))
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("SejongColor"))
                    }
                    .matchedGeometryEffect(id: Colleage.electronicColleage.rawValue, in: heroEffect)
            }
            
            Spacer()

        }
        .background(Color("BackgroundColor"))
    }
    
    @ViewBuilder
    func filterButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            if !showSelectColleage {
                Text(title)
                    .foregroundColor(isSelected ? Color("SejongColor") : .primary)
                    .matchedGeometryEffect(id: title, in: heroEffect)
            }
        }
    }
    
    @ViewBuilder
    func filterCollege(college: Colleage) -> some View {
        filterButton(title: college.rawValue, isSelected: college == currentCollege) {
            withAnimation(.easeInOut) {
                currentCollege = college
            }
        }
    }
    
    @ViewBuilder
    func filterLanguage(language: Language) -> some View {
        filterButton(title: language.rawValue, isSelected: language == currentLanguage) {
            withAnimation(.easeInOut) {
                currentLanguage = language
            }
        }
    }
    
    @ViewBuilder
    func filterTrack(track: Track) -> some View {
        filterButton(title: track.rawValue, isSelected: track == currentTrack) {
            withAnimation(.easeInOut) {
                currentTrack = track
            }
        }
    }
    
    @ViewBuilder
    func filterSemester(semester: Semester) -> some View {
        filterButton(title: semester.rawValue, isSelected: semester == currentSemester) {
            withAnimation(.easeInOut) {
                currentSemester = semester
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
        }
        .background(Color("ShapeBackgroundColor"))
    }
    
    @ViewBuilder
    func filterContentBar(filterContent: FilterContent) -> some View {
        HStack(spacing: 0) {
            Text(filterContent.rawValue)
                .font(.headline)
                .frame(width: 80)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    switch filterContent {
                        case .colleage:
                            filterCollege(college: currentCollege)
                        case .language:
                            filterLanguage(language: .CLanguage)
                            filterLanguage(language: .CPPLanguage)
                            filterLanguage(language: .JavaLanguage)
                            filterLanguage(language: .PythonLanguage)
                        case .track:
                            filterTrack(track: .electronicTrack)
                            filterTrack(track: .informationTrack)
                            filterTrack(track: .communicationTrack)
                        case .semester:
                            filterSemester(semester: .first)
                            filterSemester(semester: .second)
                            filterSemester(semester: .third)
                            filterSemester(semester: .fourth)
                            filterSemester(semester: .fifth)
                            filterSemester(semester: .sixth)
                            filterSemester(semester: .seventh)
                            filterSemester(semester: .eighth)
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
                    ForEach(0..<5) { Int in
                        NavigationLink {
                            AptitudeDetailView()
                                .toolbarBackground(Color("BackgroundColor").opacity(0.1), for: .navigationBar)
                                .scrollContentBackground(.hidden)
                        } label: {
                            subAptitude()
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
    func subAptitude() -> some View {
        HStack {
            Color(.secondaryLabel)
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 5)
                .padding(.trailing)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("iOS 개발자")
                    .font(.headline)
                
                Text("간단한 설명 간단한 설명 간단한 설명 간단한 설명 간단한 설명 간단한 설명 간단한 설명 간단한 설명 ")
                    .font(.caption)
                
                Spacer()
            }
            .padding(.vertical, 5)
        }
        .padding()
        .background() {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("ShapeBackgroundColor"))
        }
        .padding(.horizontal, 5)
        .padding(.top)
    }
    
    func fetchJobList() {
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: APIURL.introduceJob.url)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                guard httpResponse.statusCode == 200 else {
                    if httpResponse.statusCode == 400 {
                        throw APIError.serverError
                    } else if httpResponse.statusCode == 404 {
                        throw APIError.invalidRequest
                    } else {
                        throw APIError.unknown(statusCode: httpResponse.statusCode)
                    }
                }
                
                self.jobList = try JSONDecoder().decode([Job].self, from: data)
                print("success")
            } catch {
                showError = true
                self.error = error as? APIError
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
