
import UIKit
import Alamofire
import SwiftyJSON

class HeartDetailViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    

    //피드 모델에 값이 있으면 가져온다.
//    var feedResult: FeedResult?
    // 모델가져오기
    var heartModel: HeartModel?

    //피드 모델에 값이 있으면 가져온다.
    var heartResult: HeartResult?
    
    var feedIdx = 0
    var replyNum = 0
    
    var BASEURL = "http://3.39.79.206/"
    @IBOutlet var movieCotainer: UIImageView!
    
    @IBOutlet var userID: UILabel!{
        didSet{
            userID.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
    }
    @IBOutlet var date: UILabel!{
        didSet{
            date.font = UIFont.systemFont(ofSize: 14, weight: .light)
        }
    }
    @IBOutlet var myPlaceText: UILabel!
    @IBOutlet var num: UILabel!
    
    // 댓글모델가져오기
    var detailModel: DetailModel?
    // 댓글모델
    //    var DetailResult: DetailResult?
   
    
    //댓글 테이블뷰
    @IBOutlet var tableView: UITableView!
    //댓글 작성영역
    @IBOutlet var replyField: UITextField!
    //댓글버튼
    @IBOutlet var replyBtn: UIButton!
    
    //댓글버튼
    @IBAction func replyBtn(_ sender: Any) {
        let replyText = replyField.text ?? "댓글작성없음"
        print("댓글작성내용:\(replyText)")
        // 서버로 댓글 내용업로드 API
//        replyUpload()
        // 작성한내용삭제
        replyField.text = ""
        //댓글 가져오기
//        self.loadReply()
        
    }
    
    //셀갯수
    //    var numberOfCell: Int = 10
    //    let examList = ["안녕","호호","하하","낄낄","호호"]
    
    
    @IBOutlet var postText: UITextView!{
        didSet{
            postText.font = UIFont.systemFont(ofSize: 16, weight: .light)
        }
    }
    
    // 노티1.시작의 시작등록.글수정후에 메인피드를 새로고침하기위한 노티 (노티의 이름은 ModifyVCNotification)
    let ModifyVCNotification: Notification.Name = Notification.Name("ModifyVCNotification")
    
    //취소버튼
    @IBAction func barCancleBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 완료버튼
    @IBAction func barOKBtn(_ sender: Any) {
        // 수정API호출
//        upDatePostText()
        // 노티2.창이 닫힐때 노티를 메인피드로 신호를 보낸다. //(노티의 이름은 ModifyVCNotification)
        NotificationCenter.default.post(name: ModifyVCNotification, object: nil, userInfo: nil)
        self.dismiss(animated: true, completion: nil)
        
    }


    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    // 화면이 그려지기전에 세팅한다.
    override func viewDidLoad() {
        super.viewDidLoad()
        // 델리게이트 연결
        postText.delegate = self
        replyField.delegate  = self

        
//        userID.text = heartResult?.userID
//        //        myPlaceText.text = feedResult?.myPlaceText
//        date.text = heartResult?.date
//        postText.text = heartResult?.postText
        //글번호
        //        num.text = feedResult?.feedIdx?.description
        
        // 게시글번호(수정시필요)
//        feedIdx = heartResult?.feedIdx ?? 0
        

        
    }// 뷰디드로드끝
    
    
}


