//
//  JobRequest.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/04/11.
//

import Foundation

struct JobRequest: Codable {
    var colleage: String
    var stack: Set<Stack>
    var category: String
}


