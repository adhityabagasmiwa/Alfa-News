//
//  HomeNewsProtocol.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import Foundation

protocol HomeNewsProtocolDelegate: AnyObject {
    func onSuccessGetNews()
    func onErrorGetNews(error: CustomError)
    
    func notifyLoadingStateChanged()
}

protocol HomeNewsViewModelProtocol: AnyObject {
    var newsHeadlines: NewsHeadlines? { get set }
    var breakingNews: Article? { get set }
    var newsCategoryChips: [NewsCategory] { get set }
    var selectedNewsCategory: NewsCategory { get set }
    
    var isLoading: Bool { get set }
}
