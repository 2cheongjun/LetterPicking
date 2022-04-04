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
    
    // UIView 맵
    
    @IBOutlet var mapView: NMFMapView!
    // 코더블 모델
    var mapModel: MapModel?
    
    //위도와 경도
      var latitude: Double?
      var longitude: Double?
    
    // 주소입력하면
    //    let place = "금천구 독산3동"
    let place = "금천구 독산3동"// 구동 순서 바꾸면 null값뜸
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapRequest() //위도경도값 요청
        
        // 코드로 지도추가하는 방법
        //        let naverMapView = NMFNaverMapView(frame: view.frame)
        //        view.addSubview(naverMapView)
        
        // 현재 위치 얻기
        let cameraPosition = mapView.cameraPosition
        print(cameraPosition)
        
        //        setCamera() // 카메라 설정
        //        setMarker() // 마커띄우기
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapRequest()
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
                               let data = json["addresses"]
                               let lat = data[0]["y"]
                               let lon = data[0]["x"]
                               print("홍대입구역의","위도는",lat,"경도는",lon)
                    
                              self.setCamera(lat.rawValue , lon)
                    
                case .failure(let error):
                    print(error.errorDescription ?? "")
                default :
                    fatalError()
                }
            }
    }
    
    // 지도 카메라 세팅
//        func setCamera() {
//           let camPosition =  NMGLatLng(lat: 37.4751198, lng: 126.9032524)
//           let cameraUpdate = NMFCameraUpdate(scrollTo: camPosition)
//           mapView.moveCamera(cameraUpdate)
//       }
    
    // 지도 카메라 세팅
    func setCamera(_ lat: Double,_ lon: Double) {
        let camPosition =  NMGLatLng(lat: lat, lng: lon)
        let cameraUpdate = NMFCameraUpdate(scrollTo: camPosition)
        mapView.moveCamera(cameraUpdate)
    }
    
    // 마커설정
    func setMarker() {
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat:  37.4751198, lng: 126.9032524)
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
    
    
    
    
}

