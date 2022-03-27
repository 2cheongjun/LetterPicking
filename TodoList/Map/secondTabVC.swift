//
//  secondTabVC.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/19.
//

import UIKit

class secondTabVC : UIViewController, MTMapViewDelegate {
    //지도map
    var mapView: MTMapView?
    
    override func viewDidLoad() {
        // 상단 백버튼가림
        self.navigationController?.navigationBar.isHidden = true
        
        // 지도 맵뷰시작
        mapView = MTMapView(frame: self.view.bounds)
        if let mapView = mapView {
            mapView.delegate = self
            mapView.baseMapType = .standard
            self.view.addSubview(mapView)
        }
    }
        
        // 애니메이션설정
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            let tabBar = self.tabBarController?.tabBar
            //        tabBar?.isHidden = (tabBar?.isHidden == true) ? false : true
            UIView.animate(withDuration: TimeInterval(0.15),animations:{
                //알파값이 0이면 1로, 1이면 0으로 바꿔준다.
                //호출될때마다 점점 투명해졌다가 점점 진해질 것이다.
                //                              (참거짓조건)? 참일때의값 : 거짓일때의 값
                tabBar?.alpha = (tabBar?.alpha == 0 ? 1 : 0)
            })
        }
        
    }

