//
//  Enums.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import Foundation

enum NewsCategoryEnum: String {
    case business = "business"
    case entertainment = "entertainment"
    case general = "general"
    case health = "health"
    case science = "science"
    case sports = "sports"
    case technology = "technology"
    case none
}

enum NewsSortByEnum: String {
    case relevancy = "relevancy"
    case popularity = "popularity"
    case publishedAt = "publishedAt"
}
