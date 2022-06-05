
//
//  JoinVC.swift
//  MyMemory


import UIKit
import Alamofire
import SwiftyJSON

// 회원가입화면
class JoinVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // API 호출 상태값을 관리할 변수(재호출방지)
    var isCalling = false
    
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    // 테이블 뷰에 들어갈 텍스트 필드들
    var fieldAccount: UITextField! // 계정 필드
    var fieldPassword: UITextField! // 비밀번호 필드
    var fieldName: UITextField! // 이름 필드
    var btn: UIButton! // 중복확인버튼
    // 상황에 따라 다른 alert를 줄 때 바꿔줄 문장을 tmpMessage로 설정
    var tmpMessage: String = ""
    // BASEURL
    var BASEURL = UrlInfo.shared.url!
    
    var userID = ""
    
    override func viewDidLoad() {
        
        // 네비게이션바 항상보이게
        self.navigationController?.navigationBar.isHidden = false
        // 테이블 뷰의 dataSource, delegate 속성 지정
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // 프로필 이미지를 원형으로 설정
        //        self.profile.layer.cornerRadius = self.profile.frame.width / 2
        //        self.profile.layer.masksToBounds = true
        //
        // 프로필 이미지에 탭 제스처 및 액션 이벤트 설정
        //        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedProfile(_:)))
        //        self.profile.addGestureRecognizer(gesture)
        self.view.bringSubviewToFront(self.indicatorView) // 인디케이터 뷰를 화면 맨 앞으로
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        // 각 테이블 뷰 셀 모두에 공통으로 적용될 프레임 객체
        let tfFrame = CGRect(x: 20, y: 0, width: cell.bounds.width - 20, height: 37)
        switch indexPath.row {
        case 0 :
            self.fieldAccount = UITextField(frame: tfFrame)
            self.fieldAccount.placeholder = "email@gmail.com"
            self.fieldAccount.borderStyle = .none
            self.fieldAccount.autocapitalizationType = .none
            self.fieldAccount.font = UIFont.systemFont(ofSize: 14)
            self.btn = UIButton(frame: tfFrame)
            //            self.btn.setTitle("로그아웃", for: .normal)
            //            self.btn.addTarget(self, action: #selector(doLogout(_:)), for: .touchUpInside)
            //버튼을 정의한다.
            cell.addSubview(self.fieldAccount)
            
        case 1 :
            cell.textLabel?.text = "아이디 중복확인"
            cell.textLabel?.textColor = .white
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.backgroundColor = .link
            
        case 2 :
            self.fieldPassword = UITextField(frame: tfFrame)
            self.fieldPassword.placeholder = "비밀번호는 영+숫자 8글자 이상"
            self.fieldPassword.borderStyle = .none
            self.fieldPassword.isSecureTextEntry = true
            self.fieldPassword.font = UIFont.systemFont(ofSize: 14)
            cell.addSubview(self.fieldPassword)
        case 3 :
            self.fieldName = UITextField(frame: tfFrame)
            self.fieldName.placeholder = "닉네임"
            self.fieldName.borderStyle = .none
            self.fieldName.font = UIFont.systemFont(ofSize: 14)
            cell.addSubview(self.fieldName)
        default :
            ()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        // 선택한것 눌렸다가 자연스럽게 흰색으로 전환
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 아이디중복확인 버튼
        if indexPath.row == 1 {
            print(indexPath.row)
            // 아이디중복 API호출 하기
            if(self.fieldAccount.text! != nil){
                checkID()
            }else{
                self.alert("아이디를 작성하고 중복확인을 해주세요")
            }
            
        }
    }
    
    
    
    // 가입완료 버튼액션
    @IBAction func submit(_ sender: Any) {
        
        // 이메일 필드,패스워드에 입력된값 리턴
        guard let fieldAccount = fieldAccount.text else{
            return }
        
        guard let fieldPassword = fieldPassword.text else{
            return }
        
        guard let fieldName = fieldName.text else{
            return }
        
        // id(email)와 password의 이름 형식, 체크후 값이 모두 채워져있을때에만 post실행하기
        if isValidEmailAddress(email: fieldAccount) && isVailedPassword(password: fieldPassword)
            && isVailedName(name: fieldName){
            // 계정과 비번이 이름이 모두 있을 경우에만
            if fieldAccount != ""  && fieldPassword != "" && fieldName != ""{
                //서버요청
                post()
                
            } else { // 형식은 지켰으나 정의해둔 id(email), password가 아닌 경우
                // 아이디/ 비밀번호가 올바르지 않습니다.
                failedAlert()
            }
        }
        
        // id(email) 형식이 올바르지 않은 경우
        if !isValidEmailAddress(email: fieldAccount) {
            tmpMessage = "이메일을"
            failedAlert()
        }
        
        // password 형식이 올바르지 않은 경우
        if !isVailedPassword(password: fieldPassword) {
            tmpMessage = "패스워드를"
            failedAlert()
        }
        
        // password 형식이 올바르지 않은 경우
        if !isVailedName(name: fieldName) {
            tmpMessage = "닉네임을"
            failedAlert()
        }
    }
    
    
    // 회원가입 요청API
    func post(){
        if self.isCalling == true {
            self.alert("진행 중입니다. 잠시만 기다려주세요.")
            return
        } else {
            self.isCalling = true
        }
        
        // 인디케이터 뷰 애니메이션 시작
        self.indicatorView.startAnimating()
        
        // 1. 전달할 값 준비
        // 1-2. 전달값을 Parameters 타입의 객체로 정의
        let param: Parameters = [
            "userID" : self.fieldAccount.text!,
            "userPassword" : self.fieldPassword.text!,
            "userName" : self.fieldName.text!
            //             ,"profile_image" : profile!
        ]
        
        // 2. API 호출
        let url = BASEURL+"login/iOS_register.php"
        let call = AF.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default)
        
        // 3. 서버 응답값 처리
        call.responseString { response in
            // 인디케이터 뷰 애니메이션 종료
            self.indicatorView.stopAnimating()
            
            
            switch response.result {
            case .success:
                print("Success")
                self.isCalling = true
                self.alert("가입이 완료되었습니다.")
                
                print("JSON2 = \(try! response.result.get())")
                //                }
            case .failure(let e):
                print(e)
                self.isCalling = false
                self.alert("가입 실패")
                
            }
            
        }
        self.navigationController?.popViewController(animated: true)
    }// 회원가입함수끝
    
    
    // 아이디 중복체크API 호출
    func checkID(){
        // 작성한 아이디
        userID = self.fieldAccount.text!

        // 1. 전달할 값 준비
        // 1-2. 전달값을 Parameters 타입의 객체로 정의
        let param: Parameters = [
            "userID" :  userID
        ]
        
        // 2. API 호출
        let url = BASEURL+"login/userIDValidate.php"
        let call = AF.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default)
        
        // 3. 서버 응답값 처리
        call.responseJSON { [self] res in
            
            guard (try! res.result.get() as? NSDictionary) != nil else {
                print("서버호출 과정에서 오류가 발생했습니다.")
                return
            }
            
            print("JSON= \(try! res.result.get())!)")
            
                if let jsonObject = try! res.result.get() as? [String :Any]{
                    let success = jsonObject["success"] as? Int ?? 0
                    let message = jsonObject["message"] as? String ?? ""
                    let num = jsonObject["num"] as? Int ?? 0
                    
                    if (num > 0) {
                         self.alert("중복아이디")
                        // self.dismiss(animated: true, completion: nil)
                        
                    }else if (num == 0) {
                        self.alert("사용가능 아이디")
                        
                    }
                }
                
            }
            
        }// 하트업로드함수 끝
    
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let rawVal = UIImagePickerController.InfoKey.originalImage.rawValue
        if let img = info[UIImagePickerController.InfoKey(rawValue: rawVal)] as? UIImage {
            self.profile.image = img
        }
        self.dismiss(animated: true)
    }
    
    
    // alert 설정
    // 값이 비어있을 경우
    func failedAlert() {
        let alertController = UIAlertController(title: nil, message: "\(tmpMessage) 입력해 주세요.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // 정규표현식을 사용하여 id(email) 형식이 맞는지 검증
    func isValidEmailAddress(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    // 정규표현식을 사용하여 password 형식이 맞는지 검증 (영+숫자 8글자 이상)
    func isVailedPassword(password: String) -> Bool {
        let passwordRegEx = "^[a-zA-Z0-9]{8,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    // 정규표현식을 사용하여 이름이 맞는지
    func isVailedName(name: String) -> Bool {
        let nameRegEx = "^[a-zA-Z0-9]{3,}$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: name)
    }
    
}
