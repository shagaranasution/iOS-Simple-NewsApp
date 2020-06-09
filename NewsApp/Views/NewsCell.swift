//
//  NewsCell.swift
//  NewsApp
//
//  Created by Shagara F Nasution on 08/06/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var publishedDate: UILabel!
    @IBOutlet weak var emptyPlaceholder: UILabel!
    
    @IBOutlet weak var wrapperContent: UIStackView!
    @IBOutlet weak var rightImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
