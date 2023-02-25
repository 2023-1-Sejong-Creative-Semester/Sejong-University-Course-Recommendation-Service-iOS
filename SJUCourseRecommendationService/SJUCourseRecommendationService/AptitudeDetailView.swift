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
        case lectures
    }
    
    @Namespace var matchedEffect
    
    @State private var contentType: ContentType = .lectures
    
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .top) {
                GeometryReader { imageReader in
                    let minY = imageReader.frame(in: .named("CONTENT")).minY
                    
                    Color(.secondaryLabel)
                        .frame(height: reader.size.height / 3 + (minY > 0 ? minY : 0))
                        .onChange(of: minY) { newValue in
                            print(newValue)
                        }
                }
                
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: reader.size.height / 3)
                        
                        title()
                        
                        Rectangle()
                            .fill(.gray.opacity(0.2))
                            .background(Color("BackgroundColor"))
                        
                        switch contentType {
                            case .jobInfo:
                                jobInformation()
                            case .lectures:
                                lectureList()
                        }
                    }
                    .coordinateSpace(name: "CONTENT")
                }
            }
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
            .background {
                RoundedRectangle(cornerRadius: 20)
//                    .stroke(Color("SejongColor"))
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
                } else {
                    Rectangle()
                        .fill(Color("Background"))
                }
            }
            
            Button {
                withAnimation(.spring()) {
                    contentType = .lectures
                }
            } label: {
                HStack {
                    Spacer()
                    
                    Text("관련 수업")
                        .foregroundColor(contentType == .lectures ? .white : .primary)
                    
                    Spacer()
                }
            }
            .padding(.vertical)
            .tint(.primary)
            .background {
                if contentType == .lectures {
                    Rectangle()
                        .fill(Color("SejongColor"))
                        .matchedGeometryEffect(id: "SELECT", in: matchedEffect)
                } else {
                    Rectangle()
                        .fill(Color("Background"))
                }
            }
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.black)
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
                .fill(.secondary)
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
