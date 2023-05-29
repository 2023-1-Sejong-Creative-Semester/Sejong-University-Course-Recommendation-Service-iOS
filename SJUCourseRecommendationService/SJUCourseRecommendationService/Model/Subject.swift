//
//  Subject.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/05/29.
//

import Foundation

struct Subject: Codable {
    let element: Element
}

struct Element: Codable, Identifiable {
    let collage, cName: String
    let department, stack: [String]
    let semeter, credit: String
    let instruction: Instruction
    let category: [String]?
    let id: Int

    enum CodingKeys: String, CodingKey {
        case collage
        case cName = "c_name"
        case department, stack, semeter, credit, instruction, category
        case id = "numbering"
    }
}
