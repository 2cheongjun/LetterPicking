//
//  firstTabVC.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/19.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher


class firstTabVC: UIViewController{
    
    // 모델가져오기
    var feedModel: FeedModel?
    //피드 모델에 값이 있으면 가져온다.
    var feedResult: FeedResult?

    var numIdx = ""
    var Num = 0
    
    //userDefaults에 저장된이름값 가져오기
    let plist = UserDefaults.standard
    
    // 스크롤을 위한 것
    var fetchingMore = false
    
    var word = ""
    //좋아요를 하기위한 딕셔너리
    lazy var likes: [Int:Int] = [:]
    
    // 현재까지 읽어 온 데이터의 페이지 정보
    // 최초에 화면을 실행할때 이미 1페이지에 해당하는 데이터를 읽어 왔으므로,page의 초기값으로 1을 할당하는것이 맞다.
    var page = 1
    var BASEURL = "http://3.39.79.206/"
    
    //이미지캐시(URL string을 키값으로 구분하고 image를 넣어준다.)
//    private let imageCache = NSCache<NSString, UIImage>()
    
    // 로그인한 아이디명표기
    @IBOutlet weak var userName: UILabel!
    @IBOutlet var hi: UILabel! // 님 안녕하세요.
    @IBOutlet weak var writeBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var topBtn: UIButton!
    
    // 탑버튼 맨위로 이동
    @IBAction func TopBtn(_ sender: Any) {
        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    //댓글 수표기 작성예정
    
    override func viewDidLoad() {
        // 더보기 페이지 세팅
        page = 1
        // 델리게이트연결
        tableView.register(NewFeedCell.nib(), forCellReuseIdentifier: NewFeedCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        // 당겨서 새로고침설정
        tableView.refreshControl = UIRefreshControl()
        //        tableView.refreshControl?.attributedTitle = NSAttributedString(string:"당겨서 새로고침")
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        
        // 글쓰기 업데이트노티피케이션
        // 노티3.WriteVC에서 보낸 값을 받기위해 DissmissWrite의 노티피케이션을 정의해 받을 준비한다.
        let DissmissWriteVC = Notification.Name("DissmissWriteVC")
        // 노티4.옵저버를 등록하고,DissmissWrite가 오면 writeVCNotification함수를 실행한다.
        NotificationCenter.default.addObserver(self, selector: #selector(self.writeVCNotification(_:)), name: DissmissWriteVC, object: nil)
        
        // 수정업데이트노티피케이션
        // 노티3.WriteVC에서 보낸 값을 받기위해 DissmissWrite의 노티피케이션을 정의해 받을 준비한다.
        let ModifyVCNotification = Notification.Name("ModifyVCNotification")
        // 노티4.옵저버를 등록하고,DissmissWrite가 오면 writeVCNotification함수를 실행한다.
        NotificationCenter.default.addObserver(self, selector: #selector(self.ModifyVCNotification(_:)), name: ModifyVCNotification, object: nil)
        
        /*
         *  userDefaults에 저장된이름값 가져오기
         */
        let plist = UserDefaults.standard
        //지정된 값을 꺼내어 각 컨트롤에 설정한다.
        let getName = plist.string(forKey: "name")
        self.userName.text = getName ?? ""
        if getName != nil {
            
        }else{
            self.userName.text = getName ?? "" + "로그인이 필요합니다."
        }
        
        
        // 상단 백버튼가림
        self.navigationController?.navigationBar.isHidden = true
        
        // API호출
        if feedModel?.results.count != 0{
            requestFeedAPI()
        
            self.topBtn.isHidden = false
        }else{
            print("데이터없음")
        }
    }
    
    
    
    // 뷰가보일때 다시 호출
    override func viewWillAppear(_ animated: Bool) {
        // 더보기 페이지 세팅
        page = 1
        // API호출
        requestFeedAPI()
        
        // 수정업데이트노티피케이션
        // 노티3.WriteVC에서 보낸 값을 받기위해 DissmissWrite의 노티피케이션을 정의해 받을 준비한다.
        let ModifyVCNotification = Notification.Name("ModifyVCNotification")
        // 노티4.옵저버를 등록하고,DissmissWrite가 오면 writeVCNotification함수를 실행한다.
        NotificationCenter.default.addObserver(self, selector: #selector(self.ModifyVCNotification(_:)), name: ModifyVCNotification, object: nil)
        
    }
    
    
    
    //스크롤시페이징
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 스크롤뷰 세로끝 보다 테이블뷰의 하이트가 커지면(스크롤뷰가 끝에 닿으면)
        if self.tableView.contentOffset.y > tableView.contentSize.height-tableView.bounds.size.height {
            
            // fetchingMore를 사용해서 딱 한 번만 저 if문안에 있는 코드를 실행한다.
            if !fetchingMore {
                print("끝에 도달")
                moreData()
            }
        }
    }
    // 페이징 기능 /스크롤시 바닥에 닿으면 데이터추가로 가져옴
    func moreData(){
        // 현재 페이지의 값에 1을 추가한다.
        // 호출시에 다음차례에 읽어야할 페이지를API에 실어서 함께 전달해야한다.
        // 스크롤뷰가 바닥에 닿으면 데이터를 새로불러온다.
        fetchingMore = true
        //asyncAfter는 실행할 시간(deadline)를 정해두고 실행 코드를 실행합니다(execute)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            self.page += 1
            
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            var components = URLComponents(string:self.BASEURL+"post/0iOS_feedSelect.php?page=\(self.page)")
            //        var components = URLComponents(string: "http://3.37.202.166/post/0iOS_feedSelect.php")
            
            //        let term = URLQueryItem(name: "term", value: "marvel")
            let page = URLQueryItem(name: "page", value: "\(self.page)")
            components?.queryItems = [page]
            
            // url이 없으면 리턴한다. 여기서 끝
            guard let url = components?.url else { return }
            
            // 값이 있다면 받아와서 넣음.
            var request = URLRequest(url: url)
            
            print("url :\(request)")
            
            //        request.httpMethod = "GET" //GET방식이다. 컨텐츠타입이 없고, 담아서 보내는 내용이 없음, URL호출만!
            request.httpMethod = "GET" //GET방식이다. 컨텐츠타입이 없고, 담아서 보내는 내용이 없음, URL호출만!
            
            let task = session.dataTask(with: request) { data, response, error in
                print( (response as! HTTPURLResponse).statusCode )
                
                // 데이터가 있을때만 파싱한다.
                if let hasData = data {
                    // 모델만든것 가져다가 디코더해준다.
                    do{
                        // 만들어놓은 피드모델에 담음, 데이터를 디코딩해서, 디코딩은 try catch문 써줘야함
                        // 여기서 실행을 하고 오류가 나면 catch로 던져서 프린트해주겠다.
                        self.feedModel = try JSONDecoder().decode(FeedModel.self, from: hasData)
                        //                    print(self.feedModel ?? "no data")
                        // 파싱하고 스크롤되게하기
                        self.fetchingMore = false
                        // 모든UI 작업은 메인쓰레드에서 이루어져야한다.
                        DispatchQueue.main.async {
                            // 테이블뷰 갱신 (자동으로 갱신안됨)
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
    }
    
    
    
    // 화면을 누르면 키보드 내려가게 하는 것
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 노티5.옵저버가 DissmissWrite를 받았을때 실행할 내용: 데이터 리로드
    @objc func writeVCNotification(_ noti: Notification) {
        // API호출
        requestFeedAPI()
        print("글쓰기업뎃노티피케이션")
        // 이 부분을 해주어야 다시 comment들을 api로 가져올 수 있었다.
        // 즉, reload할 데이터를 불러와야 바뀌는 게 있다는 의미다.
        // 안 해서 고생함...
        OperationQueue.main.addOperation { // DispatchQueue도 가능.
            self.tableView.reloadData()
        }
    }
    
    // 노티5.옵저버가 DissmissWrite를 받았을때 실행할 내용: 데이터 리로드
    @objc func ModifyVCNotification(_ noti: Notification) {
        // API호출
        requestFeedAPI()
        print("수정업뎃노티피케이션")
        OperationQueue.main.addOperation { // DispatchQueue도 가능.
            self.tableView.reloadData()
        }
    }
    
    
    // network /URL세션으로 호출 // 추후 아이디값을 보내서 호출하는것도..생각해보기?? 전체다 가져오는것이니 상관없을까?..*********************************
    func requestFeedAPI(){
        print("메인 피드 API호출")
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let components = URLComponents(string: self.BASEURL+"post/0iOS_feedSelect.php?page=\(1)")
        //        let term = URLQueryItem(name: "term", value: "marvel")
        //        let page = URLQueryItem(name: "page", value: "1")
        //        components?.queryItems = [page]
        
        // url이 없으면 리턴한다. 여기서 끝
        guard let url = components?.url else { return }
        
        print("기본피드 : \(url)")
        
        // 값이 있다면 받아와서 넣음.
        var request = URLRequest(url: url)
        request.httpMethod = "GET" //GET방식이다. 컨텐츠타입이 없고, 담아서 보내는 내용이 없음, URL호출만!
        
        let task = session.dataTask(with: request) { data, response, error in
            print( (response as! HTTPURLResponse).statusCode )
            
            // 데이터가 있을때만 파싱한다.
            if let hasData = data {
                // 모델만든것 가져다가 디코더해준다.
                do{
                    // 만들어놓은 피드모델에 담음, 데이터를 디코딩해서, 디코딩은 try catch문 써줘야함
                    // 여기서 실행을 하고 오류가 나면 catch로 던져서 프린트해주겠다.
                    self.feedModel = try JSONDecoder().decode(FeedModel.self, from: hasData)
                    //파싱이 끝나면 스크롤
                    
                    print(self.feedModel ?? "no data")
                    
                    // 모든UI 작업은 메인쓰레드에서 이루어져야한다.
                    DispatchQueue.main.async {
                        // 테이블뷰 갱신 (자동으로 갱신안됨)
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
        
    }// 호출메소드끝
    
    
    


// 이미지 URL로드하기
func loadImage(urlString: String, completion: @escaping (UIImage?)-> Void){
    // url로 가져와 UIImage로 리턴한다.
    
    let sessionConfig = URLSessionConfiguration.default
    let session = URLSession(configuration: sessionConfig)
    
    // urlString 이미지이름을(ex:http://3.37.202.166/img/2-jun.jpg) 가져와서 URL타입으로 바꿔준다.
    if let hasURL = URL(string: urlString){
        var request = URLRequest(url: hasURL)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { data, response, error in
            // print( (response as! HTTPURLResponse).statusCode)
            // 데이터가 있으면 UIImage로 리턴
            if let hasData = data {
                completion(UIImage(data: hasData))
                
                //                    print("hasData: \(hasData)")
                return

            }
        }.resume() //실행한다.
        session.finishTasksAndInvalidate()
    }
    // 실패시 nil리턴한다.
    completion(nil)
    
}

// 당겨서 새로고침 함수
@objc func pullToRefresh(_ sender: Any) {
    // 테이블뷰에 입력되는 데이터를 갱신한다.
    // API호출
    // 당겨서 새로고침하면,more누를때 다시 page번호를 1로세팅해준다.1부터 다시더해지도록..
    page = 1
    
    requestFeedAPI()
    self.tableView.reloadData()
    //당겨서 새로고침 기능 종료
    self.tableView.refreshControl?.endRefreshing()
}

// 애니메이션설정
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

// 글 작성버튼
@IBAction func writeBtn(_ sender: Any) {
    // 스토리보드 세그로 연결함
    
}

// 검색요청 API ***************************************************************************************
func searchWord(success: (()->Void)? = nil, fail: ((String)->Void)? = nil) {
    // 검색창에 작성한 단어
    print("firstTabVC/ 단어입력내용 :\(self.word)")
    
    let sessionConfig = URLSessionConfiguration.default
    let session = URLSession(configuration: sessionConfig)
    var components = URLComponents(string: self.BASEURL+"post/0iOS_feedSearch.php?word=\(word)")
    
    //        let term = URLQueryItem(name: "term", value: "marvel")
    let page = URLQueryItem(name: "word", value: word )
    components?.queryItems = [page]
    
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
                self.feedModel = try JSONDecoder().decode(FeedModel.self, from: hasData)
                //                    print(self.feedModel ?? "no data")
                
                // 모든UI 작업은 메인쓰레드에서 이루어져야한다.
                DispatchQueue.main.async {
                    // 테이블뷰 갱신 (자동으로 갱신안됨)
                    self.tableView.reloadData()
                }
            
            } catch {
                print("error: ", error)
            }
        }
    }
    // task를 실행한다.
    task.resume()
    // 세션끝내기
    session.finishTasksAndInvalidate()
    
}//함수 끝

}// 뷰컨끝




// 테이블뷰
extension firstTabVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 데이터 모델에 맞게 갯수
        return self.feedModel?.results.count ?? 0
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 400
    //    }
    
    // 셀 높이 컨텐츠에 맞게 자동으로 설정// 컨텐츠의 내용높이 만큼이다.
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // 눌렀을때 이벤트 호출
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 이동하고자하는 뷰턴 객체생성해 호출하기 / 스토리보드 기반으로 가져오기. 스토리보드ID
        let detailVC = UIStoryboard(name:"DetailViewController" , bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        // 선택한것 눌렸다가 자연스럽게 흰색으로 전환
        tableView.deselectRow(at: indexPath, animated: true)
        
        //선택한 행의 내용을 feedResult에 담는다.
        detailVC.feedResult = self.feedModel?.results[indexPath.row]
        // 전체화면보기하면 닫기버튼이 없음 만들어줘야함.
        //        detailVC.modalPresentationStyle = .fullScreen
        
        
        // 화면이 띄워진후에 값을 넣어야 널크러쉬가 안남
        self.present(detailVC, animated: true){ }
    }
    
    // 데이터소스에 요청하는 곳 | 새로운셀을 표시할때마다 매번 새롭게 구성됨
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewFeedCell.identifier, for: indexPath) as! NewFeedCell
        // 델리게이트위임
        cell.delegate = self
        // 좋아요를위한 인덱스 담기
        cell.index = indexPath.row
        cell.indexNum = indexPath
        
        cell.titleLabel.text = self.feedModel?.results[indexPath.row].postText
        cell.descriptionLabel.text = self.feedModel?.results[indexPath.row].userID
        cell.dataLabel.text =  self.feedModel?.results[indexPath.row].date
        cell.priceLabel.text =  self.feedModel?.results[indexPath.row].myPlaceText
        cell.num.text =  self.feedModel?.results[indexPath.row].feedIdx?.description ?? ""
        
        // 게시글번호에 따른 하트여부 1이면 하트 눌림 ************************************************************
        Num = self.feedModel?.results[indexPath.row].cbheart ?? 0
        print("하트번호 \(self.feedModel?.results[indexPath.row].cbheart?.description ?? "")")
//
        if (self.feedModel?.results[indexPath.row].cbheart ?? 0 > 0){
            // 0보다 그면 하트를 눌린상태로 만든다.
            likes[indexPath.row] = 1
       }
        
        //좋아요 버튼 눌림 상태 *******************************************************************************
        if likes[indexPath.row] == 1 {
            cell.isTouched = true
            numIdx  = self.feedModel?.results[indexPath.row].feedIdx?.description ?? ""
            print("게시글 true :\(numIdx)")
            
        }else{
            cell.isTouched = false
        }

        // 킹피셔를 사용한 이미지 처리방법
        if let imageURL =  self.feedModel?.results[indexPath.row].postImgs  {
            // 이미지처리방법
            guard let url = URL(string: imageURL) else {
                //리턴할 셀지정하기
                return cell
            }
            // 이미지를 다운받는동안 인디케이터보여주기
            cell.imageViewLabel.kf.indicatorType = .activity
            print("이미지url \(url)")
            cell.imageViewLabel.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholderImage"),
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            {
                result in
                switch result {
                case .success(let value):
                    print("킹피셔 Task done")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }
        
        // loadImage함수를 이용한 이미지처리방법
        //        if let hasURL = self.feedModel?.results[indexPath.row].postImgs{
        //            print("이미지url \(hasURL)")
        //
        //            //이미지로드 서버요청
        //            self.loadImage(urlString: hasURL) { image in
        //                DispatchQueue.main.async {
        //                    cell.imageViewLabel.image = image
        //                }
        //            }
        //        }
        
        return cell
    }
    
    
    //하트 업로드API
    func uploadHeart(postIdx: String?, success: (()->Void)? = nil, fail: ((String)->Void)? = nil) {
        
        // userID, postText,이미지묶음을 파라미터에 담아보냄
        let userID = plist.string(forKey: "name")
        
        // 선택한 셀의 게시글 번호를 가져오는 법 생각하기
        let param: Parameters = [  "cbHeart" : true,
                                   "postIdx" : numIdx ?? 0 ,
                                   "userID" : userID ?? ""]
        
        print(" API좋아요:\(param)")
        // API 호출 URL
        let url = self.BASEURL+"post/0iOS_feedLike.php"
        
        //이미지 전송
        let call = AF.request(url, method: .post, parameters: param,
                              encoding: JSONEncoding.default)
        //                call.responseJSON { res in
        call.responseJSON { [self] res in
            
            // 성공실패케이스문 작성하기
            //            print("서버로 보냄!!!!!")
            //            print("JSON= \(try! res.result.get())!)")
            
            guard (try! res.result.get() as? NSDictionary) != nil else {
                print("올바른 응답값이 아닙니다.")
                return
            }
            
            if let jsonObject = try! res.result.get() as? [String :Any]{
                let success = jsonObject["success"] as? Int ?? 0
                
                if success == 1 {
                    self.alert("좋아요업로드 성공 JSON= \(try! res.result.get())!)")
                    self.dismiss(animated: true, completion: nil)
                    
                    // 이거땜에 좋아요가 두번눌리고 오류냠
                    //                    DispatchQueue.main.async {
                    //                        // 테이블뷰 갱신 (자동으로 갱신안됨)
                    //                        self.tableView.reloadData()
                    //                    }
                    
                }else{
                    //sucess가 0이면
                    self.alert("좋아요업로드 응답실패")
                }
            }
        }
        
    }//함수 끝
    
    
    //    //하트 Delete API
    func DeleteHeart(postIdx: String?, success: (()->Void)? = nil, fail: ((String)->Void)? = nil) {
        // userID, postText,이미지묶음을 파라미터에 담아보냄
        let userID = plist.string(forKey: "name")
        
        // 선택한 셀의 게시글 번호를 가져오는 법 생각하기
        let param: Parameters = [
            "cbHeart" : true,
            "postIdx" : numIdx ?? 0 ,
            "userID" : userID ?? ""]
        
        print("좋아요취소\(param)")
        
        //        print(" API 게시글번호 2 :\(postIdx)")
        // API 호출 URL
        let url = self.BASEURL+"post/0iOS_feedLike_delete.php"
        
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
                    self.alert("좋아요취소성공 JSON= \(try! res.result.get())!)")
                    self.dismiss(animated: true, completion: nil)
                    //                    }
                }else{
                    //sucess가 0이면
                    self.alert("0")
                }
            }
        }
        
    }//함수 끝
}

// 이미지캐시작업을 위한 싱글톤 클래스생성
class ImageCacheManager{
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}


// 서치바, 검색창
extension firstTabVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let hasText = searchBar.text else {
            return
        }
        word = hasText
        // 검색요청하기
        searchWord()
        self.view.endEditing(true)
    }
}


// 좋아요 프로토콜 구현부
extension firstTabVC: firstTabVCCellDelegate{
    
    // 하트눌림 (몇번째 게시글에 좋아요가 눌렸나, 좋아요시true, 게시글번호 넘김)
    func didPressHeart(for index: Int, like: Bool, indexNum: Int) {
        
        if like{
            likes[index] = 1
            print("\(indexNum) 클릭")
            print("\(self.feedModel?.results[indexNum].feedIdx?.description ?? "")글번호 좋아요눌림")
            numIdx = self.feedModel?.results[indexNum].feedIdx?.description ?? ""
            // 좋아요 insert
            uploadHeart(postIdx:numIdx)
            
            
        }else{
            likes[index] = 0
            // print("cell \(likes[index]!)")
            print("\(self.feedModel?.results[indexNum].feedIdx?.description ?? "")글번호 좋아요꺼짐")
            numIdx = self.feedModel?.results[indexNum].feedIdx?.description ?? ""
            // 좋아요 Delete
            DeleteHeart(postIdx: numIdx)
        }
    }
}


