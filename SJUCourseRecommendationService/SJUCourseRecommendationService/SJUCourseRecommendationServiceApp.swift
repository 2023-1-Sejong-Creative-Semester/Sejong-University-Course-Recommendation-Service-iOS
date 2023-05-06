//
//  SJUCourseRecommendationServiceApp.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/01/18.
//

import SwiftUI

@main
struct SJUCourseRecommendationServiceApp: App {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(Color("SejongColor"))]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color("SejongColor"))]
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
}
