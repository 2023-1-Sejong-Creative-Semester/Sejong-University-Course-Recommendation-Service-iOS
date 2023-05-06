//
//  StartView.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/01/18.
//

import SwiftUI

struct StartView: View {
    @Binding var isFirstStart: Bool
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .center) {
                Spacer()
                
                Image("IconImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                
                Spacer()
                
                Button {
                    withAnimation(.easeInOut) {
                        isFirstStart = false
                    }
                } label: {
                    Text("시작하기")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .padding()
                .padding(.horizontal, 30)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("SejongColor"))
                }
                .shadow(radius: 5)
                
                Spacer()
                
                Image("SejongLogoAndText")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                    .padding()
                    .shadow(radius: 10)
            }
            .frame(width: reader.size.width)
        }
        .background(Color("BackgroundColor"))
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(isFirstStart: .constant(true))
    }
}
