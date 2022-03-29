//
//  FeedCell.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/21.
//

import UIKit

class FeedCell: UITableViewCell{
    
    @IBOutlet weak var imageViewLabel: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.font = UIFont.systemFont(ofSize: 24,weight: .medium)
        }
    }
    @IBOutlet weak var dataLabel: UILabel!{
        didSet{
            dataLabel.font = .systemFont(ofSize: 13, weight: .light)
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
}
