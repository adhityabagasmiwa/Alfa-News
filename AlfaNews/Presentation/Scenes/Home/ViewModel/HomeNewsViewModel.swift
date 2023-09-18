//
//  HomeNewsViewModel.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import Foundation
import RxSwift

class HomeNewsViewModel: HomeNewsViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    
    weak var delegate: HomeNewsProtocolDelegate?
    
    var newsCategoryChips: [NewsCategory] = []
    var newsHeadlines: NewsHeadlines?
    var breakingNews: Article?
    var selectedNewsCategory: NewsCategory = NewsCategory(id: 1, title: NewsCategoryEnum.business)
    
    var isLoading: Bool = false {
        didSet {
            self.delegate?.notifyLoadingStateChanged()
        }
    }
    
    init() {
        initNewsCategoryData()
    }
    
    func fetchNewsHeadlines(request: NewsRequestPayload) {
        isLoading = true
        
        NewsApiConnector.shared.getNewsHeadlines(request: request).do(onNext: { data in
            let result: NewsHeadlines = data
            let articles: [Article] = result.articles.removingFirstElement().filter { !($0.title.lowercased().contains("remove")) }
            self.newsHeadlines = NewsHeadlines(status: result.status, totalResults: result.totalResults, articles: articles)
            
            self.getBreakingNews(data.articles)
            self.delegate?.onSuccessGetNews()
            
            self.isLoading = false
        }, onError: { error in
            if let error = error as? CustomError {
                self.delegate?.onErrorGetNews(error: error)
                
                self.isLoading = false
            }
        }).subscribe().disposed(by: disposeBag)
    }
}

extension HomeNewsViewModel {
    
    private func getBreakingNews(_ data: [Article]) {
        if data.count > 0 {
            breakingNews = data.first
        }
    }
    
    private func initNewsCategoryData() {
        let categories: [NewsCategoryEnum] = [.business, .entertainment, .general, .health, .science, .sports, .technology]
        
        for (index, categories) in categories.enumerated() {
            let idx = index + 1
            newsCategoryChips.append(NewsCategory(id: idx, title: categories))
        }
    }
}
