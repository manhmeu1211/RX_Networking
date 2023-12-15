//
//  APIConfig.swift
//  RX_Networking
//
//  Created by Luong Manh on 15/12/2023.
//

import Foundation

struct APIConfig {
    static let apikey = ""
    static let encodeKey = ""
    
    static let timeoutInterval: Double = 30
    
    static var defaultHeaders: [String: String] {
        var headers: [String: String] = [:]
        
        for header in HttpHeaderField.allCases {
            headers[header.rawValue] = header.content
        }
        
        return headers
    }
}

extension APIConfig {
    
    // The header fields
    enum HttpHeaderField: String, CaseIterable {
        case apiKey
        case encodeKey
        
        var content: String {
            switch self {
            case .apiKey:
                return APIConfig.apikey
            case .encodeKey:
                return APIConfig.encodeKey
            }
        }
    }
}
