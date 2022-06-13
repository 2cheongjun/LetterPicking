//백업
//  LoginVC.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/14.
//

import UIKit
import Alamofire
import SwiftyJSON

// 로그인화면
// 로그인이 되어있을경우, 글자피드메인으로 자동이동
class LoginVC :UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    // 테스트값출력필드
    @IBOutlet weak var textView: UITextView!
    
    //프로필목록
    let tv = UITableView()
    // 서버에서 가져온제이슨값을 담을 배열
    var dataSource: [Contact] = []
    
    var userID: String? = nil
    var userPassword: String? = nil
    var userEmail: String? = nil
    
    var getID = ""
    // BASEURL
    var BASEURL = UrlInfo.shared.url!
    
    // 로그인값 가져오기
    let plist = UserDefaults.standard
    
    //로딩인디케이터
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        // 네비게이션바 숨김처리
        self.navigationController?.navigationBar.isHidden = false
        
        //테이블뷰의 기본 프로퍼티의 기본 속성을 설정합니다. / 로그인 테이블 위치
        self.tv.frame = CGRect(x: 0, y: 450, width: self.view.frame.width, height:100)
        //        self.tv.frame = CGRect(x: 0, y: self.profileImage.frame.origin.y + self.profileImage.frame.size.height + 20, width: self.view.frame.width, height:100)
        self.tv.dataSource = self
        self.tv.delegate = self
        
        self.view.addSubview(self.tv)
        
        // 지정된 값을 꺼내어 각 컨트롤에 설정한다.
        let getName = plist.string(forKey: "name")
        
        if getName != nil {
            let isLogged: Bool = true // 우선 테스트를 위해
            if isLogged == true {
                // 로그인 된 상태
                guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "tabVC") else {
                    return
                }
                self.navigationController?.pushViewController(uvc, animated: true)
            }
        }
    }//뷰디디로드끝
    
    override func viewWillAppear(_ animated: Bool) {
        // 마이페이지에서 다시 로그인창으로 왔을때, 상단 백버튼가림
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // 테스트버튼, 둘러보기
    @IBAction func testBtn(_ sender: Any) {
        // 메인피드로 이동(세그)
    }
    
    // 로그인요청 post(아이디와, 비번값을 받아서 넣고 서버로 전송)/ 아이디비번 리턴하기(돌아오다)
    func sendRequest(id :String , pw:String){
        
        // 인디케이터 호출
         self.indicator.startAnimating()
        
        // 전달해야할 값을 키-값 형식으로 param에 담아서 전송
        let param : Parameters = [
            "userID":id,
            "userPassword": pw
        ]
        // 호출 URL
        let url: String = BASEURL+"login/iOS_login.php"
        
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
         
                        // 아이디 값이 있으면 a출력하고 없으면 ?? -를 출력한다.(coalesce)
                        print("userID= \(jsonObject["userID"] ?? "" )")
                        print("userPassword =\(jsonObject["userPassword"] ?? "")")
                        //                    print("userPassword =\(jsonObject["userPassword"]!)")
                        // userID 파싱
                        let userID = jsonObject["userID"] as? String ?? ""
                        let userPassword = jsonObject["userPassword"] as? String ?? ""
                        let userEmail = jsonObject["userEmail"] as? String ?? ""
                        let joinStart = jsonObject["joinStart"] as? String ?? ""
                        let delID = jsonObject["delID"] as? String ?? ""
                        let success =  jsonObject["success"] as? String ?? ""
                        
                        //로그인성공시 아이디값을 공통저장소에 저장한다.UserDefaults에 아이디저장
                        // userDefault 기본저장소객체가져오기
                        let plist = UserDefaults.standard
                        plist.setValue(userID, forKey: "name")//이름이라는 키로 저장
                        plist.synchronize()//동기화처리

                        plist.setValue(userEmail, forKey: "email")//이메일이라는 키로 저장
                        plist.synchronize()//동기화처리
                        
                        plist.setValue(userPassword, forKey: "password")//비번이라는 키로 저장
                        plist.synchronize()//동기화처리
                        
                        plist.setValue(userID, forKey: "Rname")//이름이라는 키로 저장
                        plist.synchronize()//동기화처리
                        
                        plist.setValue(userPassword, forKey: "Rpassword")//비번이라는 키로 저장
                        plist.synchronize()//동기화처리
                        
                        // 서버에서 가져온값이 없을경우
                        if userID == "" && joinStart == "" && userEmail == "" {
                            self.alert("없는 아이디 입니다.")
                        }
                        // 가입날짜가 없는경우는 없는 아이디
                        if success == "false" && success == "0" {
                            self.alert("응답을 받아오지 못했습니다. 서버에 연결에 문제가 있습니다.")
                        }
                        // delID값이 Y인경우 탈퇴한아이디
                        if delID == "Y"{
                            self.alert("탈퇴한 아이디입니다.")
                            
                        } else{
//                            self.alert("로그인 성공")
                            // 성공했을때에만 로그인info로 값보내기
                            self.spend(userID: userID, userPassword: userPassword)
                            
                            // 인디케이터 에니메이션 종료
                            self.indicator.stopAnimating()
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                            
                                // 글자피드 탭화면으로 이동
                                guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "tabVC") else {
                                    return
                                }
                                self.navigationController?.pushViewController(uvc, animated: true)
                            }
                        }
                    }
                    
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
    }
    
    
    //로그인 알림창
    @objc func doLogin(_ sender: Any){
        let loginAlert = UIAlertController(title: "LOGIN", message: nil, preferredStyle: .alert)
        
        // 자동로그인을 위한 아이디값 가져오기
        let getName = plist.string(forKey: "Rname")
        // 비번 가져오기
        let getPassword = plist.string(forKey: "Rpassword")
        
        // 알림창에 들어갈 입력폼 추가
        loginAlert.addTextField { (tf) in
            tf.placeholder =  "Your Account"
            
            if (getName != nil) {
                loginAlert.textFields?[0].text = getName
            }
        }
        loginAlert.addTextField { (tf) in
            tf.placeholder =   "Password"
            tf.isSecureTextEntry = true
            if (getPassword != nil) {
                loginAlert.textFields?[1].text =  getPassword
            }
        }
        
        //알림창 버튼 추가
        loginAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        // 로그인버튼 눌렀을때
        loginAlert.addAction(UIAlertAction(title: "Login", style: .destructive){ (_) in
            
            let account = loginAlert.textFields?[0].text ?? "" //첫번째 필드: 계정
            let passwd = loginAlert.textFields?[1].text ?? "" //두번쨰 필드: 비밀번호
            
            // 아이디, 비번 입력받은값 서버로 전송
            //            let account = "test"
            //            let passwd = "1111"
            
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
        self.doLogin(self.tv)
    }
    
    
}




