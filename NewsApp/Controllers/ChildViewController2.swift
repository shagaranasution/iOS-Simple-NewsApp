//
//  ChildViewController2.swift
//  NewsApp
//
//  Created by Shagara F Nasution on 07/06/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ChildViewController2: UIViewController, IndicatorInfoProvider {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Child 2")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
