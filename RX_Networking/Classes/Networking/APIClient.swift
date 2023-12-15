//
//  APIClient.swift
//  RX_Networking
//
//  Created by Luong Manh on 15/12/2023.
//

import Foundation
import RxSwift
import SwiftyJSON

public class APIClient {
    let bundle: APIBundle
    
    public init(bundle: APIBundle) {
        self.bundle = bundle
    }
}

public extension APIClient {
    func requestData(endpoint: EndPoint) -> Single<Data?> {
        do {
            var request = try APIRouter(endpoint: endpoint, bundle: bundle).asURLRequest()
            let params = ["bundle": bundle.bundleID]
            
            var jsonParams = JSON(params)
            
            if let body = request.httpBody {
                let bodyJSON = try JSON(data: body)
                jsonParams = try bodyJSON.merged(with: jsonParams)
            }
            
            request.httpBody = try? jsonParams.toData()
            
            return NetworkingManager.request(request)
        } catch {
            return .error(error)
        }
    }
    
    func request<T: Decodable>(type: T.Type, endpoint: EndPoint) -> Single<APIResponse<T>> {
        return requestData(endpoint: endpoint)
            .flatMap {
                Self.convertDataResponse(data: $0, to: T.self)
            }
    }
    
    func upload(params: UploadParams, progressBlock: ((Progress) -> Void)? = nil)
    -> Observable<UploadState<Data>>
    {
        let request = APIRouter(endpoint: .upload(category: params), bundle: bundle)
        let upload = NetworkingManager
            .upload(files: params.files, with: request)
        return upload
    }
    
    static func convertDataResponse<T: Decodable>(data: Data?, to type: T.Type) -> Single<APIResponse<T>> {
        guard let data = data else { return .just(
            APIResponse(data: nil,
                        message: "Something went wrong!",
                        statusCode: 409)
        )}
        do {
            let objects = try APIClient.convert(data: data,
                                                to: T.self)
            return .just(objects)
        } catch {
            debugPrint(error)
            return .error(error)
        }
    }
    
    static func convert<T: Decodable>(data: Data, to type: T.Type) throws -> APIResponse<T> {
        let json = try JSON(data: data)
        let jsonData = try json.toData()
        let objects = try JSONDecoder().decode(APIResponse<T>.self, from: jsonData)
        return objects
    }
}
