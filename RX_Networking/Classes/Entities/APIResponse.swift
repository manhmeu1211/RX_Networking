//
//  APIResponse.swift
//  RX_Networking
//
//  Created by Luong Manh on 15/12/2023.
//


import Foundation

public struct APIResponse<T: Codable>: Codable {
    public var data: T?
    public var message: String?
    public var statusCode: Int?
    
    enum CodingKeys: CodingKey {
        case data
        case message
        case statusCode
    }
    
    init(data: T?,
         message: String?,
         statusCode: Int?
    ) {
        self.data = data
        self.message = message
        self.statusCode = statusCode
    }
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<APIResponse<T>.CodingKeys> = try decoder.container(keyedBy: APIResponse<T>.CodingKeys.self)
        
        if let data = try? container.decodeIfPresent(T.self, forKey: APIResponse<T>.CodingKeys.data) {
            self.data = data
        } else {
            data = nil
        }
        
        self.message = try container.decodeIfPresent(String.self, forKey: APIResponse<T>.CodingKeys.message)
        self.statusCode = try container.decodeIfPresent(Int.self, forKey: APIResponse<T>.CodingKeys.statusCode)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: APIResponse<T>.CodingKeys.self)
        try container.encodeIfPresent(self.data, forKey: .data)
        try container.encodeIfPresent(self.message, forKey: .message)
        try container.encodeIfPresent(self.statusCode, forKey: .statusCode)
    }
}
