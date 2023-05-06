//
//  ComparativeResponse.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/04/08.
//

import Foundation

struct ActivityComparativeResponse: Codable {
    let results: [ActivityComparative]
}

struct ActivityComparative: Codable, Identifiable {
    let id: Int
    let colleage, title: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id = "numbering"
        case colleage, title, url
    }
}
