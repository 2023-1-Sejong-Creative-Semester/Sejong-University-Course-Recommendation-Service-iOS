//
//  IntroduceJobResponse.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/04/11.
//

import Foundation

struct IntroduceJobResponse: Codable {
    let jobInfo: JobInfo
    let stack, cName: [String]

    enum CodingKeys: String, CodingKey {
        case jobInfo = "job_info"
        case stack
        case cName = "c_name"
    }
}

// MARK: - JobInfo
struct JobInfo: Codable {
    let numbering: Int
    let category, job, instruction, image: String
}
