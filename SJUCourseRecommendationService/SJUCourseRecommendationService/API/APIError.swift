//
//  APIError.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/04/04.
//

import Foundation

enum APIError: Error {
    case serverError
    case invalidResponse
    case invalidRequest
    case unknown(statusCode: Int)
    
    var errorMessage: String {
        switch self {
        case .serverError:
            return "API 서버 오류(400)"
        case .invalidResponse:
            return "앱 자체 응답 오류"
        case .invalidRequest:
            return "잘못된 리소스 요청(404)"
        case .unknown(let statusCode):
            return "알 수 없는 오류\(statusCode)"
        }
    }
}
