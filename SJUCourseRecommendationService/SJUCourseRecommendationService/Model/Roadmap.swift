//
//  RoadmapDetail.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/05/02.
//

import Foundation

struct Roadmaps: Codable {
    let homepage: String
    var roadmap: [Roadmap]
}

struct Roadmap: Codable, Identifiable {
    let name: String
    let id: Int
    let link, logo: String
    
    enum CodingKeys: String, CodingKey {
        case id = "numbering"
        case name, link, logo
    }
}

