//
//  DetailViewCellTableViewCell.swift
//  TodoList
//
//  Created by 이청준 on 2022/04/29.
//

import UIKit

class DetailViewCell: UITableViewCell {
    
    //댓글작성아이디
    @IBOutlet var replyId: UILabel!{
        didSet{
            replyId.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
    }
    //댓글내용
    @IBOutlet var replyText: UILabel!
    //댓글날짜
    @IBOutlet var replyDate: UILabel!{
        didSet{
            replyDate.font = UIFont.systemFont(ofSize: 14, weight: .light)
        }
    }
    
    static let identifier = "DetailViewCell"
    
    
    @IBOutlet var trash: UIButton!
    //삭제버튼
    @IBAction func trashBtn(_ sender: Any) {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
