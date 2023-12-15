//
//  FileUpload.swift
//  RX_Networking
//
//  Created by Luong Manh on 15/12/2023.
//

import Foundation

public struct FileUpload {
    var name: String
    var file: URL
    var key: String
    
    public init(name: String, file: URL, key: String = "files") {
        self.name = name
        self.file = file
        self.key = key
    }
}
