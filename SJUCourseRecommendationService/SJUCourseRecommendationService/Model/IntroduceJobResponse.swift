//
//  IntroduceJobResponse.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/04/11.
//

import Foundation

struct IntroduceJobResponse: Codable {
    let jobInfo: JobInfo
    let stack: [String]
    let subject: [Subject]

    enum CodingKeys: String, CodingKey {
        case jobInfo = "job_info"
        case stack, subject
    }
}

// MARK: - JobInfo
struct JobInfo: Codable, Identifiable {
    let id: Int
    let category, job: String
    let instruction: Instruction
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id = "numbering"
        case category, job, instruction, image
    }
}
