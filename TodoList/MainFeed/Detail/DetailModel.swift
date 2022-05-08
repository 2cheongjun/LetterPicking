//
//  DetailModel.swift
//  TodoList
//
//  Created by 이청준 on 2022/05/04.
//

import Foundation
import UIKit

// 글가져오기할때 모델
struct DetailModel: Codable{
    
//    let resultCount: Int
    // 아래정의된 배열묶음
    let results:[DetailResult]
}

struct DetailResult: Codable{
//    let success: String?
//    let message: String?
    let replyIdx: Int?
    let postIdx:String?
    let userID: String
    let imgPath: String?
    let title: String?
    let replyDate: String
    let ref : String?
    let step: String?
}

