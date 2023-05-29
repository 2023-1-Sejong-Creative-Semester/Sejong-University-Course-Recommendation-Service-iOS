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
    case introduceStack
    case trend
    case comparative
    case curriculum
    case classifyJob
    case classifyJobIntroduce
    case classifySubject
    case classifySubjectIntroduce
    case roadmapMain
    case roadmapDetail
    case roadmapJob
    
    func url(id: Int? = nil) -> URL {
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
        case .introduceStack:
            urlComponents.path = "/introduce/stackInfo"
            return urlComponents.url!
        case .trend:
            urlComponents.path = "/trend"
            return urlComponents.url!
        case .comparative:
            urlComponents.path = "/activity/comparative"
            return urlComponents.url!
        case .curriculum:
            urlComponents.path = "/activity/curriculum"
            return urlComponents.url!
        case .classifyJob:
            urlComponents.path = "/classify/job"
            return urlComponents.url!
        case .classifyJobIntroduce:
            urlComponents.path = "/classify/job/intro"
            return urlComponents.url!
        case .classifySubject:
            urlComponents.path = "/classify/subject"
            return urlComponents.url!
        case .classifySubjectIntroduce:
            urlComponents.path = "/classify/subject/intro"
            return urlComponents.url!
        case .roadmapMain:
            urlComponents.path = "/roadmap/main"
            return urlComponents.url!
        case .roadmapDetail:
            urlComponents.path = "/roadmap/detail"
            return urlComponents.url!
        case .roadmapJob:
            urlComponents.path = "/roadmap/job"
            return urlComponents.url!
            
        }
    }
}
