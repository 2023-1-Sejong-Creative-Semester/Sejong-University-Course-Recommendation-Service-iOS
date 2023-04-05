//
//  Langauge.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/03/31.
//

import Foundation

struct LanguageData: Codable {
    let data: [Language]
}

struct Language: Codable {
    let id: Int
    let name: String
    let intro: String
    let logoUrl: URL
    let techStack: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "l_name"
        case intro
        case logoUrl = "logo"
        case techStack
    }
}
