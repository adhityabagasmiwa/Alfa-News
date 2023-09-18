//
//  ArticleProtocol.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 18/09/23.
//

import Foundation

protocol ArticleProtocolDelegate: AnyObject {
    func onSuccessGetArticles()
    func onErrorGetArticles(error: CustomError)
    
    func notifyLoadingStateChanged()
}

protocol ArticleViewModelProtocol: AnyObject {
    var newsEverything: NewsHeadlines? { get set }
    
    var isLoading: Bool { get set }
}
