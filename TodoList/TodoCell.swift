//
//  TodoCellTableViewCell.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/01.
//

import UIKit

class TodoCell: UITableViewCell {

    
    //타이틀라벨
    @IBOutlet weak var topTitleLabel :UILabel!
    // 데이트라벨
    @IBOutlet weak var dateLabel: UILabel!
    //우선순위이미지
    @IBOutlet weak var levelView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
