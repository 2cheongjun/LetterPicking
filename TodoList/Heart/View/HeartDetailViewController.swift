
import UIKit
import Alamofire
import SwiftyJSON

// 좋아요북마크 -> 디테일뷰
class HeartDetailViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate {
    
    // 좋아요 모델가져오기
    var heartModel: HeartModel?
    // 피드 모델에 값이 있으면 가져온다.
    var heartResult: HeartResult?
    
    //userDefaults에 저장된이름값 가져오기
    let plist = UserDefaults.standard
    
    var feedIdx = 0
    var replyNum = 0
    var heartNum = 0
    
    // BASEURL
    var BASEURL = UrlInfo.shared.url!
    // 공통하트 API
    var heartAPI = HeartAPI.shared
    
    // 이미지뷰
    @IBOutlet var movieCotainer: UIImageView!
    // 작성자
    @IBOutlet var userID: UILabel!{
        didSet{
            userID.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
    }
    // 날짜
    @IBOutlet var date: UILabel!{
        didSet{
            date.font = UIFont.systemFont(ofSize: 14, weight: .light)
        }
    }
    // 장소
    @IBOutlet var myPlaceText: UILabel!
    @IBOutlet var num: UILabel!
    // 하트버튼
    @IBOutlet var heartBtn: UIButton!
    
    // 댓글모델가져오기
    var detailModel: DetailModel?
    // 댓글 테이블뷰
    @IBOutlet var tableView: UITableView!
    // 댓글 작성영역
    @IBOutlet var replyField: UITextField!
    // 댓글버튼
    @IBOutlet var replyBtn: UIButton!
    
    // 댓글버튼액션
    @IBAction func replyBtn(_ sender: Any) {
        let replyText = replyField.text ?? "댓글작성없음"
        print("댓글작성내용:\(replyText)")
        // 서버로 댓글 내용업로드 API
        replyUpload()
        // 작성한내용삭제
        replyField.text = ""
        //댓글 가져오기
        self.loadReply()
        
    }
    // 글작성내용
    @IBOutlet var postText: UITextView!{
        didSet{
            postText.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        }
    }
    // 장소추가
    @IBOutlet var placeText: UILabel!
    
    // 하트버튼
    @IBAction func heartBtn(_ sender: UIButton) {
        // 버튼을 누를때 (눌려져 있을때와, 안눌려져 있을때 버튼클릭 이벤트)
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            // 메인에서didPressHeart 함수를 실행
            
            // ♥ 이미 눌러져있던 하트 클릭시 //서버에서온 하트 값이 있을때(즉,서버에서 가져온값이 0이상이면, isTouched = true)
            if isTouched == true{ //
                sender.isSelected = !sender.isSelected
                // 빈하트로 변경
                isTouched = false
                heartAPI.DeleteHeart(postIdx: feedIdx.description)
                
            }else{
                // ♡ 하트버튼을 처음누르는 상태
                isTouched = true
                heartAPI.uploadHeart(postIdx: feedIdx.description)
            }
            
        }else {
            // 빈하트로 변경
            isTouched = false
            heartAPI.DeleteHeart(postIdx: feedIdx.description)
        }
    }
    
    var isTouched: Bool? {
        
        didSet {
            if isTouched == true {
                heartBtn.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium)), for: .normal)
            }else{
                heartBtn.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(scale: .medium)), for: .normal)
            }
        }
    }
    
    
    // 노티1.시작의 시작등록.글수정후에 메인피드를 새로고침하기위한 노티
    let HeartDetailVCNOTI: Notification.Name = Notification.Name("HeartDetailVCNOTI")
    
    // 닫기 버튼
    @IBAction func barOKBtn(_ sender: Any) {
        // 노티2.창이 닫힐때 노티를 메인피드로 신호를 보낸다. //(노티의 이름은 ModifyVCNotification)
        NotificationCenter.default.post(name: HeartDetailVCNOTI, object: nil, userInfo: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 하트기본상태On
        isTouched = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // 북마크모음재호출
//        heartAPI.getHeartBookmark()
    }
    
    
    // 글 수정삭제버튼
    @IBOutlet var delBtn: UIButton!
    @IBOutlet var modifyBtn: UIButton!
    
    // 화면이 그려지기전에 세팅한다.
    override func viewDidLoad() {
        super.viewDidLoad()
        // 델리게이트 연결
        postText.delegate = self
        replyField.delegate  = self
        // 커스텀 셀 등록
        tableView.register(HeartReplyCell.nib(), forCellReuseIdentifier: HeartReplyCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // 댓글 단사람아이디
        userID.text = heartResult?.userID
        let myID = heartResult?.userID
        
        // 날짜가져옴
        let str = heartResult?.date
        // 글자치환
        let newStr = str?.replacingOccurrences(of: "-", with: ".")
        //  앞에서 세번째 글자부터 뒤에서 -3번째 글자만 보이기
        let firstIndex = newStr?.index(newStr!.startIndex, offsetBy: 2)
        let lastIndex = newStr?.index(newStr!.endIndex, offsetBy: -3) // "Hello"
        let v = newStr?[firstIndex! ..< lastIndex!]
        // 날짜넣음
        date.text = v?.description
        
        postText.text = heartResult?.postText
        
        placeText.text =  heartResult?.myPlaceText ?? ""
        //글번호
        //        num.text = heartResult?.postIdx?.description
        
        //하트상태 1이면 On상태 0이면 Off상태
        //        heartNum = heartResult?.cbheart ?? 0
        print("하트디테일뷰 / 하트 상태 :\(heartNum)")
        // 하트기본상태On
        isTouched = true
        
        //게시글번호(수정시필요)
        feedIdx = heartResult?.postIdx ?? 0
        
        // 이미지처리방법
        if let hasURL = self.heartResult?.postImgs{
            // 이미지로드 서버요청
            self.loadImage(urlString: hasURL) { image in
                DispatchQueue.main.async {
                    self.movieCotainer.image = image
                }
            }
        }
        
        // 댓글목록 가져오기 API호출
        loadReply()
        
        // 로그인한 아이디값
        let getName = plist.string(forKey: "name")
        
        // 게시글 버튼 상태 visible
        if getName == myID {
            //로그인한 아이디와 서버아이디 같을때에만 버튼 보임
            delBtn.layer.isHidden = false
            modifyBtn.layer.isHidden = false
        }else{
            delBtn.layer.isHidden = true
            modifyBtn.layer.isHidden = true
        }
        
        // 로그인되어있지 않으면 버튼안보임
        if(getName == nil){
            delBtn.layer.isHidden = true
            modifyBtn.layer.isHidden = true
        }
        
        // 상단 백버튼가림
        self.navigationController?.navigationBar.isHidden = false
        
    }// 뷰디드로드끝
    
    
    // 이미지 Get요청
    func loadImage(urlString: String, completion: @escaping (UIImage?)-> Void){
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        // urlString 이미지이름을(ex:http://0.00.000.000/img/2-jun.jpg) 가져와서 URL타입으로 바꿔준다.
        if let hasURL = URL(string: urlString){
            var request = URLRequest(url: hasURL)
            request.httpMethod = "GET"
            
            session.dataTask(with: request) { data, response, error in
                // print( (response as! HTTPURLResponse).statusCode)
                
                if let hasData = data {
                    completion(UIImage(data: hasData))
                    return
                }
            }.resume() //실행한다.
            session.finishTasksAndInvalidate()
        }
        // 실패시 nil리턴한다.
        completion(nil)
    }
    
    // 삭제버튼
    @IBAction func delBtn(_ sender: Any) {
        // 삭제확인 얼럿창 띄우기
        let alert = UIAlertController(title: "게시물 삭제", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "삭제", style: .default) { [self] (_) in
            //  여기에 실행할 코드
            // 갤러리에서 받아온 UIImage값 받아서 newProfile함수 호출
            // 서버로 게시글 번호를 보내고, 그 번호에 맞는 게시글을 삭제한다.
            requestFeedDeleateAPI()
            // 창을 닫는다.
            self.dismiss(animated: true, completion: nil)
            
        }
        alert.addAction(alertAction)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancel)
        // alert.view.tintColor =  UIColor(ciColor: .black)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    // 게시글글수정버튼
    @IBAction func modifyBtn(_ sender: Any) {
        //        let postText = UITextField()
        postText.becomeFirstResponder()// 키보드가 나타나고 입력상태가 된다.
        // 글쓰고 나서
        modifyBtn.setTitle("저장", for: .normal)
        modifyBtn.addTarget(self, action: #selector(upDate), for: .touchUpInside)
    }
    
    // 수정이 저장버튼으로 바뀌고나서의 버튼 액션
    @objc func upDate() {
        print("게시글 수정API호출!")
        // 수정API호출
        upDatePostText()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // 게시글수정API호출
    func upDatePostText(success: (()->Void)? = nil, fail: ((String)->Void)? = nil) {
        // userID, postText,이미지묶음을 파라미터에 담아보냄
        let userID = heartResult?.userID
        
        let param: Parameters = [
            "feedIdx": feedIdx,
            "postText" : postText.text ?? "",
            "userID" : userID as Any,
        ]
        
        // API 호출 URL
        let url = self.BASEURL+"post/0iOS_feedUpdate.php"
        
        //이미지 전송
        let call = AF.request(url, method: .post, parameters: param,
                              encoding: JSONEncoding.default)
        //                call.responseJSON { res in
        call.responseJSON { res in
            
            print("서버로 보냄!!!!!")
            print("JSON= \(try! res.result.get())!)")
            
            guard (try! res.result.get() as? NSDictionary) != nil else {
                print("올바른 응답값이 아닙니다.")
                return
            }
            
            if let jsonObject = try! res.result.get() as? [String :Any]{
                let success = jsonObject["success"] as? Int ?? 0
                let message = jsonObject["message"] as? String ?? ""
                
                if success == 1 {
                    self.alert("응답값 JSON= \(try! res.result.get())!)")
                    self.dismiss(animated: true, completion: nil)
                    print("응답내용\(message)")
                }else{
                    //sucess가 0이면
                    self.alert("응답실패")
                    print("응답내용\(message)")
                }
            }
        }
    }// 수정 함수끝
    
    
    // 게시글삭제 API호출
    func requestFeedDeleateAPI(){
        print("삭제 API호출")
        
        // 1. 전송할 값 준비
        // JSON으로 요청하기 ************************************************************************
        let param = ["feedIdx" : feedIdx]
        print("게시글번호: \(feedIdx)")
        let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])
        
        // 2. URL 객체 정의 (삭제)
        let url = URL(string: self.BASEURL+"post/0iOS_feedDelete.php")
        
        // 값이 있다면 받아와서 넣음.
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // 5-1. 서버가 응답이 없거나 통신이 실패했을 때
            if let e = error {
                NSLog("DetailViewController 삭제요청 /서버응답없음 통신실패 : \(e.localizedDescription)")
                return
            }
            // 5-2. 응답 처리 로직이 여기에 들어갑니다.
            // ① 메인 스레드에서 비동기로 처리되도록 한다.
            DispatchQueue.main.async() {
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    guard let jsonObject = object else { return }
                    
                    print("DetailViewController 삭제요청/ 서버응답") // 코더블안해서 그런것같다???
                    // ② JSON 결과값을 추출한다.
                    //                    let result = jsonObject as? String
                    let success = jsonObject["success"] as? String
                    //                    let userID = jsonObject["userID"] as? String
                    print("DetailViewController 응답결과 \(success)")
                    
                    
                } catch let e as NSError {
                    print("DetailViewController 삭제요청/ 파싱오류: \(e.localizedDescription)")
                }
            } // end if DispatchQueue.main.async()
        }   // 6. POST 전송
        task.resume()
    }// 함수 끝
    
    
    
    // 댓글 테이블뷰시작(댓글작성내용 호출한 내용 뿌려주는곳)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailModel?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // 셀 높이 컨텐츠에 맞게 자동으로 설정// 컨텐츠의 내용높이 만큼이다.
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeartReplyCell.identifier, for: indexPath) as! HeartReplyCell
        // 델리게이트위임
        cell.delegate = self
        cell.replyText.text = self.detailModel?.results[indexPath.row].title
        cell.replyDate.text = self.detailModel?.results[indexPath.row].replyDate
        cell.replyId.text = self.detailModel?.results[indexPath.row].userID
        let getReplyName =  self.detailModel?.results[indexPath.row].userID
        cell.index = indexPath
        
        // 로그인한 아이디값
        let getName = plist.string(forKey: "name")
        
        if getReplyName == getName {
            cell.trash.layer.isHidden = false
        }else{
            cell.trash.layer.isHidden = true
        }
        
        return cell
        // 델리게이트위임
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        self.numberOfCell += 1
        tableView.reloadData()
    }
    
    
    // 댓글작성 업로드 API호출
    func replyUpload(success: (()->Void)? = nil, fail: ((String)->Void)? = nil) {
        // userID, postText,이미지묶음을 파라미터에 담아보냄
        // 로그인한 아이디값
        let getName = plist.string(forKey: "name")
        
        let param: Parameters = [
            "feedIdx": feedIdx,
            "title" : replyField.text ?? "",
            "userID" : getName ?? "아이디없음",
            "step" : 0 ,
        ]
        
        print("DetailVC/ 댓글기본입력내용 :\(param)")
        
        // API 호출 URL
        let url = self.BASEURL+"reply/reply.php"
        
        //이미지 전송
        let call = AF.request(url, method: .post, parameters: param,
                              encoding: JSONEncoding.default)
        //                call.responseJSON { res in
        call.responseJSON { res in
            
            // 성공실패케이스문 작성하기
            print("서버로 보냄!!!!!")
            //            print("JSON= \(try? res.result.get())!)")
            
            guard (try! res.result.get() as? NSDictionary) != nil else {
                print("올바른 응답값이 아닙니다.")
                return
            }
            
            
            if let jsonObject = try! res.result.get() as? [String :Any]{
                let success = jsonObject["success"] as? Int ?? 0
                let message = jsonObject["message"] as? String ?? ""
                
                if success == 1 {
                    //                    self.alert("응답값 JSON= \(try! res.result.get())!)")
                    //                    self.dismiss(animated: true, completion: nil)
                    print("응답내용\(message)")
                    
                }else{
                    //sucess가 0이면
                    //self.alert("응답실패")
                    
                    print("응답내용\(message)")
                }
            }
        }
    }//수정 함수끝
    
    // 작성한댓글 Load하기
    func loadReply(){
        //현재 페이지의 값에 1을 추가한다.
        // 호출시에 다음차례에 읽어야할 페이지를API에 실어서 함께 전달해야한다.
        // 스크롤뷰가 바닥에 닿으면 데이터를 새로불러온다.
        //asyncAfter는 실행할 시간(deadline)를 정해두고 실행 코드를 실행합니다(execute)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            //            self.page += 1
            
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            var components = URLComponents(string: self.BASEURL+"reply/replySelect.php")
            let presentPage = URLQueryItem(name: "presentPage", value: self.feedIdx.description)
            components?.queryItems = [presentPage]
            
            // url이 없으면 리턴한다. 여기서 끝
            guard let url = components?.url else { return }
            
            // 값이 있다면 받아와서 넣음.
            var request = URLRequest(url: url)
            
            print("url :\(request)")
            
            request.httpMethod = "GET" //GET방식이다. 컨텐츠타입이 없고, 담아서 보내는 내용이 없음, URL호출만!
            
            let task = session.dataTask(with: request) { data, response, error in
                print( (response as! HTTPURLResponse).statusCode )
                
                // 데이터가 있을때만 파싱한다.
                if let hasData = data {
                    // 모델만든것 가져다가 디코더해준다.
                    do{
                        // 만들어놓은 피드모델에 담음, 데이터를 디코딩해서, 디코딩은 try catch문 써줘야함
                        // 여기서 실행을 하고 오류가 나면 catch로 던져서 프린트해주겠다.
                        self.detailModel = try JSONDecoder().decode(DetailModel.self, from: hasData)
                        print("댓글로드")
                        print(self.detailModel ?? "no data")
                        
                        //모든UI 작업은 메인쓰레드에서 이루어져야한다.
                        DispatchQueue.main.async {
                            // 테이블뷰 갱신
                            self.tableView.reloadData()
                        }
                    }catch{
                        print(error)
                    }
                }
            }
            // task를 실행한다.
            task.resume()
            // 세션끝내기
            session.finishTasksAndInvalidate()
        })
    }// 함수끝
    
    
    // 댓글삭제 API호출
    func DeleteReply(replyIndex: Int?, success: (()->Void)? = nil, fail: ((String)->Void)? = nil) {
        // userID, postText,이미지묶음을 파라미터에 담아보냄
        let userID = heartResult?.userID
        
        // 선택한 셀의 댓글번호보내기
        let param: Parameters = [
            "feedIdx" : feedIdx,
            "replyIdx" : replyNum ,
            "userID" : userID ?? ""]
        
        print("댓글삭제\(param)")
        
        //        print(" API 게시글번호 2 :\(postIdx)")
        // API 호출 URL
        let url = self.BASEURL+"reply/replyDelete.php"
        
        //이미지 전송
        let call = AF.request(url, method: .post, parameters: param,
                              encoding: JSONEncoding.default)
        //                call.responseJSON { res in
        call.responseJSON { [self] res in
            
            guard (try! res.result.get() as? NSDictionary) != nil else {
                print("올바른 응답값이 아닙니다.")
                return
            }
            
            if let jsonObject = try! res.result.get() as? [String :Any]{
                let success = jsonObject["success"] as? Int ?? 0
                
                if success == 1 {
                    //                    self.alert("댓글삭제성공 JSON= \(try! res.result.get())!)")
                    //                    self.dismiss(animated: true, completion: nil)
                    //                    }
                    // 이거땜에 좋아요가 두번눌리고 오류냠
                    DispatchQueue.main.async {
                        // 테이블뷰 갱신 (자동으로 갱신안됨)
                        self.tableView.reloadData()
                        print("댓글 테이블갱신")
                    }
                }else{
                    //sucess가 0이면
                    self.alert("댓글삭제실패")
                }
            }
        }
        
    }//함수 끝
    
}



// 댓글삭제 버튼 프로토콜 셀
extension HeartDetailViewController: HeartReplyCellDelegate {
    
    func onClickCell(index: Int) {
        print("\(self.detailModel?.results[index].replyIdx?.description ?? "")글번호댓글눌림")
        // 댓글번호
        replyNum = self.detailModel?.results[index].replyIdx ?? 0
        // 댓글 삭제API 호출
        DeleteReply(replyIndex: replyNum)
        // 댓글다시로드
        loadReply()
    }
}
