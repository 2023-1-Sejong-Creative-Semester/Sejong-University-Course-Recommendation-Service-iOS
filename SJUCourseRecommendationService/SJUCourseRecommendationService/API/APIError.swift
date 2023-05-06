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
    case serverQueryError
    case jsonDecodingError
    case jsonEncodingError
    case unknown(statusCode: Int)
    
    var errorMessage: String {
        switch self {
        case .serverError:
            return "API 서버 오류(400)"
        case .invalidResponse:
            return "앱 자체 응답 오류"
        case .invalidRequest:
            return "잘못된 리소스 요청(404)"
        case .serverQueryError:
            return "SQL 쿼리 오류"
        case .jsonDecodingError:
            return "데이터 디코딩 에러"
        case .jsonEncodingError:
            return "데이터 인코딩 에러"
        case .unknown(let statusCode):
            return "알 수 없는 오류\(statusCode)"
        }
    }
    
    static func convert(error: Error) -> APIError {
        switch error {
        case is APIError:
            return error as! APIError
        case is DecodingError:
            return .jsonDecodingError
        case is EncodingError:
            return .jsonEncodingError
        default:
            return .unknown(statusCode: 999)
        }
    }
    
    static func responseHandling(statusCode: Int) -> APIError {
        switch statusCode {
        case 400:
            return APIError.serverError
        case 401:
            return APIError.serverQueryError
        case 404:
            return APIError.invalidRequest
        default:
            return APIError.unknown(statusCode: statusCode)
        }
    }
}
