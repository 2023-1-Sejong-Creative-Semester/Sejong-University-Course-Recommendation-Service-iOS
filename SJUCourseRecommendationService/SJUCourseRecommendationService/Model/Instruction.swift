//
//  Instruction.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/05/29.
//

import Foundation

struct Instruction: Codable {
    let longScript, shortScript: String

    enum CodingKeys: String, CodingKey {
        case longScript = "long_script"
        case shortScript = "short_script"
    }
}
