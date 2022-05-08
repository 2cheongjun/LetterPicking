//
//  DetailViewCellTableViewCell.swift
//  TodoList
//
//  Created by 이청준 on 2022/04/29.
//

import UIKit

protocol detailViewCellDelegate: AnyObject{
    
}

class DetailViewCell: UITableViewCell {
    // 델리게이트 생성
    weak var delegate: detailViewCellDelegate?
    var index2: IndexPath? // 게시글인덱스
    
    static let identifier = "DetailViewCell"
    static func nib() ->UINib {
        return UINib(nibName: "DetailViewCell", bundle: nil)
    }
    
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
