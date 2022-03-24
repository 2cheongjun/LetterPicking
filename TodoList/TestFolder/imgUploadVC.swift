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
        
        // 갤러리에서 받아온이미지를 업로드 버튼을 눌렀을때 서버로 전송
        upLoadImg(info[.editedImage] as? UIImage)
        
        // print("UIImage :\(info[.editedImage] as? UIImage)")
        
        // 이미지 피커 컨트롤러를 닫는다.
        picker.dismiss(animated: false)
    }
    
    
    
    // 서버로 전송
    @IBAction func uploadBtn(_ sender: Any) {
        
        // 갤러리에서 받아온 UIImage값 받아서 newProfile함수 호출
        
    }
    
    // 서버로 이미지전송로직
    func upLoadImg(_ image: UIImage?) {
        //    func newProfile(_ profile: UIImage?, success: (()->Void)? = nil, fail: ((String)->Void)? = nil) {
        
        // UI이미지를 가져오자마자, 가로200픽셀로 resize
        let image = image?.resized(toWidth: 200.0)
        print("이미지사이즈:\(image!)")
        
        // 랜덤String으로 이미지명 생성
        let str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let size = 5
        let rn = str.createRandomStr(length: size)
        
        // let profileData = image!.jpegData(compressionQuality: 1)! // jpg로하니까 안됬음
        //이미지를 데이터로 변환한뒤에, JSON형태로 전송하기 위해서 base64로 인코딩한다.
        let profileData = image!.pngData()?.base64EncodedString()
        let param: Parameters = [ "image" : profileData ?? "noImg",
                                  "postText" : "내용",
                                  "name": rn
        ]
        
        // API 호출 URL
        let url = "http://3.37.202.166/post/0iOS_cookPostInsert.php"
        
        //이미지 전송
        let call = AF.request(url, method: .post, parameters: param,
                              encoding: JSONEncoding.default)
        //                call.responseJSON { res in
        call.responseJSON { res in
            
            // 성공실패케이스문 작성하기
            print("서버로 보냄!!!!!")
            print("JSON= \(try! res.result.get())!)")
            
            guard let jsonObject = try! res.result.get() as? NSDictionary else {
                print("올바른 응답값이 아닙니다.")
                return
            }
            
            if let jsonObject = try! res.result.get() as? [String :Any]{
                let success = jsonObject["success"] as? Int ?? 0
                
                if success == 1 {
                    self.alert("응답값 JSON= \(try! res.result.get())!)")
                }else{
                    //sucess가 0이면
                    self.alert("응답실패")
                }
            }
        }
    }
}


//랜덤 영어 생성
extension String {
    
    func createRandomStr(length: Int) -> String {
        let str = (0 ..< length).map{ _ in self.randomElement()! }
        return String(str)
    }
    
}

// 이미지 사이즈 줄이기
extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
