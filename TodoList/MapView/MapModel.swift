//
//  MapModel.swift
//  TodoList
//
//  Created by 이청준 on 2022/04/04.
//

import Foundation

// 글가져오기할때 모델
struct MapModel: Codable{
    let addresses:[AddressResult]
}

struct AddressResult:Codable{
    let x: String
    let y: String
}

//{
//  "status" : "OK",
//  "errorMessage" : "",
//  "meta" : {
//    "totalCount" : 1,
//    "page" : 1,
//    "count" : 1
//  },
//  "addresses" : [
//    {
//      "addressElements" : [
//        {
//          "shortName" : "경기도",
//          "types" : [
//            "SIDO"
//          ],
//          "code" : "",
//          "longName" : "경기도"
//        },
//        {
//          "shortName" : "고양시 덕양구",
//          "types" : [
//            "SIGUGUN"
//          ],
//          "code" : "",
//          "longName" : "고양시 덕양구"
//        },
//        {
//          "shortName" : "행신동",
//          "types" : [
//            "DONGMYUN"
//          ],
//          "code" : "",
//          "longName" : "행신동"
//        },
//        {
//          "shortName" : "",
//          "types" : [
//            "RI"
//          ],
//          "code" : "",
//          "longName" : ""
//        },
//        {
//          "shortName" : "",
//          "types" : [
//            "ROAD_NAME"
//          ],
//          "code" : "",
//          "longName" : ""
//        },
//        {
//          "shortName" : "",
//          "types" : [
//            "BUILDING_NUMBER"
//          ],
//          "code" : "",
//          "longName" : ""
//        },
//        {
//          "shortName" : "",
//          "types" : [
//            "BUILDING_NAME"
//          ],
//          "code" : "",
//          "longName" : ""
//        },
//        {
//          "shortName" : "",
//          "types" : [
//            "LAND_NUMBER"
//          ],
//          "code" : "",
//          "longName" : ""
//        },
//        {
//          "shortName" : "",
//          "types" : [
//            "POSTAL_CODE"
//          ],
//          "code" : "",
//          "longName" : ""
//        }
//      ],
//      "jibunAddress" : "경기도 고양시 덕양구 행신동",
//      "roadAddress" : "경기도 고양시 덕양구 행신동",
//      "x" : "126.8359162",
//      "distance" : 0,
//      "englishAddress" : "Haengsin-dong, Deogyang-gu, Goyang-si, Gyeonggi-do, Republic of Korea",
//      "y" : "37.6223167"
//    }
//  ]
//}
