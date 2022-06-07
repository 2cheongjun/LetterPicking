//
//  goOutVC.swift
//  TodoList
//
//  Created by 이청준 on 2022/05/31.
//
// 탈퇴화면

import UIKit

class goOutVC2: UIViewController{
    
    // 체크박스클래스에서 객체 생성하기
    let checkbox1 = Checkbox(frame: CGRect(x :16, y:280, width:40, height: 40))
    
    override func viewDidLoad() {
        // 체크박스
        self.checkbox()
    }
    

    // 공용체크박스
    func checkbox(){
        view.addSubview(checkbox1)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCheckbox))
        checkbox1.addGestureRecognizer(gesture)
    }
    
    @objc func didTapCheckbox(){
        checkbox1.toggle()
    }

}

