//
//  Utils.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/08.
//
// 유틸모음
import UIKit

extension UIViewController {
    
    // 얼럿창
    func alert(_ message: String, completion: (()->Void)? = nil ){
        
        // 메인 스레드에서 실행되도록
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "확인", style: .cancel) { (_) in
                // 콤플레이션 매개변수의 값이 nil이 아닐 때에만 실행되도록
                completion?()
            }
                alert.addAction(okAction)
                self.present(alert, animated: true)
        }
    }
}



