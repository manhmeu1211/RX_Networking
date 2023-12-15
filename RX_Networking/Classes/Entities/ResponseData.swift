//
//  ResponseData.swift
//  RX_Networking
//
//  Created by Luong Manh on 15/12/2023.
//

import AVFoundation
import Then

struct ResponseData<T: Codable>: Codable {
    var pagination: Pagination?
    var data: T?
    var message: String?
    var status: String?
    var code: String?
    var version: String?
}

struct MessageResponse: Codable {
    var message: String?
    var status: Int?
}

struct Pagination: Codable {
    var currentPage: Int?
    var nextPage: Int?
    var prevPage: Int?
    var totalRecord: Int?
    
    enum CodingKeys: String, CodingKey {
        case prevPage = "prev_page"
        case currentPage = "current_page"
        case nextPage = "next_page"
        case totalRecord = "total_record"
    }
}

struct PagingInfo<T>: Then {
    var page: Int
    var items: [T]
    var hasMorePages: Bool
    
    init(page: Int = 1, items: [T] = [], hasMorePages: Bool = false) {
        self.page = page
        self.items = items
        self.hasMorePages = hasMorePages
    }
}

