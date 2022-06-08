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
            //            backgroundColor = .systemBlue
            self.setImage(checkedImage, for: .normal)
            isState = true
            
        }else{
            //            backgroundColor = .systemBackground
            self.setImage(uncheckedImage, for: .normal)
            isState = false
        }
        
        //  isState = true이면 UserDefaluts에 값저장.
        if self.isState{
            UserDefaults.standard.set(self.isState,  forKey: "goOut")
            print("isState save")
        }
        
        let test =  UserDefaults.standard.string(forKey: "goOut")
        if test!= nil {
            print ("저장값 :\(test)")
        }
    
    }
    
}
    
