//
//  DataRequest+Extension.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import Foundation
import Alamofire
import RxSwift

extension DataRequest {
    
    func rx_JSON<T: Decodable>(as type: T.Type) -> Observable<T> {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        
        let observable = Observable<T>.create { observer in
            
            self.responseDecodable(of: type, decoder: decoder, completionHandler: { response in
                switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                    case .failure(let error):
                        switch error {
                            case .responseValidationFailed(reason: let reason):
                                observer.onError(self.extractErrorMessage(reason: reason))
                            default:
                                observer.onError(error)
                        }
                }
            })
            
            return Disposables.create()
        }
        
        return Observable.deferred { return observable }
    }
    
    func customValidateDataRequest() -> Self {
        
        return validate { request, response, data in
            let success = 200...299
            let statusCode = response.statusCode.toString()
            
            guard let jsonData = data else {
                return .failure(CustomError(status: nil, code: statusCode, message: APIError.invalidData.rawValue))
            }
            
            do {
                guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                    throw CustomError(status: nil, code: nil, message: CommonErrorDesc.invalidConvertJSON.rawValue)
                }
                
                if success.contains(response.statusCode) {
                    return .success(())
                } else {
                    let decodedObject = try SwiftUtility.decodeJSON(jsonString, as: CustomError.self)
                    return .failure(CustomError(status: decodedObject.message, code: decodedObject.code, message: decodedObject.message))
                }
            } catch {
                return .failure(CustomError(status: nil, code: nil, message: CommonErrorDesc.fatalError.rawValue))
            }
        }
    }
    
    private func extractErrorMessage(reason: AFError.ResponseValidationFailureReason) -> Error {
        switch reason {
            case .customValidationFailed(let error):
                return error
            default:
                return CustomError(status: nil, code: nil, message: CommonErrorDesc.fatalError.rawValue)
        }
    }

}
