//
//  myImgVC.swift
//  TodoList
//
//  Created by 이청준 on 2022/05/31.
//
// 내글 모아보기
import Foundation
import UIKit

class myImgVC: UIViewController {
    
    private let tableView: UITableView = {
        let tableview = UITableView()
        return tableview
    }()
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        setConstraint()

        // autoHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private func setConstraint() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
           tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
           tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
           tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
           tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)

        ])

    }
    
}


extension myImgVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else { return UITableViewCell() }

        return cell

    }

}
