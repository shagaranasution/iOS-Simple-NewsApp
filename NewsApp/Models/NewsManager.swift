//
//  NewsManager.swift
//  NewsApp
//
//  Created by Shagara F Nasution on 08/06/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import Foundation

protocol NewsManagerDelegate {
    func didUpdateNews(_ newsMager: NewsManager, newsData: NewsData)
}

struct NewsManager {
    let originURL = "https://newsapi.org/v2/top-headlines?country=id&apiKey=84af8b3c37c044ca8f0ce4e70f632d2a"
    
    var delegate: NewsManagerDelegate?
    
    func fetchNews(q: String?, category: String?, page: Int) {
        let urlString = "\(originURL)&q=\(q ?? "")&category=\(category ?? "")&page=\(page)"

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
                    
                    if let newsData = self.parseJSON(newsData: safeData) {
                        
                        self.delegate?.didUpdateNews(self, newsData: newsData)
                        
                    }
                    
                }
            }
            
            task.resume()
            
        }
    }
    
    func parseJSON(newsData: Data) -> NewsData? {
        
        let decoder = JSONDecoder()
        
        do {
            let news = try decoder.decode(NewsData.self, from: newsData)
            
            return news
        } catch {
            print("Fail when decoding data from JSON, \(error).")
            
            return nil
        }
        
    }
}
