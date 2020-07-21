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
    
    var newsQueryParam = NewsQueryParam()
    
    private(set) var isPageDoesNotMeetMaxPage = false
    
    private var totalArticle: Int? {
        didSet {
            let maxPage = Int(ceil(Double(totalArticle!) / 20.0))

            isPageDoesNotMeetMaxPage = newsQueryParam.page < maxPage ? true : false
        }
    }
    
    private(set) var articles = [ArticleModel]()
    
    private(set) var newsManager = NewsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: K.NewsCell.nibName, bundle: nil), forCellReuseIdentifier: K.NewsCell.cellIdentifier)
        
        tableView.register(UINib(nibName: K.LoadingCell.nibName, bundle: nil), forCellReuseIdentifier: K.LoadingCell.cellIdentifier)
        
        tableView.dataSource = self
        
        tableView.delegate = self
        
        newsManager.delegate = self
        
        searchBar.delegate = self
        
        searchBar.placeholder = K.Placeholder.searchBar
        
        if !comeByPressingSearchBarInHome {
            searchBar.isHidden = true
            searchBar.heightAnchor.constraint(equalToConstant: 0).isActive = true
            newsManager.fetchNews(q: nil, category: newsQueryParam.category, page: newsQueryParam.page)
        } else {
            self.navigationItem.title = K.Navigation.titleSearch
            self.searchBar.becomeFirstResponder()
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
        
        newsManager.fetchNews(q: searchBar.text, category: .top, page: 1)
        
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
        let title = newsQueryParam.category != .top ? newsQueryParam.category.rawValue.capitalized : K.NewsCategories.topName
        return IndicatorInfo(title: title)
    }
}
