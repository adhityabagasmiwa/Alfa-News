//
//  Array+Extension.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import Foundation


extension Array {
    
    func removingFirstElement() -> Array {
        var newArray = self
        if !newArray.isEmpty {
            newArray.remove(at: 0)
        }
        
        return newArray
    }
}
