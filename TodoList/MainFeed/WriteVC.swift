//
//  WriteVC.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/22.
//

import UIKit
import BSImagePicker
import Photos
import Alamofire


class WriteVC : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate{
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!//콜렉션뷰
    //    var list = ["1", "2", "3", "4" ,"5", "6", "7", "8", "9", "10"]
    //    var numberOfCell: Int = 10
    
    // 갤러리에서 선택해 가져온 이미지의 원래형태인것같음..
    var selectedAssets = [PHAsset]()
    // 이미지들 담은 배열
    var photoArray = [UIImage]()
    
    // UI이미지 담을 변수(갤러리에서 가져온이미지)***************
    var newImages: UIImage? = nil
    var text = ""
    
    var isSelected = false
    
    override func viewDidLoad() {
        //컬렉션뷰 델리게이트
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // 텍스트뷰 테두리
        self.textView.layer.borderWidth = 1.0
        self.textView.layer.borderColor = UIColor.systemGray4.cgColor
        self.textView.layer.cornerRadius = 4
    }
    
    //취소버튼
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) /// 화면을 누르면 키보드 내려가게 하는 것
    }
    
    
    // 이미지다중선택을 위한 BSImagePicker 라이브러리사용
    @IBAction func pick(_ sender: Any) {
        
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 10
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image, .video]
        imagePicker.settings.selection.unselectOnReachingMax = true
        
        presentImagePicker(imagePicker, select: {
            (asset) in
            // 사진 하나 선택할 때마다 실행되는 내용 쓰기
        }, deselect: {
            (asset) in
            // 선택했던 사진들 중 하나를 선택 해제할 때마다 실행되는 내용 쓰기
        }, cancel: {
            (assets) in
            // Cancel 버튼 누르면 실행되는 내용
        }, finish: {
            (assets) in
            // Done 버튼 누르면 실행되는 내용
            
            self.selectedAssets.removeAll()
            
            for i in assets {
                self.selectedAssets.append(i)
            }
            
            self.convertAssetToImage()
            self.collectionView.reloadData()
        })
        
    }
    
    // 이미지다중선택을 위한 BSImagePicker 라이브러리사용
    // PHAsset Type 이었던 사진을 UIImage Type 으로 변환하는 함수
    func convertAssetToImage() {
        if selectedAssets.count != 0 {
            for i in 0 ..< selectedAssets.count {
                let imageManager = PHImageManager.default()
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                var thumbnail = UIImage()
                imageManager.requestImage(for: selectedAssets[i], targetSize: CGSize(width: selectedAssets[i].pixelWidth, height: selectedAssets[i].pixelHeight), contentMode: .aspectFill, options: option) {
                    (result, info) in
                    thumbnail = result!
                }
                
                let data = thumbnail.jpegData(compressionQuality: 0.7)
                let newImage = UIImage(data: data!)
                self.photoArray.append(newImage! as UIImage)
            }
        }
    }
    
    
    // 업로드
    // 공유버튼을 누를때 텍스트값 + 이미지값을 가져와서 서버로 업로드한다.
    // 창닫기
    @IBAction func uploadBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "게시물 공유", message: "업로드 하시겠습니까?", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "업로드", style: .default) { [self] (_) in
            //  여기에 실행할 코드
            // 갤러리에서 받아온 UIImage값 받아서 newProfile함수 호출
            if let getImage = self.newImages{
                self.upLoadImg(getImage) //받아온이미지들
                
//                let postText = textView.text
                
//                print("작성내용 \(postText)")
            }
        }
        alert.addAction(alertAction)
        
        // 왜인지 취소글자가 더두꺼워보임???
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancel)
        //                alert.view.tintColor =  UIColor(ciColor: .black)
        self.present(alert, animated: true, completion: nil)
    }
}



// cell data
extension WriteVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // 셀갯수반환
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CVcell
        
        //        cell.backgroundColor = .lightGray
        //        cell.label.text = list[indexPath.row]
        //        cell.label.backgroundColor = .yellow
        
        // 이미지 여러장 꺼내오기
        if let hasImg = UIImage?(photoArray[indexPath.row]){
            // 각쎌에 이미지 넣기
            cell.imgView.image = hasImg
            
            newImages = hasImg
            
            print(hasImg)
        }
        
        
        // 꺼내온 이미지 여러장 서버로 전송하기 ****************************************
        //        upLoadImg(UIImage?(photoArray[indexPath.row]))
        
        return cell
    }
    
    // 셀선택시 각아이템 삭제 **********************************************************************************************
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        // 컬랙션뷰의 데이터를 먼저 삭제 해주고, 데이터 배열의 값을 삭제해줍니다!! , '반대로할시에 데이터가 꼬이는 현상이 발생합니다.'
        // self.numberOfCell += 1
        // collectionView.reloadData()
        
        // 각 아이템 클릭시 삭제됨  // deleteItem(_:)
        if let selectedCells = collectionView.indexPathsForSelectedItems {
            // 1
            let items = selectedCells.map { $0.item }.sorted().reversed()
            // 2
            for item in items {
                photoArray.remove(at: item)
            }
            // 3
            collectionView.deleteItems(at: selectedCells)
            collectionView.reloadData()
        }
        
    }
    
    /*
     // 이미지 여러장 서버업로드 *************************************************************************************
     */
    func upLoadImg(_ imageData: UIImage?) {
          //    func newProfile(_ profile: UIImage?, success: (()->Void)? = nil, fail: ((String)->Void)? = nil) {
        
        // UI이미지를 가져오자마자, 가로200픽셀로 resize
//        let image = imageData?.resized(toWidth: 200.0)
//        print("이미지사이즈:\(image!)")
        
        // 이미지전송
          var imageStr: [String] = []

          //userID, postText어떻게 담아????? //가져온 사진의 갯수만큼,jpgData로 바꾼뒤에 imageData에 담는다.
          for a in 0..<self.photoArray.count {
              let resultImage: Data = self.photoArray[a].jpegData(compressionQuality: 0.1)!
              //이미지를 데이터로 변환한뒤에, JSON형태로 전송하기 위해서 base64로 인코딩한다.
              imageStr.append(resultImage.base64EncodedString())
          }
        
        // 랜덤String으로 이미지명 생성
        let str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let size = 5
        let imgName = str.createRandomStr(length: size)
        
        // let profileData = image!.jpegData(compressionQuality: 1)! // jpg로하니까 안됬음
        //이미지를 데이터로 변환한뒤에, JSON형태로 전송하기 위해서 base64로 인코딩한다.
//        let profileData = image!.pngData()?.base64EncodedString()
        let param: Parameters = [ "imageStr" :  imageStr,
                                  "postText" : textView.text ?? "",
                                  "name": imgName,
                                  "userID" : "hoho"
        ]
        
        // API 호출 URL
        let url = "http://3.37.202.166/post/0iOS_images.php"
        
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
//                    self.alert("응답값 JSON= \(try! res.result.get())!)")
                    self.dismiss(animated: true, completion: nil)
                }else{
                    //sucess가 0이면
                    self.alert("응답실패")
                }
            }
        }
    }//함수 끝
      
}


// cell layout
extension WriteVC: UICollectionViewDelegateFlowLayout {
    
    // 위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // cell 사이즈( 옆 라인을 고려하여 설정 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 4 - 1 ///  3등분하여 배치, 옆 간격이 1이므로 1을 빼줌
        print("collectionView width=\(collectionView.frame.width)")
        print("cell하나당 width=\(width)")
        print("root view width = \(self.view.frame.width)")
        
        let size = CGSize(width: width, height: width)
        return size
    }
    
}


