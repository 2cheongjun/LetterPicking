//
//  DetailViewController.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/31.
//

import UIKit

// 게시글눌렀을때 상세
class DetailViewController: UIViewController {
    
    //피드 모델에 값이 있으면 가져온다.
    var feedResult: FeedResult?

    
    @IBOutlet var movieCotainer: UIImageView!
    
    @IBOutlet var userID: UILabel!
    @IBOutlet var myPlaceText: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var postText: UILabel!{
        didSet{
            postText.font = UIFont.systemFont(ofSize: 24, weight: .light)
        }
    }
    
    // 화면이 그려지기전에 세팅한다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userID.text = feedResult?.userID
        myPlaceText.text = feedResult?.myPlaceText
        date.text = feedResult?.date
        postText.text = feedResult?.postText
        
        // 이미지처리방법
        if let hasURL = self.feedResult?.postImgs{
            // 이미지로드 서버요청
            self.loadImage(urlString: hasURL) { image in
                DispatchQueue.main.async {
                    self.movieCotainer.image = image
                }
            }
        }
    }
    
    // 이미지 Get요청
    func loadImage(urlString: String, completion: @escaping (UIImage?)-> Void){
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        // urlString 이미지이름을(ex:http://3.37.202.166/img/2-jun.jpg) 가져와서 URL타입으로 바꿔준다.
        if let hasURL = URL(string: urlString){
            var request = URLRequest(url: hasURL)
            request.httpMethod = "GET"
            //               request.httpMethod = "POST"
            
            session.dataTask(with: request) { data, response, error in
                //                   print( (response as! HTTPURLResponse).statusCode)
                
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
