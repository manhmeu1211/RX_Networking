//
//  UploadParams.swift
//  RX_Networking
//
//  Created by Luong Manh on 15/12/2023.
//

import Foundation

public struct UploadParams {
    public var params: UploadContent
    public var files: [FileUpload]
    
    public init(params: UploadContent, files: [FileUpload]) {
        self.params = params
        self.files = files
    }
}
