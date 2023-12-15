//
//  UploadContent.swift
//  RX_Networking
//
//  Created by Luong Manh on 15/12/2023.
//

import Foundation

public struct UploadContent: Encodable {
    public var type: ContentType = .something
    public var filterUrl: String?
    public var bundle: APIBundle = .unknow

    public init(filterUrl: String?) {
        self.filterUrl = filterUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case filterUrl = "fileurl"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.filterUrl, forKey: .filterUrl)
    }
}
