//
//  RequestError.swift
//  RX_Networking
//
//  Created by Luong Manh on 15/12/2023.
//

import Foundation

public struct RequestError: LocalizedError {
    public let statusCode: Int?
    public let message: String?
    
    public init(statusCode: Int?, message: String?) {
        self.statusCode = statusCode
        self.message = message
    }
    
    public var errorDescription: String? {
        return NSLocalizedString("api.requestError",
                                 value: message ?? "",
                                 comment: "")
    }
}
