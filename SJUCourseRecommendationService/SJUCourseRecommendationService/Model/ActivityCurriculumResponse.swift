//
//  ActivityCurriculumResponse.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/05/06.
//

import Foundation

struct ActivityCurriculumResponse: Codable {
    let results: ActivityCurriculum
}

// MARK: - Results
struct ActivityCurriculum: Codable {
    let career, employment, regional: [Career]
}

struct Career: Codable, Identifiable {
    let careerClass: String
    let id: Int
    let url: String
    let deadline, title: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case careerClass = "class"
        case id = "numbering"
        case url, deadline, title, image
    }
}
