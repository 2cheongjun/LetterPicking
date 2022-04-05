//
//  FeedModel.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/21.
//

import Foundation

// 글가져오기할때 모델
struct FeedModel: Codable{
    
//    let resultCount: Int
    // 아래정의된 배열묶음
    let results:[FeedResult]
}

struct FeedResult: Codable{
//    let success: String
//    let feedIdx: String
    let userID: String
    let postText: String?
    let postImgs: String?
    let myPlaceText: String
    let date: String
//    let feedIdx:String
    let feedIdx:Int
}

//
//  FeedModel.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/21.
//

//import Foundation
//
//struct FeedModel: Codable{
//
//    let resultCount: Int
//    // 아래정의된 배열묶음
//    let results:[Result]
//}
//
//struct Result: Codable{
//    let trackName: String
//    let previewUrl: String
//    let image: String
//    let shortDescription: String?
//    let longDescription: String
//    let trackPrice: Double
//    let currency: String
//    let releaseDate: String
//
//    // 가져온이름을 바꿔서 사용하고싶을때, 정의해야함.
//    //artworkUrl100를 image로 바꿔서 사용하고 싶다.
//    enum CodingKeys: String, CodingKey {
//        case image = "artworkUrl100"
//        case trackName
//        case previewUrl
//        case shortDescription
//        case longDescription
//        case trackPrice
//        case currency
//        case releaseDate
//    }
//}

