//
//  EndPoint.swift
//  RX_Networking
//
//  Created by Luong Manh on 15/12/2023.
//


import Foundation
import Alamofire

public enum EndPoint {
    case unknow
    
    var httpMethod: HTTPMethod {
        switch self {
        case .unknow:
            return .get
        default:
            return .post
        }
    }
    
    var parameters: Parameters? {
        var params: [String: Any] = [:]
        switch self {
        case .unknow:
            params[""] = ""
        }
        return params
    }
}

