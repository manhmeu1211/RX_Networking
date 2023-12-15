//
//  NetworkingManager.swift
//  RX_Networking
//
//  Created by Luong Manh on 15/12/2023.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

public enum NetworkingManager {
    static let maxAttempts = 3
    static let disposeBag = DisposeBag()
    // MARK: - The request function to get results in an Observable
    public static func request(_ request: URLRequestConvertible) -> Single<Data?> {
        // Create an RxSwift observable, which will be the one to call the request when subscribed to
        debugPrint("REQUEST: " + (String(describing: request.urlRequest)))
        if let params = request.urlRequest?.httpBody, let json = try? JSON(data: params) {
            debugPrint(json)
        }
        return .create { observer in
            // Trigger the HttpRequest using AlamoFire (AF)
            let request = AF.request(request)
            //                .validate(statusCode: 200..<300)
                .response { (response) in
                    let result = handleResponse(response)
                    switch result {
                    case .success(let value):
                        observer(.success(value))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    public static func upload(files: [FileUpload],
                              with request: URLRequestConvertible) -> Observable<UploadState<Data>> {
        
        debugPrint("Upload to: " + (String(describing: request.urlRequest?.url)))
        let urlRequest = request.urlRequest!
        return .create { obs in
            let uploadRequest = AF.upload(multipartFormData: { formData in
                for file in files {
                    formData.append(file.file, withName: file.key)
                }
                if let body = urlRequest.httpBody,
                   let params = try? JSONSerialization.jsonObject(with: body),
                   let json = params as? [String: Any] {
                    for (key, value) in json {
                        debugPrint("Param", key, value)
                        
                        if let bool = value as? Bool,
                           let data = try? bool.toData() {
                            formData.append(data, withName: key)
                        }
                        else {
                            formData.append(
                                (value as AnyObject)
                                    .data(using: String.Encoding.utf8.rawValue)!,
                                withName: key)
                        }
                    }
                }
            }, to: urlRequest.url!, method: urlRequest.method ?? .post, headers: urlRequest.headers)
                .uploadProgress { progress in
                    debugPrint("Uploading progress: \(progress.fractionCompleted)")
                    obs.onNext(.uploading(progress: progress))
                }
                .response { response in
                    let result = handleResponse(response)
                    switch result {
                    case .success(let value):
                        obs.onNext(.finished(data: value))
                        obs.onCompleted()
                    case .failure(let error):
                        obs.onError(error)
                    }
                }
            return Disposables.create {
                uploadRequest.cancel()
            }
        }
    }
    
    public static func handleResponse(_ response: AFDataResponse<Data?>) -> Result<Data?, Error> {
        switch response.result {
        case .success(let value):
            return .success(value)
        case .failure(let error):
            if let jsonData = response.data,
               let data = try? JSONDecoder().decode(ResponseData<String>.self, from: jsonData) {
                let error = RequestError(statusCode: 0, message: data.status)
                return .failure(error)
            } else if let statusCode = response.response?.statusCode {
                return .failure(APIError.error(statusCode))
            } else if let afError = error.asAFError,
                      case .sessionTaskFailed(let sessionError) = afError,
                      let urlError = sessionError as? URLError {
                return .failure(APIError.error(urlError.errorCode))
            } else {
                return .failure(error)
            }
        }
    }
    
    private static var decoder: JSONDecoder = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Cannot decode date string \(dateString)")
        }
        return decoder
    }()
}

public enum UploadState<T> {
    case uploading(progress: Progress)
    case finished(data: T?)
}
