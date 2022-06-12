//
//  HeartReplyCell.swift
//  TodoList
//
//  Created by 이청준 on 2022/05/15.
//

import UIKit
// 좋아요북마크 -> 디테일뷰창의 댓글 셀
protocol HeartReplyCellDelegate: AnyObject{
    func onClickCell(index: Int)
    func onClickReportCell(index: Int)
}

class HeartReplyCell: UITableViewCell {

    // 델리게이트 생성
       weak var delegate: HeartReplyCellDelegate?
       var index: IndexPath? // 게시글인덱스
       
       static let identifier = "HeartReplyCell"
       static func nib() ->UINib {
           return UINib(nibName: "HeartReplyCell", bundle: nil)
       }
       
      // 초기화
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
    
    // 신고버튼
    @IBOutlet var report: UIButton!
    
    @IBAction func reportBtn(_ sender: Any) {
        delegate?.onClickReportCell(index: (index?.row)!)
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
