//
//  AppView.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/01/18.
//

import SwiftUI

struct AppView: View {
    @State private var isFirstStart = true
    var body: some View {
        if isFirstStart {
            StartView(isFirstStart: $isFirstStart)
        } else {
            SearchAptitudeView()
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
