//
//  UserInfoManager.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/14.
//

import UIKit

struct UserInfoKey {
    // 저장에 사용할 키
    static let loginId = "LOGINID"
    static let account = "ACCOUNT"
    static let name = "NAME"
    static let profile = "PROFILE"
}

//계정 및 사용자 정보를 저장 관리하는 클래스
class UserInfoManager {
    //연산 프로퍼티 loginId 정의
    var loginId : Int {
        get { // 읽기를 위한 get
            // 프로퍼티 리스트에 저장된 로그인 아이디를 꺼내어 제공
            return UserDefaults.standard.integer(forKey: UserInfoKey.loginId)
        }
        set(v){ // 쓰기를 위한 set
            // loginId 프로퍼티에 할당된 값을 프로퍼티 리스트에 저장한다.
            let ud = UserDefaults.standard
            ud.set(v, forKey:UserInfoKey.loginId)
            //싱크맞추기
            ud.synchronize()
        }
    }
    
    
    //연산 프로퍼티 .account 정의
    // 옵셔널 타입으로 선언, 이류는 비로그인 상태일때 이값을 nil로 설정하기위함
    var account: String? {
        get {
            // 프로퍼티 리스트에 저장된 로그인 아이디를 꺼내어 제공
            return UserDefaults.standard.string(forKey: UserInfoKey.account)
        }
        set(v){
            // loginId 프로퍼티에 할당된 값을 프로퍼티 리스트에 저장한다.
            let ud = UserDefaults.standard
            ud.set(v, forKey:UserInfoKey.account)
            ud.synchronize()
        }
    }
    
    // name정의
    var name: String? {
        get{
            return UserDefaults.standard.string(forKey: UserInfoKey.name)
        }
        set(v){
            let ud = UserDefaults.standard
            ud.set(v,forKey: UserInfoKey.name)
            ud.synchronize()
        }
    }
    
    // 연산profile정의
    var profile: UIImage? {
        get{
            let ud = UserDefaults.standard
            // Data로 읽어들인 이미지를 UIImage로 변환하여 리턴한다.
            if let _profile = ud.data(forKey: UserInfoKey.profile){
                return UIImage(data:_profile)
            }else{
                // 값이 없을 경우 기본이미지를 출력
                return UIImage(named: "account.jpg")
            }
        }set(v){
            if v != nil {
                let ud = UserDefaults.standard
                //pngData()는 UIImage타입을 ->Data로 변환해줌 변환후 저장한다.
                ud.set(v!.pngData(), forKey: UserInfoKey.profile)
                ud.synchronize()
            }
        }
    }
    
    // 로그인 상태를 판별하는 연산프로퍼티
    var isLogin: Bool {
        //로그인 아dl디가 0이거나 계정이 비어있으면
        if self.loginId == 0 || self.account == nil {
            return false
        }else {
            return true
        }
    }
    
    //로그인 처리 메소드
    func login(account: String, passwd: String) -> Bool {
        //TODO : 서버와 연동되는 코드도 대체될 예정...
        // 계정값과, 비번값 받아서 true/false 반환
        if account.isEqual("abc@gmail.com") && passwd.isEqual("1234"){
            let ud = UserDefaults.standard
            ud.set(100, forKey: UserInfoKey.loginId)// 로그인값 100 저장
            ud.set(account, forKey: UserInfoKey.account)
            ud.set("해리포터", forKey: UserInfoKey.name)
            ud.synchronize()
            return true
        } else {
            return false
        }
    }

    //로그아웃처리 메소드 // 프로퍼티 리스트안에 있는 내용 모두 삭제
    func logout() -> Bool {
        let ud = UserDefaults.standard
        ud.removeObject(forKey: UserInfoKey.loginId) // 로그인값삭제
        ud.removeObject(forKey: UserInfoKey.account)
        ud.removeObject(forKey: UserInfoKey.name)
        ud.removeObject(forKey: UserInfoKey.profile)
        ud.synchronize()
        return true
    }

    
}

