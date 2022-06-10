//
//  HeartAPI.swift
//  TodoList
//
//  Created by 이청준 on 2022/06/10.
//

import Foundation
import UIKit
import Alamofire


final class HeartAPI{
    static let shared = HeartAPI()
    
    // 아이디값 가져오기
    let plist = UserDefaults.standard
    // 게시글번호 담을 변수
    // BASEURL
    var BASEURL = UrlInfo.shared.url!
    //API 호출상태값을 관리할 변수
    var isCalling = false
    var checkOn = false
    
    // 인디케이터추가
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    // 모델가져오기
    var feedModel: FeedModel?
    //피드 모델에 값이 있으면 가져온다.
    var feedResult: FeedResult?
    var page = 1
    
    // 모델가져오기
    var heartModel: HeartModel?
    //피드 모델에 값이 있으면 가져온다.
    var heartResult: HeartResult?
    
    //하트 업로드API
    func uploadHeart(postIdx: String?, success: (()->Void)? = nil, fail: ((String)->Void)? = nil) {
        
        // userID, postText,이미지묶음을 파라미터에 담아보냄
        let userID = plist.string(forKey: "name")
        
        let  feedIdx = postIdx
        
        // 선택한 셀의 게시글 번호를 가져오는 법 생각하기
        let param: Parameters = [  "cbHeart" : true,
                                   "postIdx" : feedIdx ?? "" ,
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
                self.isCalling = false
                print("HeartAPI : 서버호출 과정에서 오류가 발생했습니다.")
                return
            }
            
            if let jsonObject = try! res.result.get() as? [String :Any]{
                let success = jsonObject["success"] as? Int ?? 0
                
                if success == 1 {
                    print("HeartAPI: 업로드 성공 JSON= \(try! res.result.get())!)")
                    requestFeedAPI()
                    
                }else{
                    // sucess가 0이면
                    self.isCalling = false
                    
                }
            }
        }
    }// 하트업로드함수 끝
    
    
    // 하트 Delete API
    func DeleteHeart(postIdx: String?, success: (()->Void)? = nil, fail: ((String)->Void)? = nil) {
        
        // userID, postText,이미지묶음을 파라미터에 담아보냄
        let userID = plist.string(forKey: "name")
        
        // 받아온 게시글번호
        let feedIdx = postIdx
    
        // 선택한 셀의 게시글 번호를 가져오는 법 생각하기
        let param: Parameters = [
            "cbHeart" : true,
            "postIdx" : feedIdx ?? "" ,
            "userID" : userID ?? ""]
        
        print("HeartAPI :좋아요취소\(param)")
        
        // API 호출 URL
        let url = self.BASEURL+"post/0iOS_feedLike_delete.php"
        
        //이미지 전송
        let call = AF.request(url, method: .post, parameters: param,
                              encoding: JSONEncoding.default)
        //                call.responseJSON { res in
        call.responseJSON { [self] res in
            
            guard (try! res.result.get() as? NSDictionary) != nil else {
                self.isCalling = false

                print("HeartAPI : 올바른 응답값이 아닙니다.")
                return
            }
            
            if let jsonObject = try! res.result.get() as? [String :Any]{
                let success = jsonObject["success"] as? Int ?? 0
                
                if success == 1 {

                    print("HeartAPI 삭제성공: JSON= \(try! res.result.get())!)")
                    requestFeedAPI()
                
                    
                }else{
                    //sucess가 0이면
//                    self.alert("0")
                }
            }else{
                self.isCalling = false
                print("좋아요업로드 응답실패")
            }
        }
    }//하트삭제함수 끝
    
    
    // 글자메인피드호출API(전체정보한번에 가져옴, 좋아요포함)***************************************************************************
    func requestFeedAPI(){
        print("메인 피드 API호출")
        
        //지정된 값을 꺼내어 각 컨트롤에 설정한다.
        let getName = plist.string(forKey: "name")
        
        self.page += 1
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var components = URLComponents(string:self.BASEURL+"post/0iOS_feedSelect.php?page=\(self.page)")
        let userID = URLQueryItem(name: "userID", value: getName)
        let page = URLQueryItem(name: "page", value: "\(self.page)")
        components?.queryItems = [page,userID]
        
        // url이 없으면 리턴한다. 여기서 끝
        guard let url = components?.url else { return }
        
        // 값이 있다면 받아와서 넣음.
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        print("기본피드 : \(url)")
        
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
//                        self.tableView.reloadData()
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
    
    
    // 북마크 모음 격자무늬 호출
    func getHeartBookmark(){
        //    func newProfile(_ profile: UIImage?, success: (()->Void)? = nil, fail: ((String)->Void)? = nil) {
        // userID, postText,이미지묶음을 파라미터에 담아보냄
        let userID = plist.string(forKey: "name")
        
        let param: Parameters = [ "userID" :userID ?? "" ]
        
        // API 호출 URL
        let url =  self.BASEURL+"bookMark/heartBookmark.php"
        let call = AF.request(url, method: .post, parameters: param,
                              encoding: JSONEncoding.default)
        //                call.responseJSON { res in
        call.responseJSON { res in
            
            // 성공실패케이스문 작성하기
            print("좋아요로드 요청")
            //            print("JSON= \(try! res.result.get())!)")
            
            guard let jsonObject = try! res.result.get() as? [String :Any] else {
                print("올바른 응답값이 아닙니다.")
                return
            }
            
            if let jsonObject = try! res.result.get() as? [String :Any] {
                let success = jsonObject["success"] as? Int ?? 0
                
                if success == 1 {
                  
                    print("JSON= \(try! res.result.get())!)")
                    do{
                        // Any를 JSON으로 변경
                        let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
//                        print(dataJSON)
                        // JSON디코더 사용
                        self.heartModel = try JSONDecoder().decode(HeartModel.self, from: dataJSON)
           
//                        print((self.heartModel ?? "no data"))
                        
                        // 모든UI 작업은 메인쓰레드에서
                        DispatchQueue.main.async {
                            // 테이블뷰 갱신 (자동으로 갱신안됨)
//                            self.collectionView.reloadData()
                         }
                  
                    }// 디코딩 에러잡기
                        catch let DecodingError.dataCorrupted(context) {
                           print(context)
                       } catch let DecodingError.keyNotFound(key, context) {
                           print("Key '\(key)' not found:", context.debugDescription)
                           print("codingPath:", context.codingPath)
                       } catch let DecodingError.valueNotFound(value, context) {
                           print("Value '\(value)' not found:", context.debugDescription)
                           print("codingPath:", context.codingPath)
                       } catch let DecodingError.typeMismatch(type, context)  {
                           print("Type '\(type)' mismatch:", context.debugDescription)
                           print("codingPath:", context.codingPath)
                       } catch {
                           print("error: ", error)
                       }
                    }
                else if(success == 0){
                //sucess가 0이면
                        print("응답실패")
                    }
                }
            }
            }//함수 끝
    
}


