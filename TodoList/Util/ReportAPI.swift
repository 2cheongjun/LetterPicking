//
//  HeartAPI.swift
//  TodoList
//
//  Created by 이청준 on 2022/06/10.
//

import Foundation
import UIKit
import Alamofire

extension UIViewController {
    // 댓글신고API
    final class ReportAPI{
        static let shared = ReportAPI()
        
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
        
        
        // 신고ID API호출
        func requstCutID(postIdx: String?, replyIdx: String?, cutIdx: String?, success: (()->Void)? = nil, fail: ((String)->Void)? = nil) {
            
            // 받아온 게시글번호
            let feedIdx = postIdx
            let replyIdx = replyIdx
            let replyUserID = cutIdx
            
            // userID, postText,이미지묶음을 파라미터에 담아보냄
            let userID = plist.string(forKey: "name")
            
            // 내아이디, 신고아이디, 글번호전송
            let param: Parameters = [
                "postIdx" : feedIdx ?? "",
                "replyIdx" :replyIdx ?? "",
                "cutID" : replyUserID ?? "",
                "userID" : userID ?? ""]
            
            print("댓글 신고 업로드 \(param)")
            
            // API 호출 URL
            let url = self.BASEURL+"reply/replyReport.php"
            
            // AF에 담아보내기
            let call = AF.request(url, method: .post, parameters: param,
                                  encoding: JSONEncoding.default)
            //                call.responseJSON { res in
            call.responseJSON { [self] res in
                
                guard (try! res.result.get() as? NSDictionary) != nil else {
                    self.isCalling = false
                    print("서버호출 과정에서 오류가 발생했습니다.")
                    return
                }
                
                if let jsonObject = try! res.result.get() as? [String :Any]{
                    let success = jsonObject["success"] as? Int ?? 0
                    
                    if success == 1 {
                        // 테이블뷰 재호출(1초뒤 실행)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                            // 1초 후 실행될 부분
//                            self.alert("\(cutIdx)님을 차단하였습니다.")
                            
                            // self.dismiss(animated: true, completion: nil)
                            print("신고성공 JSON= \(try! res.result.get())!)")
                        }
                        
                        // }
                    }else{
                        //sucess가 0이면
//                        self.alert("0")
                        // 1초 후 실행될 부분
                        //                      self.alert("\(cutID)님을 차단 실패하였습니다.")
                    }
                }else{
                    self.isCalling = false
                    print("신고업로드 응답실패")
                    //                self.alert("신고업로드 응답실패, 통신상태가 좋지 않습니다.")
                    
                }
            }
        }// 신고업로드함수 끝
    }
}


