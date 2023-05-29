//
//  JobResponse.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/04/11.
//

import Foundation

struct JobResponse: Codable {
    let results: [Job]
}

struct Job: Codable, Identifiable {
    let id: Int
    let instruction: Instruction
    let category, job, image: String
    let stack: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "numbering"
        case category, job, instruction, stack, image
    }
}
