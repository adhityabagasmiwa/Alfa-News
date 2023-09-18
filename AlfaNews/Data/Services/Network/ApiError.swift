//
//  ApiError.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import Foundation

enum APIError: String, Error {
    case invalidData = "The data received from server is invalid, please try again"
    case invalidResponse = "Invalid response from server"
}

enum CommonErrorDesc: String {
    case invalidConvertJSON = "Failed to convert Data to String"
    case fatalError = "Oopss, something wrong!"
    case connection = "Oopss, please check your network settings."
}

enum CommonErrorTitle: String {
    case connection = "No Internet Connection"
    case common = "Error"
}

protocol APIErrorProtocol: LocalizedError {
    var status: String? { get }
    var code: String? { get }
}

struct CustomError: APIErrorProtocol, Decodable {
    var status: String?
    var code: String?
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case code
        case message
    }
    
    init(status: String?, code: String?, message: String) {
        self.status = status ?? "error"
        self.code = code
        self.message = message
    }
}
