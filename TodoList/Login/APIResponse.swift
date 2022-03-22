//
//  LoginInfo.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/15.
//

// 코더블 사용안됨.. 로그인API는 LoginVC에 작성...
import Foundation

//{
//    "success": true,
//    "result": "SUCCESS",
//    "userID": "jun",
//    "userPassword": "1111",
//    "userEmail": "lcj88732@gmail.com"
//}

struct APIResponse: Codable{
    let contacts: [Contact]
}

struct Contact: Codable {
    let userID: String
    let userPassword: String
    let userName: String
}
    
   
