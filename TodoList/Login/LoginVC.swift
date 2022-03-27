//백업
//  LoginVC.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/14.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginVC :UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var textView: UITextView! //테스트값출력필드
    
    //개인정보 관리 매니저(로그인/ 로그아웃정보)
//    let uinfo = UserInfoManager()
    //    let profileImage = UIImageView() //프로필사진이미지
    let tv = UITableView() //프로필목록
    // 서버에서 가져온제이슨값을 담을 배열
    var dataSource: [Contact] = []
    
    var userID: String? = nil
    var userPassword: String? = nil
    var userEmail: String? = nil
    
    var getID = ""

    
    override func viewDidLoad() {
        // self.navigationItem.title = "프로필"
        
        //뒤로가기 버튼 처리
        // let backBtn = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(close(_:)))
        // self.navigationItem.leftBarButtonItem = backBtn
        
        // 네비게이션바 숨김처리
        self.navigationController?.navigationBar.isHidden = false
        
        //테이블뷰의 기본 프로퍼티의 기본 속성을 설정합니다. / 로그인 테이블 위치
        self.tv.frame = CGRect(x: 0, y: 450, width: self.view.frame.width, height:100)
        //        self.tv.frame = CGRect(x: 0, y: self.profileImage.frame.origin.y + self.profileImage.frame.size.height + 20, width: self.view.frame.width, height:100)
        self.tv.dataSource = self
        self.tv.delegate = self
        
        self.view.addSubview(self.tv)
        //로그인상태에 따라 로그인/로그아웃버튼 출력
        //최초화면 로딩 시 로그인 상태에 따라 적절히 로그인/로그아웃 버튼을 출력한다.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 마이페이지에서 다시 로그인창으로 왔을때, 상단 백버튼가림
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // 테스트버튼, 둘러보기
    @IBAction func testBtn(_ sender: Any) {
        //        sendRequest()
        //화면이동시키기
//        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") else {
//            return
//        }
//        self.navigationController?.pushViewController(uvc, animated: true)
    }
    
    // 로그인요청 post(아이디와, 비번값을 받아서 넣고 서버로 전송)/ 아이디비번 리턴하기(돌아오다)
    func sendRequest(id :String , pw:String){
        
        // 전달해야할 값을 키-값 형식으로 param에 담아서 전송
        let param : Parameters = [
            "userID":id,
            "userPassword": pw
        ]
        // 호출 URL
        let url: String = "http://3.37.202.166/login/iOS_login.php"
        
        AF.request(url,
                   method: .post,
                   parameters : param,
                   encoding: JSONEncoding.default, // JSON으로 전송 ->서버도 JSON으로받기!
                   headers: ["Content-Type" : "application/x-www-form-urlencoded",
                             "Accept" : "application/json"
                            ]
        ).validate(statusCode: 200..<300)
        
        // responseJSON()응답 메시지의 본문을 JSON 객체로 변환하여 전달한다.서버로 보냄
            .responseJSON(completionHandler: {
                (response) in
                // 전체 값
                switch response.result {
                    
                case .success:
                    print("JSON= \(try! response.result.get())!)")
                    // [String :Any]타입의 딕셔너리 객체로 캐스팅하면 개별 값을 추출할수 있다.
                    if let jsonObject = try! response.result.get() as? [String :Any]{
                        //                        guard let jsonObject = try! response.result.get() as? [String :Any] else{
                        //                        self.alert("서버호출과정에서 오류발생")
                        //                        return
                        //                        }
                        // 아이디 값이 있으면 a출력하고 없으면 ?? -를 출력한다.(coalesce)
                        print("userID= \(jsonObject["userID"] ?? "" )")
                        print("userPassword =\(jsonObject["userPassword"] ?? "")")
                        //                    print("userPassword =\(jsonObject["userPassword"]!)")
                        // userID 파싱
                        let userID = jsonObject["userID"] as? String ?? ""
                        let userPassword = jsonObject["userPassword"] as? String ?? ""
                        let userEmail = jsonObject["userEmail"] as? String ?? ""
                        
                       
                        //로그인성공시 아이디값을 공통저장소에 저장한다.
                        // userDefault 기본저장소객체가져오기
                           let plist = UserDefaults.standard
                           plist.setValue(userID, forKey: "name")//이름이라는 키로 저장
                           plist.synchronize()//동기화처리
                        
                        // userDefault 기본저장소객체가져오기
                           plist.setValue(userEmail, forKey: "email")//이메일이라는 키로 저장
                           plist.synchronize()//동기화처리
                        
                        
                        // 뷰에 적용
//                        self.textView.text = userID
//                        self.textView.text = userPassword
//                        // append해야 하나에 같이 써짐
//                        self.textView.text.append("\n\(userID )")
//                        self.textView.text.append("\n\(userEmail)")
                        
                        //성공시 얼럿띄우기
                        if userID  == "" {
                            self.alert("등록되지 않은 아이디입니다.")
                        }else{
                            self.alert("로그인 성공")
                            // 성공했을때에만 로그인info로 값보내기
                            self.spend(userID: userID, userPassword: userPassword)
                            
                            //화면이동시키기 ************************************************************************
                            guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "tabVC") else {
                                return
                            }
                            self.navigationController?.pushViewController(uvc, animated: true)
                        }
                    }
                    
                    // 성공시 네비게이션 컨트롤러로 이동
                    
                case .failure(let error):
                    print("에러메시지//: \(error)")
                    //                    self.indicatorView.stopAnimating()
                    //                    self.isCalling = false
                    self.alert("서버 호출 과정에서 오류가 발생했습니다.")
                    return
                }
            })
    }
    
    func spend(userID: String, userPassword:String) {
           getID = userID
//           b = userPassword
    }
    
    
    //로그인 알림창
    @objc func doLogin(_ sender: Any){
        let loginAlert = UIAlertController(title: "LOGIN", message: nil, preferredStyle: .alert)
        
        //알림창에 들어갈 입력폼 추가
        loginAlert.addTextField { (tf) in
            tf.placeholder = "Your Account"
        }
        loginAlert.addTextField { (tf) in
            tf.placeholder = "Password"
            tf.isSecureTextEntry = true
        }
        //알림창 버튼 추가
        loginAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        // 로그인버튼 눌렀을때
        loginAlert.addAction(UIAlertAction(title: "Login", style: .destructive){ (_) in
//            let account = loginAlert.textFields?[0].text ?? "" //첫번째 필드: 계정
//            let passwd = loginAlert.textFields?[1].text ?? "" //두번쨰 필드: 비밀번호
            
            // 아이디, 비번 입력받은값 서버로 전송

//            self.sendRequest(id: account, pw: passwd)
            let account = "jun"
            let passwd = "1111"
            
            self.sendRequest(id: account, pw: passwd)

        })
        self.present(loginAlert, animated: false)
    }
    
    
   // 코드로 작성한 정적테이블
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 여기에 셀구현 내용
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "ID"

            cell.detailTextLabel?.text = self.userID ?? "아이디를 입력해주세요"
        case 1:
            cell.textLabel?.text = "Password"
            
            cell.detailTextLabel?.text = self.userPassword ?? "비밀번호를 입력해주세요"
        default:
            ()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // uinfo의 isLogin프로퍼티를 이용해 로그인 상태를 체크한다.
//        if self.uinfo.isLogin == false {
            //로그인 되어있지 않다면 로그인 창을 띄워준다.
            self.doLogin(self.tv)
//        }
    }
    
    
//    // 프레젠트메소드방식으로 처리될예정이므로, 닫을때에도 dismiss 메소드를 사용한다.
//    @objc func close(_ sender: Any){
//        self.presentingViewController?.dismiss(animated: true)
//    }
//
    
    
}




