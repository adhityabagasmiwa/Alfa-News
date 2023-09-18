//
//  UIView+Extension.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 18/09/23.
//

import Foundation
import UIKit
import NVActivityIndicatorView

var loadingView: UIView?

extension UIView {
    
    class func initFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
    }
    
    func startLoadingAnimating() {
        loadingView = UIView(frame: self.bounds)
        guard let loadingView = loadingView else {
            return
        }
        loadingView.backgroundColor = .black.withAlphaComponent(0.1)
        
        let indicatorLoading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 48, height: 48), type: .ballScaleMultiple, color: .red, padding: 0)
        indicatorLoading.translatesAutoresizingMaskIntoConstraints = false
        indicatorLoading.startAnimating()
        
        loadingView.addSubview(indicatorLoading)
        addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            indicatorLoading.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicatorLoading.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func stopLoadingAnimating() {
        loadingView?.removeFromSuperview()
    }
}
