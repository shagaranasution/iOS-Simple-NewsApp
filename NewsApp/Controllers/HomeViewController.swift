//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Shagara F Nasution on 07/06/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HomeViewController: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        configureButtonBar()
        
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        searchBar.resignFirstResponder()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let topNews = NewsListViewController()
        topNews.category = .top
        
        let businessNews = NewsListViewController()
        businessNews.category = .business
        
        let technologyNews = NewsListViewController()
        technologyNews.category = .technology
        
        let entertainmentNews = NewsListViewController()
        entertainmentNews.category = .entertainment
        
        let healthNews = NewsListViewController()
        healthNews.category = .health
        
        return [topNews, businessNews, technologyNews, entertainmentNews, healthNews]

    }
    
    func configureButtonBar() {
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 16)
        settings.style.selectedBarHeight = 3.0
        settings.style.selectedBarBackgroundColor = .label
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .label
            newCell?.label.textColor = .label
        }
    }
    
    func configureView() {
        self.navigationItem.title = K.Navigation.titleNews
        searchBar.placeholder = K.Placeholder.searchBar
    }
    
}

//MARK: - Search Bar Delegate Methods

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let destinationVC = NewsListViewController()

        self.navigationController?.pushViewController(destinationVC, animated: true)

        destinationVC.comeByPressingSearchBarInHome = true
    }

}
