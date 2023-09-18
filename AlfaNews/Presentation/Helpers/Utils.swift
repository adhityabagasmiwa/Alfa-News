//
//  Utils.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import Foundation

struct SwiftUtility {
    
    static func loadJSON(filename fileName: String) -> Data {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let dataObj = try Data(contentsOf: url)
                return dataObj
            } catch let error {
                debugPrint("[LOG - ERROR LOAD JSON]: ", error)
            }
        }
        
        return Data()
    }
    
    static func decodeJSON<T: Decodable>(_ jsonString: String, as type: T.Type) throws -> T {
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        let decodedObject = try decoder.decode(T.self, from: jsonData)

        return decodedObject
    }
}

