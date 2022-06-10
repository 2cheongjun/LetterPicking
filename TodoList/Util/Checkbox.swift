//
//  Checkbox.swift
//  TodoList
//
//  Created by 이청준 on 2022/06/07.
//
//  체크박스
import UIKit

final class Checkbox: UIButton {
    
    var isChecked = false
    var isState = false
    
    // 체크박스 Images
    let checkedImage = UIImage(named: "checkOn")! as UIImage
    let uncheckedImage = UIImage(named: "checkOff")! as UIImage
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.secondaryLabel.cgColor
        layer.cornerRadius = frame.size.width / 2.0
        backgroundColor = .systemBackground
    }
    
    func toggle(){
        self.isChecked = !isChecked
        if self.isChecked{
            self.setImage(checkedImage, for: .normal)
            isState = true
        }else{
            self.setImage(uncheckedImage, for: .normal)
            isState = false
        }
        
        
        //  isState = true이면 UserDefaluts에 값저장. 체크박스상태값 저장하기
        if self.isState{
            
            // 체크박스On 상태저장
            let checkState = UserDefaults.standard.set(self.isState,  forKey: "goOut")
           
            // 저장값가져오기
            let test =  UserDefaults.standard.string(forKey: "goOut")
            print ("isState save :\(test ?? "nil")")
            
        }else{
            // 체크박스OFF,저장값삭제
            let checkState = UserDefaults.standard.removeObject(forKey: "goOut")
          
            // 저장값가져오기
            let test =  UserDefaults.standard.string(forKey: "goOut")
            print ("isState del:\(test ?? "nil")")

        }
    }
    
}

