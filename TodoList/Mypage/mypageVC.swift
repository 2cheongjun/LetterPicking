//
//  ThirdTabVC.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/19.
//

import UIKit

// 마이페이지
// 로그인정보가 표시되는 곳, 로그인시 로그아웃버튼이, 로그아웃시 로그인 버튼이 표시됨
class thirdTabVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var profileImage = UIImageView() //프로필사진이미지
    let tv = UITableView() //프로필목록
    let uinfo = UserInfoManager()//개인정보 관리 매니저(로그인/ 로그아웃정보)/프사저장함...
    
    // 저장한 이름 가져오기
    let plist = UserDefaults.standard
    //지정된 값을 꺼내어 각 컨트롤에 설정한다.
    var name = ""
    var email = ""
    
    var isname = false
    // 노티3.WriteVC에서 보낸 값을 받기위해 DissmissWrite의 노티피케이션을 정의해 받을 준비한다.
    let introduceVC = Notification.Name("introduceVC")
    
    // 이거를 해야뷰가 보임
    override func viewWillAppear(_ animated: Bool) {
        // 프사설정된 것이 없으면, 기본이미지 01
//        let image = UIImage(named: "default")
//        // 2.프로필 이미지 처리
//        self.profileImage.image = image
//        self.profileImage.frame.size = CGSize(width: 100, height: 100)
//        // 이미지 중앙정렬
//        self.profileImage.center = CGPoint(x:self.view.frame.width / 2, y: 240)
//        // 3.이미지둥글게
//        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
//        self.profileImage.layer.borderWidth = 0
//        self.profileImage.layer.masksToBounds = true
        // 4.루트뷰에 추가
//        self.view.addSubview(self.profileImage)
        // 로그인,로그아웃 버튼
        self.LoginBtn()
        self.LogOutBtn()
        //로그인 아이디
        plist.synchronize()//동기화처리
        self.tv.reloadData()
        
    }
    
    
    // 노티5.옵저버가 DissmissWrite를 받았을때 실행할 내용: 데이터 리로드
       @objc func GOLogin(_ noti: Notification) {
             
           // 로그인 화면으로 이동시키기
           guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "introduceVC") else {
               return
           }
           self.navigationController?.pushViewController(uvc, animated: true)
       }
    
    
    override func viewDidLoad() {
        
        //1.프로필 사진에 들어갈 기본이미지 (Asset안에 있음) // 기본이미지가 안들어가는 문제..?
        
        let image = UIImage(named: "default")
        // 2.프로필 이미지 처리
        self.profileImage.image = image
        self.profileImage.frame.size = CGSize(width: 100, height: 100)
        // 이미지 중앙정렬
        self.profileImage.center = CGPoint(x:self.view.frame.width / 2, y: 240)
        // 3.이미지둥글게
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.layer.borderWidth = 0
        self.profileImage.layer.masksToBounds = true
        // 4.루트뷰에 추가
        self.view.addSubview(self.profileImage)
        
        //배경이미지 설정
        let bg = UIImage(named: "mypage.png")
        let bgImg = UIImageView(image: bg)
        bgImg.frame.size = CGSize(width: 350, height: 350)
        //        bgImg.frame.size = CGSize(width: bgImg.frame.size.width, height: bgImg.frame.size.height)
        bgImg.center = CGPoint(x: self.view.frame.width / 2, y: 200)
        // bgImg.layer.cornerRadius = bgImg.frame.size.width / 2
        // bgImg.layer.borderWidth = 0
        // bgImg.layer.masksToBounds = true
        self.view.addSubview(bgImg)
        
        
        //테이블뷰의 기본 프로퍼티의 기본 속성을 설정합니다. // 테이블뷰 높이설정
        self.tv.frame = CGRect(x: 0, y: self.profileImage.frame.origin.y + self.profileImage.frame.size.height + 20, width: self.view.frame.width, height:300)
        self.tv.dataSource = self
        self.tv.delegate = self
        
        self.view.addSubview(self.tv)
        
        
        // 테이블뷰 객체를 뷰 계층의 맨앞으로 가져오는 구문
        self.view.bringSubviewToFront(self.tv)
        
        //로그인상태에 따라 로그인/로그아웃버튼 출력
        //최초화면 로딩 시 로그인 상태에 따라 적절히 로그인/로그아웃 버튼을 출력한다.
        self.LoginBtn()
        self.LogOutBtn()
        //로그인 아이디
        plist.synchronize()//동기화처리
        self.tv.reloadData()
        
        // 노티4.옵저버를 등록하고,DissmissWrite가 오면 writeVCNotification함수를 실행한다.
         NotificationCenter.default.addObserver(self, selector: #selector(self.GOLogin(_:)), name: introduceVC, object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 여기에 셀구현 내용
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        
        //지정된 값을 꺼내어 각 컨트롤에 설정한다.
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "로그인 아이디"
            //            cell.detailTextLabel?.text = "해리포터씨"
            cell.detailTextLabel?.text = plist.string(forKey: "name") ?? "Login please"
            // 가져오는 이름값이 없으면 ""을 넣어라.
            name =  plist.string(forKey: "name") ?? ""
            if name != ""{
                isname = true
            }
            
        case 1:
            cell.textLabel?.text = "닉네임"
            cell.detailTextLabel?.text = plist.string(forKey: "email") ?? "Login please"
            
        case 2:
            cell.textLabel?.text = "내가 작성한 글"
            cell.accessoryType = .disclosureIndicator
            
        case 3:
            cell.textLabel?.text = ""
            //            cell.detailTextLabel?.text = "1.0 version"
            
            
        case 4:
            cell.textLabel?.text = "개인정보처리방침,이용약관"
            cell.accessoryType = .disclosureIndicator
            
        case 5:
            cell.textLabel?.text = "탈퇴하기"
            cell.textLabel?.textColor = .systemGray2
            cell.accessoryType = .disclosureIndicator
            
            //        case 6:
            //            cell.textLabel?.text = "탈퇴하기"
            //            cell.textLabel?.textColor = .systemGray2
            //            cell.accessoryType = .disclosureIndicator
            //
        default:
            ()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 여기에 셀구현 내용
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        // 선택한것 눌렸다가 자연스럽게 흰색으로 전환
        tableView.deselectRow(at: indexPath, animated: true)
        // 로그인 아이디
        let getName = plist.string(forKey: "name")
        // 내글모아보기
        if indexPath.row == 2{
            
            // 로그인상태에서만 호출
            if getName != nil {
                let myImgVC = UIStoryboard(name:"myImgVC" , bundle: nil).instantiateViewController(withIdentifier: "myImgVC") as! myImgVC
                self.present(myImgVC, animated: true){ }
            }
        }
        
        // 개인정보처리방침
        if indexPath.row == 4{
            
            // 로그인상태에서만 호출
            if getName != nil {
                let PersonInfoVC = UIStoryboard(name:"PersonInfoVC" , bundle: nil).instantiateViewController(withIdentifier: "PersonInfoVC") as! PersonInfoVC
                self.present(PersonInfoVC, animated: true){ }
            }
        }
        
        
        // 탈퇴하기
        if indexPath.row == 5{
            
            // 로그인상태에서만 호출
            if getName != nil {
                let goOutVC = UIStoryboard(name:"goOutVC" , bundle: nil).instantiateViewController(withIdentifier: "goOutVC") as! goOutVC
                self.present(goOutVC, animated: true){ }
            }
        }
    }
    
    
    // 프레젠트메소드방식으로 처리될예정이므로, 닫을때에도 dismiss 메소드를 사용한다.
    @objc func close(_ sender: Any){
        self.presentingViewController?.dismiss(animated: true)
    }
    
    //로그인 알림창
    @objc func doLogin(_ sender: Any){
        
        // 로그인 화면으로 이동시키기
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") else {
            return
        }
        self.navigationController?.pushViewController(uvc, animated: true)
    }
    
    //로그인/로그아웃 버튼
    func LogOutBtn() {
        //버튼을 감쌀 뷰를 정의한다.
        let v = UIView()
        v.frame.size.width = self.view.frame.width
        v.frame.size.height = 40
        v.frame.origin.x = 0
        v.frame.origin.y = self.tv.frame.origin.y + self.tv.frame.height + 50
        v.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        self.view.addSubview(v)
        
        //버튼을 정의한다.
        let btn = UIButton(type:.system)
        btn.frame.size.width = 100
        btn.frame.size.height = 30
        btn.center.x = v.frame.size.width / 2 //중앙정렬
        btn.center.y = v.frame.size.height / 2 //중앙정렬
        btn.setTitle("로그아웃", for: .normal)
        btn.addTarget(self, action: #selector(doLogout(_:)), for: .touchUpInside)
        
        
        // 로그인아이디 가져옴
        let getName = plist.string(forKey: "name")
        // 로그아웃 되있으면, 로그인버튼 On
        if getName != nil {
            btn.isHidden = false
            
        }else{
            btn.isHidden = true
            v.backgroundColor = UIColor.white
        }
        
        v.addSubview(btn)
    }
    
    //로그인버튼
    func LoginBtn() {
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
        btn.setTitle("로그인", for: .normal)
        btn.addTarget(self, action: #selector(doLogin(_:)), for: .touchUpInside)
        
        
        // 로그인아이디 가져옴
        let getName = plist.string(forKey: "name")
        // 로그인되있으면, 로그인버튼 Off
        if getName != nil {
            btn.isHidden = true
            v.backgroundColor = UIColor.white
        }else{
            btn.isHidden = false
        }
        v.addSubview(btn)
    }
    
    // 로그아웃 버튼
    //로그아웃버튼 클릭시 로그인화면으로 이동
    @objc func doLogout(_ sender: Any){
        let msg = "로그아웃하시겠습니까?"
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        // 로그아웃버튼을 눌렀을때
        alert.addAction(UIAlertAction(title: "확인", style: .destructive) { (_) in
            
            // 로그인 데이터 삭제 ***** name과 이메일, 프사 데이터가 있으면 삭제 *****
            UserDefaults.standard.removeObject(forKey: "name")
            UserDefaults.standard.removeObject(forKey: "email")
//            UserDefaults.standard.removeObject(forKey: "image")
            self.plist.synchronize()//동기화처리
            
            // 로그인 화면으로 이동시키기
            guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") else {
                return
            }
            self.navigationController?.pushViewController(uvc, animated: true)
            
        })
        self.present(alert, animated: false)
    }
    
    
    // 탭바 애니메이션설정
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let tabBar = self.tabBarController?.tabBar
        //        tabBar?.isHidden = (tabBar?.isHidden == true) ? false : true
        UIView.animate(withDuration: TimeInterval(0.15),animations:{
            //알파값이 0이면 1로, 1이면 0으로 바꿔준다.
            //호출될때마다 점점 투명해졌다가 점점 진해질 것이다.
            //                              (참거짓조건)? 참일때의값 : 거짓일때의 값
            tabBar?.alpha = (tabBar?.alpha == 0 ? 1 : 0)
        })
    }
    
    
}
