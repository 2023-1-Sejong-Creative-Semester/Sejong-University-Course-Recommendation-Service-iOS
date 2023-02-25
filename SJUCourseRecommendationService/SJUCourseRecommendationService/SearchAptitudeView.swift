//
//  SearchAptitudeView.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/02/25.
//

import SwiftUI

struct SearchAptitudeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                filterBar()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    func filterBar() -> some View {
        VStack {
            filterContentBar(title: "대학")
            filterContentBar(title: "주언어")
            filterContentBar(title: "학기")
            
            aptitudeList()
        }
        .navigationTitle("적성검색")
    }
    
    @ViewBuilder
    func filterContentBar(title: String) -> some View {
        HStack(spacing: 0) {
            Text(title)
                .fontWeight(.semibold)
                .frame(width: 80)
                .background {
                    HStack {
                        Spacer()
                        
                        Rectangle()
                            .fill(.secondary)
                            .frame(width: 1)
                    }
                }
            
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    Text("소프트웨어융합대학")
                        .foregroundColor(Color("SejongColor"))
                    
                    Text("전자정보통신대학")
                }
                .padding(.leading)
            }
        }
        .padding(.vertical, 5)
        .background(alignment: .bottom) {
            Rectangle()
                .fill(.secondary)
                .frame(height: 0.5)
        }
    }
    
    @ViewBuilder
    func aptitudeList() -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(0..<5) { Int in
                    NavigationLink {
                        AptitudeDetailView()
                            .toolbarBackground(.hidden, for: .navigationBar)
                    } label: {
                        subAptitude()
                    }
                    .tint(.primary)
                }
            }
        }
    }
    
    @ViewBuilder
    func subAptitude() -> some View {
        HStack {
            Color(.secondaryLabel)
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading) {
                Text("iOS 개발자")
                    .font(.headline)
                
                Text("간단한 설명 간단한 설명 간단한 설명 간단한 설명 간단한 설명 간단한 설명 간단한 설명 간단한 설명 ")
                    .font(.caption)
                
                Spacer()
            }
            .padding(.vertical, 5)
        }
        .padding()
        .background(alignment: .bottom) {
            Rectangle()
                .fill(.secondary)
                .frame(height: 0.5)
        }
    }
}

struct SearchAptitudeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SearchAptitudeView()
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
