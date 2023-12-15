//
//  APIRouter.swift
//  RX_Networking
//
//  Created by Luong Manh on 15/12/2023.
//


import Foundation
import Alamofire

public struct APIRouter: URLRequestConvertible {
    var endpoint: EndPoint
    var bundle: APIBundle
    
    // MARK: - URLRequestConvertible
    public func asURLRequest() throws -> URLRequest {
        let path = bundle.path(for: endpoint)
        let baseURL = bundle.baseURL
        let url = URL(string: "\(baseURL)/\(path)")!
        let method = endpoint.httpMethod
        
        var urlRequest = URLRequest(url: url)
        
        // Http method
        urlRequest.httpMethod = method.rawValue
        
        for header in APIConfig.defaultHeaders {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        urlRequest.timeoutInterval = APIConfig.timeoutInterval
        
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: endpoint.parameters)
    }
}
