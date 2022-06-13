//
//  PersonInfoVC.swift
//  TodoList
//
//  Created by 이청준 on 2022/06/13.
//
// 개인정보처리방침페이지
import UIKit

class PersonInfoVC: UIViewController{
    
    // 개인정보내역내용
    @IBOutlet var content: UITextView!
    
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        

    }

}
