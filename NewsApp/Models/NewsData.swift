//
//  NewsData.swift
//  NewsApp
//
//  Created by Shagara F Nasution on 08/06/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import Foundation

struct NewsData: Decodable {
    let totalResults: Int
    let articles: [Article]
}

struct Article: Decodable {
    let author: String?
    let title: String
    let url: String
    let urlToImage: String?
    let publishedAt: String?
}
