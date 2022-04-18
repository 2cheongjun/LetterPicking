//
//  Friend.swift
//  TodoList
//
//  Created by 이청준 on 2022/04/19.
//

import Foundation

struct Friend: Codable{
    
    struct Adderess: Codable{
        let country: String
        let city: String
    }
    
    let name: String
    let age: Int
    let addressInfo: Adderess
    
    var nameAndAge: String{
        return self.name + "(\(self.age)"
    }
    
    var fullAddress: String {
        return self.addressInfo.city + ", " + self.addressInfo.country
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case age
        case addressInfo = "address_info"
    }
}
