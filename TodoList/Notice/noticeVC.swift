//
//  noticeVC.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/28.
//

import UIKit

class noticeVC : UIViewController {
    
    override func viewDidLoad() {
        //1.타이틀레이블 생성
        let title = UILabel(frame: CGRect(x: 0, y: 100, width: 100, height: 30))
        
        //2.타이틀 레이블속성설정
        title.text = "게시판 공지사항"
        title.textColor = .red
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 16)
        
        //콘텐츠 내용에 맞게 레이블 크기 변경
        title.sizeToFit()
        
        //x축의 중앙에 오도록 설정
        title.center.x = self.view.frame.width / 2
        
        //수퍼뷰에 추가***************************** 탭설정끝
        self.view.addSubview(title)
        
    }
}

