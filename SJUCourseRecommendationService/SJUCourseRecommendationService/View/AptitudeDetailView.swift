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
    
    @State private var contentType: ContentType = .jobInfo
    @State private var scrollOffset: CGFloat = .zero
    
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .top) {
                GeometryReader { imageReader in
                    Color.secondary
                        .opacity(0.5)
                        .frame(height: reader.size.width - (scrollOffset < 0 ? scrollOffset : 0))
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
                                .opacity(scrollOffset / (reader.size.width * 2))
                        }
                }
                
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: reader.size.width)
                        
                        title()
                        
                        Rectangle()
                            .fill(.gray.opacity(0.2))
                            .background(Color("BackgroundColor"))
                        
                        switch contentType {
                            case .jobInfo:
                                jobInformation()
                            case .subject:
                                lectureList()
                        }
                    }
                    .background {
                        GeometryReader { reader in
                            let offset = -reader.frame(in: .named("CONTENT")).minY
                            Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: offset)
                        }
                    }
                }
                .coordinateSpace(name: "CONTENT")
                .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                    scrollOffset = value
                }
            }
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "heart")
                    }
                    .tint(.pink)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "star")
                    }
                    .tint(.yellow)
                }
            }
        }
    }
    
    @ViewBuilder
    func title() -> some View {
        VStack {
            HStack {
                Text("iOS 개발자")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
            }
            
            HStack {
                Text("iOS Developer")
                    .font(.subheadline)
                
                Spacer()
            }
            
            HStack {
                titleTag(tag: "#모바일")
                titleTag(tag: "#iOS")
                titleTag(tag: "#Swift")
                titleTag(tag: "#애플")
                
                Spacer()
            }
        }
        .padding()
        .background(Color("BackgroundColor"))
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
                    .shadow(radius: 5)
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
    func jobInformation() -> some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            Section {
                Text("사진 및 설명들\n")
                
                Text("사진 및 설명들\n")
                
                Text("사진 및 설명들\n")
                
                Text("사진 및 설명들\n")
                
                Text("사진 및 설명들\n")
                
                Text("사진 및 설명들\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
                
                Spacer()
            } header: {
                contentSelection()
                    .background(Color("BackgroundColor"))
            }
        }
        .background(Color("BackgroundColor"))
    }
    
    @ViewBuilder
    func lectureList() -> some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            Section {
                ForEach(0..<5) { Int in
                    subLecture()
                }
            } header: {
                contentSelection()
                    .background(Color("BackgroundColor"))
            }
        }
        .background(Color("BackgroundColor"))
    }
    
    @ViewBuilder
    func subLecture() -> some View {
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
                Text("웹프로그래밍 (000342)")
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
}

struct AptitudeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AptitudeDetailView()
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
