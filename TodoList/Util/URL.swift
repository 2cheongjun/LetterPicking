//
//  BaseURL.swift
//  TodoList
//
//  Created by 이청준 on 2022/05/24.
//

import Foundation

// BASE URL주소
class UrlInfo {
    static let shared = UrlInfo(url: "http://3.39.79.206/")
    var url: String?
    
    init (url: String) {
         self.url = "http://3.39.79.206/"
     }
}



