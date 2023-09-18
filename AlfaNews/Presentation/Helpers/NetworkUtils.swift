//
//  NetworkUtils.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 18/09/23.
//

import Foundation
import Alamofire

class NetworkUtilsReachabilityManager {
    
    static let shared = NetworkUtilsReachabilityManager()
    private init() {}
    
    let manager = NetworkReachabilityManager(host: "www.apple.com")
    fileprivate var isInternetReachable = false
    
    func startMonitoring() {
        manager?.startListening(onQueue: DispatchQueue.main, onUpdatePerforming: { (status) in
            switch status {
                case .notReachable:
                    self.isInternetReachable = false
                case .reachable(.ethernetOrWiFi):
                    self.isInternetReachable = true
                case .reachable(.cellular):
                    self.isInternetReachable = true
                default:
                    self.isInternetReachable = false
                    break
            }
            
            NotificationCenter.default.post(name: .networkStatusChanged, object: status)
        })
    }
}
