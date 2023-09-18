//
//  String+Extension.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import UIKit

extension String {
    
    func toInt() -> Int {
        return Int(self) ?? 0
    }
    
    func generateTextToUIImage() -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 128, height: 128)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .red
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
        let text = self
        if text.count > 2 {
            let truncatedName = String(text.prefix(2))
            nameLabel.text = truncatedName
        }
        
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            
            return nameImage
        }
        
        return nil
    }

}
