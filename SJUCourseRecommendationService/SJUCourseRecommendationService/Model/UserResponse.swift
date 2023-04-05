//
//  User.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/03/28.
//

import Foundation

struct UserResponse: Codable {
    let jobType: [String]
    let language: [String]
    
    enum CodingKeys: String, CodingKey {
        case jobType = "jobtype"
        case language
    }
}
