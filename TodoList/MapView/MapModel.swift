//
//  MapModel.swift
//  TodoList
//
//  Created by 이청준 on 2022/04/04.
//

import Foundation

// 글가져오기할때 모델
struct MapModel: Codable{
    
//    let resultCount: Int
    // 아래정의된 배열묶음
    let results:[MapResult]
}

struct MapResult: Codable{
//    let success: String
//    let feedIdx: String
    let lat: Double?
    let lon: Double?
}
