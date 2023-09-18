//
//  ApiService.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import Foundation
import Alamofire

class ApiService: NSObject {
    
    let manager: ApiManager
    
    override init() {
        let configuration = URLSessionConfiguration.af.default
        configuration.headers = HTTPHeaders.default
        configuration.timeoutIntervalForRequest = 60*8
        manager = ApiManager.init(configuration: configuration)
        
        super.init()
    }
}

class ApiManager: Session {
    
    internal override func request(
        _ convertible: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        interceptor: RequestInterceptor? = nil,
        requestModifier: Session.RequestModifier? = nil
    ) -> DataRequest {
        var overridedParameters = [String : AnyObject]()
        
        if let parameters = parameters {
            overridedParameters = parameters as [String : AnyObject]
        }
        
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": "Bearer \(ApiConstants.apiKey)"
        ]
        
        return super.request(
            "\(ApiURL.baseURL.rawValue)\(convertible)",
            method: method,
            parameters: overridedParameters,
            encoding: encoding,
            headers: headers,
            interceptor: interceptor,
            requestModifier: requestModifier
        ).customValidateDataRequest()
    }
}

