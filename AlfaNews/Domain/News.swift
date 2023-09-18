//
//  News.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import Foundation

struct NewsHeadlines: Decodable {
    let status: String
    let totalResults: Int
    var articles: [Article]
    
    init(status: String, totalResults: Int, articles: [Article]) {
        self.status = status
        self.totalResults = totalResults
        self.articles = articles
    }
}

struct NewsSource: Decodable {
    let status: String
    var sources: [Source]
    
    init(status: String, sources: [Source]) {
        self.status = status
        self.sources = sources
    }
}

struct Source: Decodable {
    let id: String?
    let name: String
    let description: String?
    let url: String?
    let category: String?
    let language: String?
    let country: String?
    
    init(id: String?, name: String, description: String?, url: String?, category: String?, language: String?, country: String?) {
        self.id = id
        self.name = name
        self.description = description
        self.url = url
        self.category = category
        self.language = language
        self.country = country
    }
}

struct Article: Decodable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: Date
    let content: String?
    
    init(source: Source, author: String?, title: String, description: String?, url: String, urlToImage: String?, publishedAt: Date, content: String?) {
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
}
