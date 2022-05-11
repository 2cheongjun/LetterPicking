
import Foundation
import UIKit

// 글가져오기할때 모델
struct HeartModel: Codable{
    
//    let resultCount: Int
    // 아래정의된 배열묶음
    let results:[HeartResult]
}

struct HeartResult: Codable{
//    let success: String
//    let feedIdx: String
//    let userID: String
//    let postText: String?
//    let myPlaceText: String?
//    let date: String
    let postIdx:Int?
    let postImgs: String?
    let message: String?
}
