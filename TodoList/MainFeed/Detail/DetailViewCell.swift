//
//  DetailViewCellTableViewCell.swift
//  TodoList
//
//  Created by 이청준 on 2022/04/29.
//

import UIKit

class DetailViewCell: UITableViewCell {
    
    @IBOutlet var replyId: UILabel!
    @IBOutlet var replyText: UILabel!
    @IBOutlet var replyDate: UILabel!
    
    static let identifier = "DetailViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
