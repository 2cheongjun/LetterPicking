//
//  goOutVC.swift
//  TodoList
//
//  Created by 이청준 on 2022/05/31.
//
// 탈퇴화면

import Foundation
import UIKit

class goOutVC: UIViewController {
  
    
    override func viewDidLoad() {
        
        // 사용하고 계신 아이디를 탈퇴하시면 복구가 불가하오니 신중하게 선택하시기 바랍니다.
        // 작성한 게시글과 댓글은 자동삭제되지 않고 남아있습니다. 삭제를 원하는 게시글이 있다면 탈퇴전 삭제하시기 바랍니다.
        //  위 내용을 모두확인하였으며, 이에 동의합니다.
        //  비밀번호를 입력해주세요.
        
        //테이블뷰의 기본 프로퍼티의 기본 속성을 설정합니다. // 테이블뷰 높이설정
        //배경이미지 설정
      
//        self.view.addSubview(bgImg)
        
                // 탈퇴 셀을 클릭하면 탈퇴확인 팝업을 띄운다.

//                    // 게시글 삭제 얼럿
//                        let alert = UIAlertController(title: "게시물 삭제", message: "정말로 탈퇴하시겠습니까? 해당아이디의 작성한글은 직접삭제해주세요.", preferredStyle: .alert)
//                        let alertAction = UIAlertAction(title: "삭제", style: .default) { [self] (_) in
//                            //  여기에 실행할 코드
//                            // 갤러리에서 받아온 UIImage값 받아서 newProfile함수 호출
//                            // 서버로 게시글 번호를 보내고, 그 번호에 맞는 게시글을 삭제한다.
//        //                    requestFeedDeleateAPI()
//                            // 창을 닫는다.
//                            self.dismiss(animated: true, completion: nil)
//
//                        }
//                        alert.addAction(alertAction)
//
//                        // 취소글자 상태값
//                        let cancel = UIAlertAction(title: "취소", style: .cancel)
//                        alert.addAction(cancel)
//                        //                alert.view.tintColor =  UIColor(ciColor: .black)
//                        self.present(alert, animated: true, completion: nil)
//

    }
}

