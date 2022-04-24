//
//  NewFeedCell.swift
//  TodoList
//
//  Created by 이청준 on 2022/04/14.
//

import UIKit

//셀에서프로토콜선언 ->구현은 뷰컨트롤에서
protocol firstTabVCCellDelegate: AnyObject{
//    func didTapButton()
    // 좋아요버튼이 눌릴때, index값과, Bool값을 저장한다.
    func didPressHeart(for index: Int, like: Bool)
}


class NewFeedCell: UITableViewCell {
    //델리게이트생성
    weak var delegate: firstTabVCCellDelegate?
    var index: Int?
     
    static let identifier = "NewFeedCell"
    
    static func nib() ->UINib {
        return UINib(nibName: "NewFeedCell", bundle: nil)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
          // 여기서 버튼에 액션 추가
          self.likeBtn.addTarget(self, action: #selector(didPressedHeart(_:)), for: .touchUpInside)
      }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    //좋아요 버튼정의
    @IBOutlet var likeBtn: UIButton!
    //like버튼 직접연결하는 부분***********************************************************
    @IBAction func didPressedHeart(_ sender: UIButton) {
        guard let idx = index else {return}
                if sender.isSelected {
                    isTouched = true
                    // 메인에서didPressHeart 함수를 실행
                    delegate?.didPressHeart(for: idx, like: true)
                }else {
                    isTouched = false
                    delegate?.didPressHeart(for: idx, like: false)
                }
                sender.isSelected = !sender.isSelected
        
//        likeClicked()
    }
    
    var isTouched: Bool? {
           didSet {
               if isTouched == true {
                   likeBtn.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
               }else{
                   likeBtn.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
               }
           }
       }
    
    // 위임해줄 기능을 미리 구현해두어 버튼에 액션 추가
//       @objc func likeClicked() {
           // 뷰컨에서 실행할 didTapButton을 작성함
         
//           delegate?.didPressHeart()
//       }
    

    @IBOutlet weak var num: UILabel!
    
    @IBOutlet weak var imageViewLabel: UIImageView!
    // 이름
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
    //글설명
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
