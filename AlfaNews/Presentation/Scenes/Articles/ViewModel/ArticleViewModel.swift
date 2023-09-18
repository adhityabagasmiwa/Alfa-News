//
//  ArticleViewModel.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 18/09/23.
//

import Foundation
import RxSwift

class ArticleViewModel: ArticleViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    
    weak var delegate: ArticleProtocolDelegate?
    
    var newsEverything: NewsHeadlines?
    
    var isLoading: Bool = false {
        didSet {
            self.delegate?.notifyLoadingStateChanged()
        }
    }

    func fetchArticles(request: NewsRequestPayload) {
        isLoading = true
        
        NewsApiConnector.shared.getNewsEverything(request: request).do(onNext: { data in
            self.newsEverything = data
            self.delegate?.onSuccessGetArticles()
            
            self.isLoading = false
        }, onError: { error in
            if let error = error as? CustomError {
                self.delegate?.onErrorGetArticles(error: error)
                
                self.isLoading = false
            }
        }).subscribe().disposed(by: disposeBag)
    }
}
