//
//  NewsManager.swift
//  NewsApp
//
//  Created by Shagara F Nasution on 08/06/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import Foundation

protocol NewsManagerDelegate {
    func didUpdateNews(_ newsMager: NewsManager, news: NewsModel)
}

struct NewsManager {
    let originURL = "https://newsapi.org/v2/top-headlines?country=id&apiKey=84af8b3c37c044ca8f0ce4e70f632d2a"
    
    var delegate: NewsManagerDelegate?
    
    func fetchNews(q: String?, category: NewsCategory, page: Int) {
        let urlString = "\(originURL)&q=\(q ?? "")&category=\(category == .top ? "" : category.rawValue)&page=\(page)"

        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
               
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    
                    if let news = self.parseJSON(newsData: safeData) {
                        
                        self.delegate?.didUpdateNews(self, news: news)
                        
                    }
                    
                }
            }
            
            task.resume()
            
        }
    }
    
    func parseJSON(newsData: Data) -> NewsModel? {
        
        let decoder = JSONDecoder()
        
        do {
            let news = try decoder.decode(NewsData.self, from: newsData)
            

            let totalResults = news.totalResults
            let articles = news.articles
             
            let newsModel = NewsModel(totalResult: totalResults, articles: articles)

            
            return newsModel
        } catch {
            print("Fail when decoding data from JSON, \(error).")
            
            return nil
        }
        
    }
}
