
import Foundation
import UIKit

// 글가져오기할때 모델
struct HeartModel: Codable{
    
    let results:[HeartResult]
}

struct HeartResult: Codable{
//    let success: String
    let postIdx:Int?
    let postImgs: String?
    let message: String?
}
