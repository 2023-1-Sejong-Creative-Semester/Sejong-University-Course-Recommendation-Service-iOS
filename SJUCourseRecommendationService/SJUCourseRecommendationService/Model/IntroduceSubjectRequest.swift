//
//  IntroduceSubjectRequest.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/05/29.
//

import Foundation

struct IntroduceSubjectRequest: Codable {
    let colleage: String
    let stack: [String]
    let category, semester, department, cName: String

    enum CodingKeys: String, CodingKey {
        case colleage, stack, category, semester, department
        case cName = "c_name"
    }
}
