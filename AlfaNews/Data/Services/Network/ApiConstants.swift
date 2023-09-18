//
//  ApiConstants.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import Foundation

enum ApiConstants {
    static let apiKey = "00e9292969f64db7b1da451d3ebcbb39"
}

enum ApiURL: String {
    case baseURL = "https://newsapi.org/v2/"
}

enum Endpoint: String {
    case everything = "everything"
    case topHeadlines = "top-headlines"
    case sources = "sources"
}
