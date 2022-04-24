//
//  nMapVC.swift
//  TodoList
//
//  Created by 이청준 on 2022/04/01.
//

import UIKit
import Alamofire
import SwiftyJSON
import NMapsMap

class nMapVC : UIViewController {
    
    let NAVER_CLIENT_ID = "uvryr3s84w"
    let NAVER_CLIENT_SECRET = "rSXrAAZE5FUNue2BEbh68p6LAFiNDE2wUVdpI9JV"
    let NAVER_GEOCODE_URL = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query="
    var BASEURL = "http://15.164.214.35/"
    // 네이버지도 파싱 // 코더블 모델
    var model: MapModel?
    
    // 피드 모델가져오기
    var feedModel: FeedModel?
    
    
//    struct MapModel: Codable{
//        let addresses:[AddressResult]
//    }
//    struct AddressResult:Codable{
//        let x: String
//        let y: String
//    }
    
    // UIView 맵 // 네이버 지도뷰 만들고 클래스 설정함.
    @IBOutlet var mapView: NMFMapView!
    
    // 주소입력하면 위도경도 가져와 지도에 표기 + 마커
    var place = ""
//    let place = "관악구 조원동"// 구동 순서 바꾸면 null값뜸
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        //서버에 업로드된 마지막 이미지 장소 가져옴  // 맵요청(안에 카메라위치 함수, 마커함수실행)
        requestFeedAPI()
        //위도경도값 요청
//        mapRequest()
        
        // 코드로 지도추가하는 방법
        // let naverMapView = NMFNaverMapView(frame: view.frame)
        // view.addSubview(naverMapView)
        
        // 현재 위치 얻기
        let cameraPosition = mapView.cameraPosition
        print(cameraPosition)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestFeedAPI()
    }
    
    // 입력한 주소값의 위도경도값 알아오기 ***** 네이버API
    func mapRequest(){
        let encodeAddress = place.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let header1 = HTTPHeader(name: "X-NCP-APIGW-API-KEY-ID", value: NAVER_CLIENT_ID)
        let header2 = HTTPHeader(name: "X-NCP-APIGW-API-KEY", value: NAVER_CLIENT_SECRET)
        let headers = HTTPHeaders([header1,header2])
        
        AF.request(NAVER_GEOCODE_URL + encodeAddress, method: .get,headers: headers).validate()
            .responseJSON { response in
                
                switch response.result {
                    
                case .success(let value as [String:Any]):
                    let json = JSON(value)
//                    print(json)
//                    let data = json["addresses"]
//                    let lat = data[0]["y"]
//                    let lon = data[0]["x"]
//                    print("place","위도는",lat,"경도는",lon)
                    
                    do{
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        
//                         print("데이타\(data)")
                        // 제이슨데이터 가져와서 디코딩해 파싱하기
                        let mapModels = try JSONDecoder().decode(MapModel.self, from: data)
//                        print("mapModels/ 위도 \(mapModels.addresses[0].x)")
//                        print("mapModels/ 경도 \(mapModels.addresses[0].y)")
                        
                        // 카메라 함수에 넣기위해 더블형태로 바꾸기 // 이거 영문일때,,앱 죽음...처리?// 구 동바꾸면 뻑남..
                        let lat = Double(mapModels.addresses[0].y) ?? 37.4702453
                        let lon = Double(mapModels.addresses[0].x) ?? 126.897041
                        print(lat,lon)
                        
                        // 가져온 위도 경도값을 카메라 세팅에 대입한다.
                        self.setCamera(lat,lon)
                        self.setMarker(lat,lon)
                        
                    }catch{
                        print(error)
                    }
                    
                case .failure(let error):
                    print(error.errorDescription ?? "")
                default :
                    fatalError()
                }
            }
    }
    

    // 지도 카메라 세팅
    func setCamera(_ lat: Double,_ lon: Double) {
        print("카메라 위치")
        let camPosition =  NMGLatLng(lat: lat, lng: lon)
        let cameraUpdate = NMFCameraUpdate(scrollTo: camPosition)
        mapView.moveCamera(cameraUpdate)
    }
    
    // 마커설정
    func setMarker(_ lat: Double,_ lon: Double) {
        print("마커설정")
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: lat, lng: lon)
        marker.iconImage = NMF_MARKER_IMAGE_BLACK
        marker.iconTintColor = UIColor.red
        marker.width = 50
        marker.height = 60
        marker.mapView = mapView
        
        // 정보창 생성
        let infoWindow = NMFInfoWindow()
        let dataSource = NMFInfoWindowDefaultTextSource.data()
        //        dataSource.title = "서울특별시청"
        dataSource.title = place
        infoWindow.dataSource = dataSource
        
        // 마커에 달아주기
        infoWindow.open(with: marker)
        
    }
    
    // network /URL세션으로 호출 // 마지막 장소표기를 위해서 서버호출함..
    func requestFeedAPI(){
        print("API호출")
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let components = URLComponents(string: BASEURL+"post/0iOS_feedSelect.php?page=\(1)")
        
        // url이 없으면 리턴한다. 여기서 끝
        guard let url = components?.url else { return }
        
        // 값이 있다면 받아와서 넣음.
        var request = URLRequest(url: url)
        request.httpMethod = "GET" //GET방식이다. 컨텐츠타입이 없고, 담아서 보내는 내용이 없음, URL호출만!
        
        let task = session.dataTask(with: request) { data, response, error in
            print( (response as! HTTPURLResponse).statusCode )
            
            // 데이터가 있을때만 파싱한다.
            if let hasData = data {
                // 모델만든것 가져다가 디코더해준다.
                do{
                    // 만들어놓은 피드모델에 담음, 데이터를 디코딩해서, 디코딩은 try catch문 써줘야함
                    // 여기서 실행을 하고 오류가 나면 catch로 던져서 프린트해주겠다.
                    self.feedModel = try JSONDecoder().decode(FeedModel.self, from: hasData)
//                    print(self.feedModel ?? "no data")
                    
//                    print("mapModels/ 위도 \(self.feedModel?.results[0].myPlaceText)")
                    if let lastplace = self.feedModel?.results[0].myPlaceText {
                        print("마지막 사진업로드 장소값:\(lastplace)")
              
                        self.place = lastplace
                        self.mapRequest()
                        
                    }else{
                        self.place = "서울시 서초구"
                        self.mapRequest()
                    }
                 
                }catch{
                    print(error)
                }
            }
        }
        // task를 실행한다.
        task.resume()
        // 세션끝내기
        session.finishTasksAndInvalidate()
        
    }// 호출메소드끝
    
    
}

