//
//  LoginInfo.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/15.
//
import Foundation


struct APIResponse: Codable{
    let contacts: [Contact]
}

struct Contact: Codable {
    let userID: String
    let userPassword: String
    let userName: String
}
    
   
