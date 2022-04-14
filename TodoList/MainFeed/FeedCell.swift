//
//  FeedCell.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/21.
//
import UIKit


// 범용성을 위해 class가 아닌 AnyObject로 선언해준다.
protocol ContentsMainTextDelegate: AnyObject {
    // 위임해줄 기능
    func categoryButtonTapped()
}

// 글가져오기할때 모델 쏄
class FeedCell: UITableViewCell{
    
    var cellDelegate: ContentsMainTextDelegate?
     
   
    
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
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet{
            descriptionLabel.font = .systemFont(ofSize: 13, weight: .light)
        }
    }
    @IBOutlet weak var priceLabel: UILabel!{
        didSet{
            priceLabel.font = .systemFont(ofSize: 13, weight: .light)
        }
    }


}

