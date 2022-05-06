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
    let success: String?
    let userID: String
    let title: String?
    let replyDate: String
    let replyIdx: Int?
    let feedIdx:Int?
    let message: String?
    let ref : String?
    let step: String?
}

/*
$response["success"] = $success;
$response["message"] = $message;

$response["userID"] = $userID;
$response["feedIdx"] = $feedIdx;
$response["title"] = $title;
$response["ref"] = $ref;
$response["step"] = $step;
 

 // echo json_encode(['results' => $result] );
    echo json_encode($response);
*/
