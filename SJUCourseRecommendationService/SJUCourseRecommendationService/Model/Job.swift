//
//  Job.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/03/28.
//

import Foundation

struct Job: Codable {
    let data: [JobData]
}

struct JobData: Codable {
    let id: Int
    let dName, dNameE, intro: String
    let logo, homepage: String
    let techStack: [String]
    
    enum CodingKeys: String, CodingKey {
        case dName = "d_name"
        case dNameE = "d_name_e"
        case id, intro, logo, homepage
        case techStack = "tech_stack"
    }
}
