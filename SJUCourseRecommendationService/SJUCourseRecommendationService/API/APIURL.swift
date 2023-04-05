//
//  APIURL.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/03/31.
//

import Foundation

enum APIURL {
    case introduceJob
    case introduceDepartment
    case introduceLanguage
    case trend
    
    var url: URL {
        var urlComponents = URLComponents(string: "http://34.168.80.42:3001")!
        
        switch self {
            case .introduceJob:
                urlComponents.path = "/introduce"
                urlComponents.queryItems = [URLQueryItem(name: "type", value: "job")]
                return urlComponents.url!
            case .introduceDepartment:
                urlComponents.path = "/introduce"
                urlComponents.queryItems = [URLQueryItem(name: "type", value: "department")]
                return urlComponents.url!
            case .introduceLanguage:
                urlComponents.path = "/introduce"
                urlComponents.queryItems = [URLQueryItem(name: "type", value: "language")]
                return urlComponents.url!
            case .trend:
                urlComponents.path = "/trend"
                return urlComponents.url!
        }
    }
}
