//
//  Trend.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/03/28.
//

import Foundation

struct Trend: Codable {
    let recruit: LanguageAndTech
    let search: LanguageAndTech
}

struct LanguageAndTech: Codable {
    let stack: [String]
    let job: [String]
}
