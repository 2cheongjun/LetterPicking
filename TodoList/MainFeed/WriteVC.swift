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
import CoreLocation

// 글작성화면 VC
class WriteVC : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate{
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!//콜렉션뷰
    //    var list = ["1", "2", "3", "4" ,"5", "6", "7", "8", "9", "10"]
    //    var numberOfCell: Int = 10
    
    @IBOutlet var placeText: UIButton! // 위치추가
    @IBOutlet var myPlaceText: UILabel! // 내위치표시
    var locationManager : CLLocationManager! // 로케이션매니저
    
    // 갤러리에서 선택해 가져온 이미지의 원래형태인것같음..
    var selectedAssets = [PHAsset]()
    // 이미지들 담은 배열
    var photoArray = [UIImage]()
    
    // UI이미지 담을 변수(갤러리에서 가져온이미지)***************
    var newImages: UIImage? = nil
    var text = "" // 작성글
    var add = "" // 직접작성주소
    var autoAddress = "" // 자동위치
    
    var isSelected = false
    
    /*
     *  userDefaults에 저장된이름값 가져오기
     */
    let plist = UserDefaults.standard
    
    
    override func viewDidLoad() {
        //컬렉션뷰 델리게이트
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // 텍스트뷰 테두리
        self.textView.layer.borderWidth = 1.0
        self.textView.layer.borderColor = UIColor.systemGray4.cgColor
        self.textView.layer.cornerRadius = 4
        
        //지도설정
        // locationManager 인스턴스를 생성
        locationManager = CLLocationManager()
        // 앱을 사용할 때만 위치 정보를 허용할 경우 호출
        locationManager.requestWhenInUseAuthorization()
        // 위치 정보 제공의 정확도를 설정할 수 있다.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 정보를 지속적으로 받고 싶은 경우 이벤트를 시작
        locationManager.startUpdatingLocation()
        // 기존에 생성했던 CLLocationManager 인스턴스에 delegate 지정
        locationManager.delegate = self
        
//        // 네비게이션바 숨김처리
//        self.navigationController?.navigationBar.isHidden = false
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
                self.upLoadImg(getImage) // 받아온이미지들 넣어서 upLoadImg실행
            }
        }
        alert.addAction(alertAction)
        
        // 왜인지 취소글자가 더두꺼워보임???
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancel)
        //                alert.view.tintColor =  UIColor(ciColor: .black)
        self.present(alert, animated: true, completion: nil)
    }
    
    // 위치추가액션 (현재위치 가져와 보여주기)
    @IBAction func placeBtn(_ sender: Any) {
        
        // 얼럿을 띄우고 입력을 받아서, placeText에 넣기
        let alert = UIAlertController(title: "위치 직접입력 ", message:"시/구/동을 입력하세요.(한국)", preferredStyle: .alert)
                
        alert.addTextField{ (myTextField) in
//            myTextField.textColor = UIColor.cyan
            myTextField.placeholder = "ex)흥덕구 복대동"
        }
        
               let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
                    //code // 내위치정보 받아다가 넣기
                   self.myPlaceText.text = alert.textFields?[0].text
//                   print("WriteVC/직접입력받은 주소: \(self.myPlaceText.text)")
                   
                   if let add = self.myPlaceText.text{
                       print("작정한주소 :\(add) ")
                   }else{
                     
                   }
                  
               }
               let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in
                    //code
               }
               alert.addAction(cancel)
               alert.addAction(ok)
               self.present(alert, animated: true, completion: nil)
    }
    
}// VC끝




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
    func upLoadImg(_ imageData: UIImage?, success: (()->Void)? = nil, fail: ((String)->Void)? = nil) {
        
        // 이미지들을 담을 배열생성
        var imageStr: [String] = []
        
        //가져온 사진의 갯수만큼,jpgData로 바꾼뒤에 imageData에 담는다.
        for a in 0..<self.photoArray.count {
            let resultImage: Data = self.photoArray[a].jpegData(compressionQuality: 0.1)!
            //이미지를 데이터로 변환한뒤에, JSON형태로 전송하기 위해서 base64로 인코딩한다.
            imageStr.append(resultImage.base64EncodedString())
        }
        
        // userID, postText,이미지묶음을 파라미터에 담아보냄
        let userID = plist.string(forKey: "name")
        
        let param: Parameters = [ "imageStr" :  imageStr,
                                  "postText" : textView.text ?? "",
                                  "userID" : userID as Any,
//                                  "myPlaceText": add
                                  "myPlaceText": myPlaceText.text ?? ""
        ]
        
        print("WriteVC/ 기본입력내용 :\(self.myPlaceText.text ?? "")")
        
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
            
            guard (try! res.result.get() as? NSDictionary) != nil else {
                print("올바른 응답값이 아닙니다.")
                return
            }
            
            if let jsonObject = try! res.result.get() as? [String :Any]{
                let success = jsonObject["success"] as? Int ?? 0
                
                if success == 1 {
                    self.alert("응답값 JSON= \(try! res.result.get())!)")
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


// locations에 사용자의 위치 정보가 들어옴. 위도, 경도
extension WriteVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            //            print(coordinate.latitude)
            //            print(coordinate.longitude)
            // 현재 나의 위치 위도 경도 받아옴
            let latitude : Double = coordinate.latitude
            let longitude : Double = coordinate.longitude
            
            //latitude: 위도, 도: 경도
            let findLocation = CLLocation(latitude: latitude, longitude: longitude)
            // 화면상에 경도/위도값을 가지고 네트워크 연결을 하여, placemark를 뽑아주는 기능!! 지오코딩
            let geocoder = CLGeocoder()
            let locale = Locale(identifier: "Ko-kr") //원하는 나라 코드
            geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
                if let address: [CLPlacemark] = placemarks {
                    DispatchQueue.main.async {
                        
                        if let locality: String = address.last?.locality {
                            // 장소 표시와 연결된 도시 (예) 수원시
                            self.myPlaceText.text = locality
                        }  //추가 도시 수준 정보 (예) 동작구
                        if let subLocality: String = address.last?.subLocality{
                            self.myPlaceText.text?.append(" " + subLocality)
                            
//                            if let autoAddress =  self.myPlaceText.text?.append(" " + subLocality){
//                                print("자동입력주소 : \(autoAddress)")
//                            }
                        }
                        
                    }
                }
            })
        }
    }
}
