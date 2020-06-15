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
    
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = purpleInspireColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = self?.purpleInspireColor
        }
        
        searchBar.delegate = self
        
        searchBar.placeholder = "Search news here.."
        
        self.navigationItem.title = "News"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        searchBar.resignFirstResponder()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let topNews = NewsListViewController()
        topNews.category = nil
        
        let businessNews = NewsListViewController()
        businessNews.category = "business"
        
        let technologyNews = NewsListViewController()
        technologyNews.category = "technology"
        
        let entertainmentNews = NewsListViewController()
        entertainmentNews.category = "entertainment"
        
        let healthNews = NewsListViewController()
        healthNews.category = "health"
        
        return [topNews, businessNews, technologyNews, entertainmentNews, healthNews]

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
