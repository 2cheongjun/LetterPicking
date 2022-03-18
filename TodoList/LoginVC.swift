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
    let uinfo = UserInfoManager()
//    let profileImage = UIImageView() //프로필사진이미지
    let tv = UITableView() //프로필목록
    // 서버에서 가져온제이슨값을 담을 배열
    var dataSource: [Contact] = []
    
    override func viewDidLoad() {
        //        self.navigationItem.title = "프로필"
        
        //뒤로가기 버튼 처리
        //               let backBtn = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(close(_:)))
        //               self.navigationItem.leftBarButtonItem = backBtn
        
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
        self.drawBtn()
        
    }
    
    // 테스트버튼
    @IBAction func testBtn(_ sender: Any) {
        //        sendRequest()
        
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
        // responseString()응답 메시지의 본문을 문자열로 처리한후 전달한다.
        //API의 결과가 JSON타입이므로, 응답메소드를 responseJSON()을 사용한다.
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
//                    print("userID= \(jsonObject["userID"]!)")
//                    print("userPassword =\(jsonObject["userPassword"]!)")
                    // userID 파싱
                    let userID = jsonObject["userID"] as? String ?? "222"
                    let userPassword = jsonObject["userPassword"] as? String ?? "222"
                    let userEmail = jsonObject["userEmail"] as? String ?? "222"
                    // 뷰에 적용
                    self.textView.text = userID
                    self.textView.text = userPassword
                    // append해야 하나에 같이 써짐
                        self.textView.text.append("\n\(userID )")
                    self.textView.text.append("\n\(userEmail)")
                    //성공시 얼럿띄우기
                    
                     self.alert("로그인 성공")
                     //화면이동시키기
                    guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") else {
                        return
                    }
                    self.navigationController?.pushViewController(uvc, animated: true)
                    
                    } else{
                        // nil값일 때의 처리???????

                    }
                    // 성공시 네비게이션 컨트롤러로 이동
           
                case .failure(let error):
                    print("에러메시지//: \(error)")
//                    self.indicatorView.stopAnimating()
//                    self.isCalling = false
                    self.alert("서버 호출 과정에서 오류가 발생했습니다.")
                    return
                }
    }
            ) }
    
    
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
            let account = loginAlert.textFields?[0].text ?? "" //첫번째 필드: 계정
            let passwd = loginAlert.textFields?[1].text ?? "" //두번쨰 필드: 비밀번호
            
            // 입력받은 값으로 통신해서 서버에서 응답받아서 아이디,패스워드 리턴함 *********************************************
//            let p = self.sendRequest(id: account, pw: passwd)
            self.sendRequest(id: account, pw: passwd)
        
            // 넣은값 잘찍힘
            //print(account, passwd)
            
            
            // 로그인 버튼을 누르면 uinfo에 계정,비번 받아서 넣기************************************************
//            if self.uinfo.login(account: account, passwd: passwd){
//                //TODO:(로그인 성공시 처리할 내용이 여기에 들어갈 예정입니다.)
//                self.tv.reloadData() //테이블뷰를 갱신한다.
//                self.profileImage.image = self.uinfo.profile // 이미지 프로필을 갱신한다.
//                //로그인상태에 따라 로그인/로그아웃버튼 출력
//                self.drawBtn()
//            }else{
//                let msg = "로그인에 실패하였습니다."
//                let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
//                self.present(alert, animated: false)
//            }
        })
        self.present(loginAlert, animated: false)
    }
    
   
    
    //로그아웃
    @objc func doLogout(_ sender: Any){
        let msg = "로그아웃하시겠습니까?"
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        // 로그아웃버튼을 눌렀을때
        alert.addAction(UIAlertAction(title: "확인", style: .destructive) { (_) in
            //uinfo의 logout메소드 사용
            if self.uinfo.logout(){
                //로그아웃시 처리할 내용이 여기에 들어갈 예정
                // 테이블뷰를 갱신한다.
                self.tv.reloadData()
//                self.profileImage.image = self.uinfo.profile //이미지프로필을 갱신한다.
                //로그인상태에 따라 로그인/로그아웃버튼 출력
                self.drawBtn()
            }
        })
        self.present(alert, animated: false)
    }
    
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
            cell.textLabel?.text = "이름"
            //            cell.detailTextLabel?.text = "해리포터씨"
            cell.detailTextLabel?.text = self.uinfo.name ?? "Login please"
        case 1:
            cell.textLabel?.text = "계정"
            //            cell.detailTextLabel?.text = "abc@gmail.com"
            cell.detailTextLabel?.text = self.uinfo.account ?? "Login please"
        default:
            ()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // uinfo의 isLogin프로퍼티를 이용해 로그인 상태를 체크한다.
        if self.uinfo.isLogin == false {
            //로그인 되어있지 않다면 로그인 창을 띄워준다.
            self.doLogin(self.tv)
        }
    }
    
    
    // 프레젠트메소드방식으로 처리될예정이므로, 닫을때에도 dismiss 메소드를 사용한다.
    @objc func close(_ sender: Any){
        self.presentingViewController?.dismiss(animated: true)
    }
    
    
    //로그인/로그아웃 버튼
    func drawBtn() {
        //버튼을 감쌀 뷰를 정의한다.
        let v = UIView()
        v.frame.size.width = self.view.frame.width
        v.frame.size.height = 40
        v.frame.origin.x = 0
        v.frame.origin.y = self.tv.frame.origin.y + self.tv.frame.height
        v.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        self.view.addSubview(v)
        
        //버튼을 정의한다.
        let btn = UIButton(type:.system)
        btn.frame.size.width = 100
        btn.frame.size.height = 30
        btn.center.x = v.frame.size.width / 2 //중앙정렬
        btn.center.y = v.frame.size.height / 2 //중앙정렬
        
        //로그인 상태일 때는 로그아웃버튼을, 로그아웃 상태일때는 로그인 버튼을 만들어준다.
        if self.uinfo.isLogin == true {
            btn.setTitle("로그아웃", for: .normal)
            btn.addTarget(self, action: #selector(doLogout(_:)), for: .touchUpInside)
        }else {
            btn.setTitle("로그인", for: .normal)
            btn.addTarget(self, action: #selector(doLogin(_:)), for: .touchUpInside)
        }
        v.addSubview(btn)
    }
    
}




