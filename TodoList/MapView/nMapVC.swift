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
    
    
    // 코더블 모델
    var model: MapModel?
    
    struct MapModel: Codable{
        let addresses:[AddressResult]
    }
    struct AddressResult:Codable{
        let x: String
        let y: String
    }
    
    // UIView 맵
    @IBOutlet var mapView: NMFMapView!
    
    // 주소입력하면
    let place = "금천구 독산동"
//    let place = "관악구 조원동"// 구동 순서 바꾸면 null값뜸
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapRequest() //위도경도값 요청
        
        // 코드로 지도추가하는 방법
        // let naverMapView = NMFNaverMapView(frame: view.frame)
        // view.addSubview(naverMapView)
        
        // 현재 위치 얻기
        let cameraPosition = mapView.cameraPosition
        print(cameraPosition)
        
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
                    print(json)
//                    let data = json["addresses"]
//                    let lat = data[0]["y"]
//                    let lon = data[0]["x"]
//                    print("place","위도는",lat,"경도는",lon)
                    
                    do{
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        
//                         print("데이타\(data)")
                        let mapModels = try JSONDecoder().decode(MapModel.self, from: data)
                        print("mapModels/ 위도 \(mapModels.addresses[0].x)")
                        print("mapModels/ 경도 \(mapModels.addresses[0].y)")
                        
                        // 더블형태로 바꾸기
                        let lat = Double(mapModels.addresses[0].y)!
                        let lon = Double(mapModels.addresses[0].x)!
                        print(lat,lon)
                        
                        // 가져온 위도 경도값을 카메라 세팅에 대입한다.
                        // self.setCamera(lat.double , lon.double)
//                        print("place","위도는",mapModels.y,"경도는",mapModels.x)
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
    
    
    
    
}

