//
//  NewsListViewController+UITableView.swift
//  NewsApp
//
//  Created by Shagara F Nasution on 20/07/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import UIKit

//MARK: - Table View Data Source Methods

extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return articles.count
        } else if section == 1 && isPageDoesNotMeetMaxPage {
            return 1
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.NewsCell.cellIdentifier, for: indexPath) as! NewsCell
            let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .large)
            
            
            let article = articles[indexPath.row]
            
            tableView.isUserInteractionEnabled = true
            tableView.separatorStyle = .singleLine
            
            cell.title?.text = article.title
            cell.author?.text = article.author
            cell.publishedDate?.text = article.publishedDateToDisplay
            cell.rightImage.sd_setImage(with: URL(string: article.urlToImage ?? ""), placeholderImage: UIImage(systemName: K.imagePhotoName, withConfiguration: config))
            cell.wrapperContent.isHidden = false
            cell.emptyText.isHidden = true
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: K.LoadingCell.cellIdentifier, for: indexPath) as! LoadingCell
            
            cell.loadingIndicator.startAnimating()
            
            tableView.separatorStyle = .none
            
            return cell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
}

//MARK: - Table View Delegate Methods

extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destionationVC = DetailViewController()
        
        destionationVC.articleURL = articles[indexPath.row].url
        
        self.navigationController?.pushViewController(destionationVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        
        
        if (distanceFromBottom < height) && !isLoading {
            if !isLoading && isPageDoesNotMeetMaxPage {
                
                isLoading = true

                newsQueryParam.updatePage(byAdding: 1)
                
                DispatchQueue.global().async {
                    
                    // Fake background loading task for 2 seconds
                    sleep(2)
                    
                    self.newsManager.fetchNews(q: nil, category: self.newsQueryParam.category, page: self.newsQueryParam.page)
                    
                }
            }
        }
    }
}
