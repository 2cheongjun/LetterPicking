//
//  TableViewCell.swift
//  TodoList
//
//  Created by 이청준 on 2022/05/31.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // imageView 생성
    private let img: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "default")
        return imgView
    }()

    // label 생성
    private let label: UILabel = {
        let label = UILabel()
        label.text = "게시글내용"
        label.textColor = UIColor.gray
        return label
    }()
    
    // datalabel 생성
    private let datelabel: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        label.textColor = UIColor.gray
        return label
    }()
    
    private func setConstraint() {
        
        contentView.addSubview(img)
        contentView.addSubview(label)
        contentView.addSubview(datelabel)
        
        img.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        datelabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            img.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            img.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            img.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            img.widthAnchor.constraint(equalToConstant: 64),
            img.heightAnchor.constraint(equalToConstant: 64),
            label.centerYAnchor.constraint(equalTo: img.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16),
            datelabel.centerYAnchor.constraint(equalTo: img.centerYAnchor),
            datelabel.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: 250),
            datelabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16),
            datelabel.centerYAnchor.constraint(equalTo: img.centerYAnchor)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraint()
    }

        

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
