//
//  imgUploadVC.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/23.
//

import UIKit
import Alamofire

class imgUploadVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //이미지뷰
    @IBOutlet weak var imgView: UIImageView!
    
    // 이미지피커
    @IBAction func cameraBtn(_ sender: Any) {
        
        // 기본이미지 피커 인스턴스를 생성한다.
        let picker = UIImagePickerController()
        
        picker.delegate = self // 이미지피커컨트롤러 인스턴스의 델리게이트 속성 현재뷰 컨트롤러 인스턴스로설정
        picker.allowsEditing = true // 피커이미지편집 허용
        
        // 이미지피커 화면을 표시한다.
        self.present(picker, animated: true)
    }
    
    // 사용자가 이미지를 선택하면 자동으로 이 메소드가 호출된다.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 선택된이미지를 미리보기에 출력한다.
        self.imgView.image = info[.editedImage] as? UIImage
        
        // 이미지값받아서 서버로 보내기
        newProfile(info[.editedImage] as? UIImage)
        
//        print("UIImage :\(info[.editedImage] as? UIImage)")
        
        // 이미지 피커 컨트롤러를 닫는다.
        picker.dismiss(animated: false)
    }
    
    
    
    // 서버로 전송
    @IBAction func uploadBtn(_ sender: Any) {
      
      
    }
    
    
    func newProfile(_ profile: UIImage?) {
//    func newProfile(_ profile: UIImage?, success: (()->Void)? = nil, fail: ((String)->Void)? = nil) {
        // API 호출 URL
     
        let url = "http://3.37.202.166/post/0iOS_cookPostInsert.php"
        
        // 전송할 프로필 이미지
//        let profileData = profile!.pngData()?.base64EncodedString()
        // 이미지를 데이터로 변환한뒤에, JSON형태로 전송하기 위해서 base64로 인코딩한다.
        let profileData = profile!.pngData()?.base64EncodedString()
        let param: Parameters = [ "image" : profileData! ]
        
        // 이미지 전송
        let call = AF.request(url, method: .post, parameters: param,
                                     encoding: JSONEncoding.default)
        call.responseJSON { res in
            
            print("서버로 보냄!!!!!")
            print("JSON= \(try! res.result.get())!)")
            
            guard let jsonObject = try! res.result.get() as? NSDictionary else {
                print("올바른 응답값이 아닙니다.")
                return
            }
            // 응답 코드 확인. 0이면 성공
//            let resultCode = jsonObject["result_code"] as! Int
//
//            if resultCode == 0 { // if success
////                self.profile = profile // 이미지가 업로드되었다면 UserDefault에 저장된 이미지도 변경한다.
////                success?()
//            } else {
//                let msg = (jsonObject["error_msg"] as? String) ??
//                "이미지 프로필 변경이 실패했습니다."
////                fail?(msg)
//            }
        }
    }

    
    
}
