//
//  Language.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/04/11.
//

import Foundation

enum Stack: String, Codable, CaseIterable {
    case cLang = "C"
    case cppLang = "C++"
    case javaLang = "Java"
    case pythonLang = "Python"
    case kotlinLang = "Kotlin"
    case springStack = "Spring"
    case jpaStack = "JPA"
    case gradleStack = "Gradle"
}
