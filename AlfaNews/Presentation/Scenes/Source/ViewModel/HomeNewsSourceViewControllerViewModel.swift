//
//  HomeNewsSourceViewModel.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import Foundation
import RxSwift

class HomeNewsSourceViewModel: HomeNewsSourceViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    
    weak var delegate: HomeNewsSourceProtocolDelegate?
    
    var newsSources: [Source]? = []
    var newsCategoryChips: [NewsCategory] = []
    var selectedNewsCategory: NewsCategory = NewsCategory(id: 1, title: NewsCategoryEnum.business)
    
    var isLoading: Bool = false {
        didSet {
            self.delegate?.notifyLoadingStateChanged()
        }
    }
    
    init() {
        initNewsCategoryData()
    }
    
    func fetchNewsSources(request: NewsRequestPayload) {
        isLoading = true
        
        NewsApiConnector.shared.getNewsSources(request: request).do().do(onNext: { data in
            self.newsSources = self.getNewsSources(query: request.query, data: data.sources)
            self.delegate?.onSuccessGetNewsSources()
            
            self.isLoading = false
        }, onError: { error in
            if let error = error as? CustomError {
                self.delegate?.onErrorGetNewsSources(error: error)
                
                self.isLoading = false
            }
        }).subscribe().disposed(by: disposeBag)
    }
}

extension HomeNewsSourceViewModel {
    
    private func initNewsCategoryData() {
        let categories: [NewsCategoryEnum] = [.business, .entertainment, .general, .health, .science, .sports, .technology]
        
        for (index, categories) in categories.enumerated() {
            let idx = index + 1
            newsCategoryChips.append(NewsCategory(id: idx, title: categories))
        }
    }
    
    private func getNewsSources(query: String?, data: [Source]) -> [Source] {
        if query != nil {
            return data.filter { $0.name.contains(query!) || ($0.description ?? "").contains(query!) }
        }
        
        return data
    }
}
