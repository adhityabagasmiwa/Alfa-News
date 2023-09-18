//
//  NewsApiConnector.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import Foundation
import RxSwift

class NewsApiConnector: ApiService {
    
    static let shared = NewsApiConnector()
    
    func getNewsHeadlines(request: NewsRequestPayload) -> Observable<NewsHeadlines> {
        var parameters: [String: Any] = [:]
        parameters["country"] = "us"
        parameters["page"] = request.page
        parameters["pageSize"] = request.pageSize
        
        if let category = request.category {
            parameters["category"] = category.rawValue.lowercased()
        }
        
        if let source = request.sources {
            parameters["sources"] = source
        }
        
        if let query = request.query {
            parameters["q"] = query
        }
        
        let request = manager.request(Endpoint.topHeadlines.rawValue, method: .get, parameters: parameters)
        
        return request.rx_JSON(as: NewsHeadlines.self).map { response in
            return response
        }
    }
    
    func getNewsSources(request: NewsRequestPayload) -> Observable<NewsSource> {
        var parameters: [String: Any] = [:]
        parameters["country"] = "us"
        parameters["category"] = request.category?.rawValue.lowercased()
        
        let url = Endpoint.topHeadlines.rawValue + "/" + Endpoint.sources.rawValue
        let request = manager.request(url, method: .get, parameters: parameters)
        
        return request.rx_JSON(as: NewsSource.self).map { response in
            return response
        }
    }
    
    func getNewsEverything(request: NewsRequestPayload) -> Observable<NewsHeadlines> {
        var parameters: [String: Any] = [:]
        parameters["page"] = request.page
        parameters["pageSize"] = request.pageSize
        
        if let sortBy = request.sortBy {
            parameters["sortBy"] = sortBy.rawValue.lowercased()
        }
        
        if let source = request.sources {
            parameters["sources"] = source
        }
        
        if let fromDate = request.from {
            parameters["from"] = fromDate
        }
        
        if let toDate = request.to {
            parameters["to"] = toDate
        }
        
        if let query = request.query {
            parameters["q"] = query
        }
        
        let request = manager.request(Endpoint.everything.rawValue, method: .get, parameters: parameters)
        
        return request.rx_JSON(as: NewsHeadlines.self).map { response in
            return response
        }
    }
}
