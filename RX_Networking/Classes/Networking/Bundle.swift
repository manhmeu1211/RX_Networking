//
//  Bundle.swift
//  RX_Networking
//
//  Created by Luong Manh on 15/12/2023.
//


import Foundation

public enum APIBundle: Int, Codable {
    case unknow
}

public extension APIBundle {
    var bundleID: String {
        switch self {
        case .unknow:
            return ""
        }
    }
    
    var baseURL: String {
        switch self {
        case .unknow:
            return ""
        }
    }
    
    var assetBaseURL: String {
        switch self {
        case .unknow:
            return ""
        }
    }
}

public extension APIBundle {
    func path(for endpoint: EndPoint) -> String {
        switch endpoint {
        case .unknow:
            return ""
        case .upload(params: let params):
            return ""
        }
    }
}
