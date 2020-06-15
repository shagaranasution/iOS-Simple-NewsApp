//
//  NewsModel.swift
//  NewsApp
//
//  Created by Shagara F Nasution on 15/06/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import Foundation

struct NewsModel {
    let totalResult: Int
    let articles: [Article]
    
    var formattedArticles: [ArticleModel] {
        let result = articles.map {
            ArticleModel(author: $0.author, title: $0.title, url: $0.url, urlToImage: $0.urlToImage, publishedAt: $0.publishedAt)
        }
        
        return result
    }
}

struct ArticleModel {
    let author: String?
    let title: String
    let url: String
    let urlToImage: String?
    let publishedAt: String?
    
    var publishedDateToDisplay: String? {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatterSet = DateFormatter()
        dateFormatterSet.dateFormat = "dd-MM-yyyy HH:mm"
        
        if publishedAt != nil {
            if let safeDate = dateFormatterGet.date(from: publishedAt!) {
                return dateFormatterSet.string(from: safeDate)
            }
        }
        
        return nil
    }
}
