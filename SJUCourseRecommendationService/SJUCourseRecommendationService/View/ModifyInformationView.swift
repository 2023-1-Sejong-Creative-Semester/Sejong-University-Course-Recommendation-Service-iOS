//
//  ModifyInformationView.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/01/18.
//

import SwiftUI

struct ModifyInformationView: View {
    @Environment(\.colorScheme) var displayStyle
    
    var body: some View {
        GeometryReader { reader in
            VStack {
                HStack {
                    Text("정보 입력")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(displayStyle == .dark ? .white.opacity(0.9) : Color("SejongColor"))
                        .padding()
                    
                    Spacer()
                    
                    
                }
                
                Spacer()
                
                stepOne()
                    .frame(width: reader.size.width, height: 60)
                
                Spacer()
                
                Button {
                    
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
            }
            .frame(width: reader.size.width)
        }
    }
    
    @State var department = ""
    @State var majorRoute = ""
    
    @State var departmentList = ["컴퓨터공학과", "전자정보통신공학과"]
    @State var majorRouteList = ["소프트웨어융합대학", "공과대학"]
    
    @State var selectedDepartment = 0
    @State var selectedMajorRoute = 0
    
    @ViewBuilder
    func stepOne() -> some View {
        VStack {
            infomationSelection(title: "학과", information: department, selected: $selectedDepartment, list: departmentList)
            
            Spacer()
            
            infomationSelection(title: "전공 루트", information: majorRoute, selected: $selectedMajorRoute, list: majorRouteList)
        }
    }
    
    func infomationSelection(title: String, information: String, selected: Binding<Int>, list: [String]) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(displayStyle == .dark ? .white.opacity(0.9) : Color("SejongColor"))
                
                Spacer()
            }
            
            HStack {
                Text(department)

                Spacer()
                
//                Picker(title, selection: , content: {
//                    ForEach(list, id: \.hashValue) { information in
//                        Text(information)
//                            .onAppear() {
//                                department = information
//                            }
//                    }
//                })
//                .pickerStyle(.menu)
            }
            
            Rectangle()
                .foregroundColor(displayStyle == .dark ? .white.opacity(0.9) : Color("SejongColor"))
                .frame(height: 3)
                .shadow(radius: 3)
        }
        .padding()
    }
    
    @ViewBuilder
    func informationList(_ list: [String]) -> some View {
        VStack {
            ForEach(list, id: \.hashValue) { information in
                HStack {
                    Spacer()
                    
                    Text(information)
                        .padding()
                    
                    Spacer()
                }
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .shadow(radius: 10)
        }
    }
}

struct ModifyInformationView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyInformationView()
    }
}
