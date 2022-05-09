//
//  noticeVC.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/28.
//

import UIKit

// 하트모음 컬렉션뷰
class HeartVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let cellIdentifier:String = "cell"
    // 모델가져오기
    var feedModel: FeedModel?
    var page = 1
    var BASEURL = "http://3.39.79.206/"
    
    // 콜렉션뷰 연결
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //델리게이트연결안하면 뷰에 보이지도 않음
        collectionView.delegate = self
        collectionView.dataSource = self
        // 북마크모음게시글 요청
        requestFeedAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 좋아요모음글호출
        requestFeedAPI()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return self.numberOfCell
        return self.feedModel?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as?
                HeartCollectionViewCell else {
            return HeartCollectionViewCell()
        }
        // 델리게이트위임
        // cell.delegate = self
        cell.addressLabel.text = self.feedModel?.results[indexPath.row].feedIdx?.description ?? ""
        // 이미지처리방법
        if let hasURL = self.feedModel?.results[indexPath.row].postImgs{
            // 이미지로드 서버요청
            self.loadImage(urlString: hasURL) { image in
                DispatchQueue.main.async {
                    cell.postImg.image = image
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        // 컬랙션뷰의 데이터를 먼저 삭제 해주고, 데이터 배열의 값을 삭제해줍니다!! , '반대로할시에 데이터가 꼬이는 현상이 발생합니다.'
        //        self.numberOfCell += 1
        // 선택한 번호에 해당하는 셀지우기 어떻게????
        print(indexPath.row)
        
    }
    
   
    // network /URL세션으로 호출 // 추후 아이디값을 보내서 호출하는것도..생각해보기?? 전체다 가져오는것이니 상관없을까?..
    func requestFeedAPI(){
        print("메인 피드 API호출")
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
//        var components = URLComponents(string: self.BASEURL+"bookMark/heartBookmark.php?page=\(1)")
        var components = URLComponents(string: self.BASEURL+"bookMark/heartBookmarkcopy.php?page=\(1)")
//        var components = URLComponents(string: self.BASEURL+"bookMark/heartBookmark.php")
        //        let term = URLQueryItem(name: "term", value: "marvel")
        //        let page = URLQueryItem(name: "page", value: "1")
//                components?.queryItems = [page]
        
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
                    print(self.feedModel ?? "no data")
                    //파싱이 끝나면 스크롤
                    
                    // 모든UI 작업은 메인쓰레드에서 이루어져야한다.
                    DispatchQueue.main.async {
                        // 테이블뷰 갱신 (자동으로 갱신안됨)
                        self.collectionView.reloadData()
                        
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
    
    
    // 이미지 URL로드하기 ***********************************************************************************************8
    func loadImage(urlString: String, completion: @escaping (UIImage?)-> Void){
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        // urlString 이미지이름을(ex:http://3.37.202.166/img/2-jun.jpg) 가져와서 URL타입으로 바꿔준다.
        if let hasURL = URL(string: urlString){
            var request = URLRequest(url: hasURL)
            request.httpMethod = "GET"
            
            session.dataTask(with: request) { data, response, error in
                //                   print( (response as! HTTPURLResponse).statusCode)
                // 데이터가 있으면 UIImage로 리턴
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
}


// cell layout
extension HeartVC: UICollectionViewDelegateFlowLayout {

    // 위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    // cell 사이즈( 옆 라인을 고려하여 설정 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.width / 3 - 1 ///  3등분하여 배치, 옆 간격이 1이므로 1을 빼줌
        print("collectionView width=\(collectionView.frame.width)")
        print("cell하나당 width=\(width)")
        print("root view width = \(self.view.frame.width)")

        let size = CGSize(width: width, height: width)
        return size
    }
}

