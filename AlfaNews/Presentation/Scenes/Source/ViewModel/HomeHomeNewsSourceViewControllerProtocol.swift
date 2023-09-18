//
//  HomeNewsSourceProtocol.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import Foundation

protocol HomeNewsSourceProtocolDelegate: AnyObject {
    func onSuccessGetNewsSources()
    func onErrorGetNewsSources(error: CustomError)
    
    func notifyLoadingStateChanged()
}

protocol HomeNewsSourceViewModelProtocol: AnyObject {
    var newsSources: [Source]? { get set }
    var newsCategoryChips: [NewsCategory] { get set }
    var selectedNewsCategory: NewsCategory { get set }
    
    var isLoading: Bool { get set }
}
