//
//  goOutVC.swift
//  TodoList
//
//  Created by 이청준 on 2022/05/31.
//
// 탈퇴화면

import Foundation
import UIKit
import Alamofire

class goOutVC: UIViewController {
    
    // 저장한 이름 가져오기
    let plist = UserDefaults.standard
    
    // 현재까지 읽어 온 데이터의 페이지 정보
    // 최초에 화면을 실행할때 이미 1페이지에 해당하는 데이터를 읽어 왔으므로,page의 초기값으로 1을 할당하는것이 맞다.
    var page = 1
    // BASEURL
    var BASEURL = UrlInfo.shared.url!
    
    // 닫기버튼
    @IBAction func closeBtn(_ sender: Any) {
     self.dismiss(animated: true, completion: nil)
        // 로그인 화면으로 이동시키기????
    }
    
    // 인디케이터추가
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    //API 호출상태값을 관리할 변수
    var isCalling = false
    var checkOn = false
    
    
    override func viewWillAppear(_ animated: Bool) {
        //탈퇴글
        self.label()
        // 탈퇴버튼
        self.goOutBtn()
    }
    
    override func viewDidLoad() {
        //탈퇴글
        self.label()
        // 탈퇴버튼
        self.goOutBtn()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //로그인 아이디
        plist.synchronize()//동기화처리
    }
    
    // 탈퇴안내글
    func label(){
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: self.view.frame.width-10, height:300))
        label.frame.origin.x = 10
        label.frame.origin.y = 40
        label.textAlignment = .left
        label.numberOfLines = 5
        label.text = "사용하고 계신 아이디를 탈퇴하시면 복구가 불가하오니 신중하게 선택하시기 바랍니다. 작성한 게시글과 댓글은 자동삭제되지 않고 남아있습니다.삭제를 원하는 게시글이 있다면 탈퇴전 삭제하시기 바랍니다. 위 내용을 모두확인하였으며, 이에 동의합니다."
        self.view.addSubview(label)
    }
    
    //로그인/로그아웃 버튼
    func  goOutBtn() {
        //버튼을 감쌀 뷰를 정의한다. 배경
        let v = UIView()
        v.frame.size.width = self.view.frame.width
        v.frame.size.height = 40
        v.frame.origin.x = 0
        v.frame.origin.y = 700
        v.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        self.view.addSubview(v)
        
        //버튼을 정의한다.
        let btn = UIButton(type:.system)
        btn.frame.size.width = 100
        btn.frame.size.height = 30
        btn.center.x = v.frame.size.width / 2 //중앙정렬
        btn.center.y = v.frame.size.height / 2 //중앙정렬
        btn.setTitle("탈퇴하기", for: .normal)
        btn.addTarget(self, action: #selector(doGoout(_:)), for: .touchUpInside)
        
        v.addSubview(btn)
    }
    
    // 탈퇴알림창
    @objc func doGoout(_ sender: Any){
        
        let alert = UIAlertController(title: "탈퇴하기 ", message: "정말로 탈퇴하시겠습니까? ", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "탈퇴하기", style: .default) { [self] (_) in
            //  여기에 실행할 코드
            // 갤러리에서 받아온 UIImage값 받아서 newProfile함수 호출
            // 서버로 게시글 번호를 보내고, 그 번호에 맞는 게시글을 삭제한다.
            // 아이디 삭제API호출하기
            goOutdeleteID()

            // 로그인 화면으로 이동시키기(적용안됨)
//            guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") else {
//                return
//            }
//            self.navigationController?.pushViewController(uvc, animated: true)
            
        }
        alert.addAction(alertAction)
        
        // 취소글자 상태값
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancel)
        //                alert.view.tintColor =  UIColor(ciColor: .black)
        self.present(alert, animated: true, completion: nil)
    }
    
    // 아이디 삭제요청호출
    func goOutdeleteID(){
        // userID, postText,이미지묶음을 파라미터에 담아보냄
        let userID = plist.string(forKey: "name")

        // 내아이디, 신고아이디, 글번호전송
        let param: Parameters = [
            "delID" : true,
            "userID" : userID ?? ""]

        print("탈퇴업데이트업로드 \(param)")

        // API호출 URL
        let url = self.BASEURL+"login/iOS_delUserID.php"

        // AF에 담아보내기
        let call = AF.request(url, method: .post, parameters: param,
                              encoding: JSONEncoding.default)
        //                call.responseJSON { res in
        call.responseJSON { [self] res in

            guard (try! res.result.get() as? NSDictionary) != nil else {
                self.isCalling = false
                self.alert("서버호출 과정에서 오류가 발생했습니다.")
                print("올바른 응답값이 아닙니다.")
                return
            }

            if let jsonObject = try! res.result.get() as? [String :Any]{
                let success = jsonObject["success"] as? Int ?? 0

                //응답성공
                if success == 1 {
                      // 테이블뷰 재호출(1초뒤 실행)
                    
                    print("탈퇴tag Update JSON= \(try! res.result.get())!)")

                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        
                        // 로그인 데이터 삭제 ***** name과 이메일에 데이터가 있으면 삭제 *****
                        UserDefaults.standard.removeObject(forKey: "name")
                        UserDefaults.standard.removeObject(forKey: "email")
                        
                        let userID = plist.string(forKey: "name")
                        print("아이디값 :\(userID)")
                       
                        // 1초 후 실행될 부분
                        self.alert("탈퇴가 완료되었습니다.")
                    }
                    
            }else{
                self.isCalling = false
                self.alert("탈퇴업로드 응답실패")
            }
        }
       
    }// 신고업로드함수 끝
    
}


}

