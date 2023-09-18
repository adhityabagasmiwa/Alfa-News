//
//  NewsRequest.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import Foundation

struct NewsRequestPayload {
    var page: Int?
    var pageSize: Int?
    var query: String?
    var category: NewsCategoryEnum?
    var sources: String?
    var sortBy: NewsCategoryEnum?
    var from: String?
    var to: String?
}
