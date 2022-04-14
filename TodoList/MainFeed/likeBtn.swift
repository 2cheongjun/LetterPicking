//
//  likeBtn.swift
//  TodoList
//
//  Created by 이청준 on 2022/04/14.
//

import UIKit

enum BtnType {
    case up
    case down
}

class likeBtn: UIButton {
    
    //초기화
    init(){
        super.init(frame: .zero)
        configure()
    }
    //UI버튼 필수 초기화
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 타입에따라 up,down호출함
    var isOn = BtnType.down {
        // isOn이라는 값이 Set이되면 호출된다.
        didSet{
            //디자인변경
            changeDesign()
        }
    }
    
    
    private func configure(){
        self.addTarget(self, action: #selector(selectButton), for: .touchUpInside)
    }
    
    
    @objc private func selectButton(){
        if isOn == .up {
            isOn = .down
        }else{
            isOn = .up
        }
    }
    
    //상태값 변경
    private func changeDesign(){
        if isOn == .down{
            self.imageView?.transform = CGAffineTransform(rotationAngle: .pi)
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.3)
        }else{
            self.imageView?.transform = .identity
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(1)
        }
    }
}
