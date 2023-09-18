//
//  Date+Extension.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import Foundation

extension Date {
    
    func toString(format dateFormat: String? = "MMM d, yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        let formattedDate = dateFormatter.string(from: self)
        
        return formattedDate
    }
}
