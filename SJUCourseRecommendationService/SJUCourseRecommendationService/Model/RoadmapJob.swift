//
//  RoadmapJob.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/05/20.
//

import Foundation

struct RoadmapJobs: Codable {
    let roadmap: [RoadmapJob]
}

// MARK: - Roadmap
struct RoadmapJob: Codable, Identifiable {
    let id: Int
    
    let name: String
    let link: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id = "numbering"
        case name, link, image
    }
}
