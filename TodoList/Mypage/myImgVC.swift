//
//  myImgVC.swift
//  TodoList
//
//  Created by 이청준 on 2022/05/31.
//
// 내글 모아보기(code로 작성)
import Foundation
import UIKit
import Kingfisher

class myImgVC: UIViewController {
    
    // 모델가져오기
    var feedModel: FeedModel?
    //피드 모델에 값이 있으면 가져온다.
    var feedResult: FeedResult?
    // 아이디값 가져오기
    let plist = UserDefaults.standard
    // 현재까지 읽어 온 데이터의 페이지 정보
    // 최초에 화면을 실행할때 이미 1페이지에 해당하는 데이터를 읽어 왔으므로,page의 초기값으로 1을 할당하는것이 맞다.
    var page = 1
    // BASEURL
    var BASEURL = UrlInfo.shared.url!
    
    @IBOutlet var closeBtn: UIBarButtonItem!
    // 닫기
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    private let tableView: UITableView = {
        let tableview = UITableView()
        return tableview
    }()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        setConstraint()

        // autoHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        // API호출
        requestFeedAPI()
    }
    
    // 테이블뷰의 위치설정
    private func setConstraint() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
           tableView.topAnchor.constraint(equalTo:self.view.topAnchor, constant: 50),
           tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
           tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
           tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    // 글자메인피드호출API(전체정보한번에 가져옴, 좋아요포함)*****
    func requestFeedAPI(){
        print("메인 피드 API호출")
        
        self.page += 1
        
        //지정된 값을 꺼내어 각 컨트롤에 설정한다.
        let getName = plist.string(forKey: "name")
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var components = URLComponents(string:self.BASEURL+"post/0iOS_feedSelect.php?page=\(self.page)")
        //        var components = URLComponents(string: self.BASEURL+"post/0iOS_feedSelect.php?page=\(1)")
        // let term = URLQueryItem(name: "term", value: "marvel")
        
        let userID = URLQueryItem(name: "userID", value: getName)
        
        let page = URLQueryItem(name: "page", value: "\(self.page)")
        components?.queryItems = [page,userID]
        
        // url이 없으면 리턴한다. 여기서 끝
        guard let url = components?.url else { return }
        
        print("기본피드 : \(url)")
        
        // 값이 있다면 받아와서 넣음.
        var request = URLRequest(url: url)
        request.httpMethod = "GET" //GET방식이다. 컨텐츠타입이 없고, 담아서 보내는 내용이 없음, URL호출만!
        
        let task = session.dataTask(with: request) { data, response, error in
            
            //            print( (response as! HTTPURLResponse).statusCode )
            
            // 데이터가 있을때만 파싱한다.
            if let hasData = data {
                // 모델만든것 가져다가 디코더해준다.
                do{
                    // 만들어놓은 피드모델에 담음, 데이터를 디코딩해서, 디코딩은 try catch문 써줘야함
                    // 여기서 실행을 하고 오류가 나면 catch로 던져서 프린트해주겠다.
                    self.feedModel = try JSONDecoder().decode(FeedModel.self, from: hasData)
                    //파싱이 끝나면 스크롤
                    
                    //                    print(self.feedModel ?? "no data")
                    
                    // 모든UI 작업은 메인쓰레드에서 이루어져야한다.
                    DispatchQueue.main.async {
                        // 인디케이터 에니메이션 종료
//                        self.indicator.stopAnimating()
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
    
    
    
}//VC끝

// 테이블뷰셀
extension myImgVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // 데이터 모델에 맞게 갯수
        return self.feedModel?.results.count ?? 0
//        return 5
    }
    
    // 눌렀을때 이벤트 호출
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 이동하고자하는 뷰턴 객체생성해 호출하기 / 스토리보드 기반으로 가져오기. 스토리보드ID
        let detailVC = UIStoryboard(name:"myImgDetailViewVC" , bundle: nil).instantiateViewController(withIdentifier: "myImgDetailViewVC") as! myImgDetailViewVC
        
        // 선택한것 눌렸다가 자연스럽게 흰색으로 전환
        tableView.deselectRow(at: indexPath, animated: true)
        
        //선택한 행의 내용을 feedResult에 담는다.
        detailVC.feedResult = self.feedModel?.results[indexPath.row]
        // 전체화면보기하면 닫기버튼이 없음 만들어줘야함.
        // detailVC.modalPresentationStyle = .fullScreen
        
        // 화면이 띄워진후에 값을 넣어야 널크러쉬가 안남
        self.present(detailVC, animated: true){ }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        
        // 작성내용
        let Str = self.feedModel?.results[indexPath.row].postText
        // 앞에서부터 10글자
        var prefix = Str?.description.prefix(10)
        // 작성내용
        cell.label.text = prefix?.description
        
        // 날짜가져옴
        let str = self.feedModel?.results[indexPath.row].date
        
        // 글자치환
        let newStr = str?.replacingOccurrences(of: "-", with: ".")
        //  앞에서 세번째 글자부터 뒤에서 -3번째 글자만 보이기
        let firstIndex = newStr?.index(newStr!.startIndex, offsetBy: 2)
        let lastIndex = newStr?.index(newStr!.endIndex, offsetBy: -3) // "Hello"
        let v = newStr?[firstIndex! ..< lastIndex!]
        
        // 앞뒤자른글자 담기
        cell.datelabel.text = v?.description
        
        // 킹피셔를 사용한 이미지 처리방법
        if let imageURL =  self.feedModel?.results[indexPath.row].postImgs  {
            // 이미지처리방법
            guard let url = URL(string: imageURL) else {
                //리턴할 셀지정하기
                return cell
            }
            // 이미지를 다운받는동안 인디케이터보여주기
            cell.img.kf.indicatorType = .activity
            print("이미지url \(url)")
            cell.img.kf.setImage(
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
        
        return cell
    }

}
