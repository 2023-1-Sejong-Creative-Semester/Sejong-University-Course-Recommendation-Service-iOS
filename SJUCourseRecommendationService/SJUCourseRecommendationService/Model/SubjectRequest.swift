//
//  SubjectRequest.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/04/09.
//

import Foundation

struct SubjectRequest: Codable {
    var colleage: String
    var stack: Set<String>
    var category: String
    var semester: String
}
