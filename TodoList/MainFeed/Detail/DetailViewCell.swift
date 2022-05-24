//
//  DetailViewCellTableViewCell.swift
//  TodoList
//
//  Created by 이청준 on 2022/04/29.
//

import UIKit
// 댓글 삭제프로토콜 셀(휴지통아이콘 눌렀을때 액션)
protocol detailViewCellDelegate: AnyObject{
    func onClickCell(index: Int)
}

class DetailViewCell: UITableViewCell {
    // 델리게이트 생성
    weak var delegate: detailViewCellDelegate?
    var index: IndexPath? // 게시글인덱스
    
    static let identifier = "DetailViewCell"
    static func nib() ->UINib {
        return UINib(nibName: "DetailViewCell", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    // 댓글작성아이디
    @IBOutlet var replyId: UILabel!{
        didSet{
            replyId.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
    }
    // 댓글내용
    @IBOutlet var replyText: UILabel!
    // 댓글날짜
    @IBOutlet var replyDate: UILabel!{
        didSet{
            replyDate.font = UIFont.systemFont(ofSize: 14, weight: .light)
        }
    }
    
   
    // 삭제버튼
    @IBOutlet var trash: UIButton!
    
    // 삭제버튼액션
    @IBAction func trashBtn(_ sender: UIButton) {
        delegate?.onClickCell(index: (index?.row)!)
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
