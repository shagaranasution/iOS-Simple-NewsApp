//
//  NewsListViewController.swift
//  NewsApp
//
//  Created by Shagara F Nasution on 08/06/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SDWebImage

class NewsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isLoading = false
    
    var comeByPressingSearchBarInHome = false
    
    var category: String?
    
    var page = 1
    
    var isPageDoesNotMeetMaxPage = false
    
    var totalArticle: Int? {
        didSet {
            let maxPage = Int(ceil(Double(totalArticle!) / 20.0))

            isPageDoesNotMeetMaxPage = page < maxPage ? true : false
        }
    }
    
    var articles = [ArticleModel]()
    
    var newsManager = NewsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "ReusableNewsCell")
        
        tableView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingIndicatorCell")
        
        tableView.dataSource = self
        
        tableView.delegate = self
        
        newsManager.delegate = self
        
        searchBar.delegate = self
        
        searchBar.placeholder = "Search news here.."
        
        if !comeByPressingSearchBarInHome {
            searchBar.isHidden = true
            searchBar.heightAnchor.constraint(equalToConstant: 0).isActive = true
            newsManager.fetchNews(q: nil, category: category, page: page)
        } else {
            self.navigationItem.title = "Search"
            self.searchBar.becomeFirstResponder()
        }
        
    }
    
}

//MARK: - Table View Data Source Methods

extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if articles.count > 0 {
                return articles.count
            } else {
                return 1
            }
        } else if section == 1 && isPageDoesNotMeetMaxPage {
            return 1
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableNewsCell", for: indexPath) as! NewsCell
            let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .large)
            
            if articles.count > 0 {
                let article = articles[indexPath.row]
                
                tableView.isUserInteractionEnabled = true
                tableView.separatorStyle = .singleLine
                
                cell.title?.text = article.title
                cell.author?.text = article.author
                cell.publishedDate?.text = article.publishedDateToDisplay
                cell.rightImage.sd_setImage(with: URL(string: article.urlToImage ?? ""), placeholderImage: UIImage(systemName: "photo", withConfiguration: config))
                cell.wrapperContent.isHidden = false
                cell.emptyPlaceholder.isHidden = true

            } else {
                tableView.isUserInteractionEnabled = false
                tableView.separatorStyle = .none
              
                cell.wrapperContent.isHidden = true
                cell.emptyPlaceholder.isHidden = false
                cell.emptyPlaceholder?.text = "No news to display."
                
            }
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingIndicatorCell", for: indexPath) as! LoadingCell
            
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
                self.page += 1
                
                DispatchQueue.global().async {
                    
                    // Fake background loading task for 2 seconds
                    sleep(2)
                    
                    self.newsManager.fetchNews(q: nil, category: self.category, page: self.page)
                    
                }
            }
        }
    }
}

//MARK: - News Manager Delegate Methods

extension NewsListViewController: NewsManagerDelegate {
    func didUpdateNews(_ newsMager: NewsManager, news: NewsModel) {
        let totalArticle = news.totalResult
        let articles = news.formattedArticles
        
        self.totalArticle = totalArticle
        self.articles.append(contentsOf: articles)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.isLoading = false
        }
    }
}

//MARK: - Search Bar Delegate Methods

extension NewsListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        articles = []
        
        newsManager.fetchNews(q: searchBar.text, category: nil, page: 1)
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            articles = []
            totalArticle = 0

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            self.tableView.reloadData()
            
        }
        
    }
    
}

//MARK: - Tab Bar Page Methods

extension NewsListViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let title = category != nil ? category!.capitalized : "Top News"
        return IndicatorInfo(title: title)
    }
}
