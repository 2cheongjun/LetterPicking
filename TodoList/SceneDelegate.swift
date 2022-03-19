//
//  SceneDelegate.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/01.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        //루트뷰 컨트롤러를 UITabBarController로 캐스팅한다.
              if let tbC = self.window?.rootViewController as? UITabBarController {
                  
       
                  
                  //탭바에서 탭바 아이템 배열을 가져온다.
                  if let tbItems = tbC.tabBar.items {
                      //탭바 아이템에 커스텀 이미지를 등록한다.
      //                tbItems[0].image = UIImage(named: "calendar")
      //                tbItems[1].image = UIImage(named: "file-tree")
      //                tbItems[2].image = UIImage(named: "photo")
                      
                      // 탭바 아이템에 커스텀 이미지를 등록한다.2
                      // 원본이미지 설정을 위해 UI이미지렌더링을 해주어야함.
                      tbItems[0].image = UIImage(named: "designbump")?.withRenderingMode(.alwaysOriginal)
                      tbItems[1].image = UIImage(named: "rss")?.withRenderingMode(.alwaysOriginal)
                      tbItems[2].image = UIImage(named: "facebook")?.withRenderingMode(.alwaysOriginal)
                      
                      // 탭 바 아이템 전체를 순회하면서 selectedImage 속성에 이미지를 설정한다.
                      // selectedImage는 탭바아이템이 선택되었을때의 이미지이다.
                      for tbItem in tbItems {
                          // 체크가 공통적으로 표시됨
                          let image = UIImage(named:
                                                "checkmark")?.withRenderingMode(.alwaysOriginal)
                          tbItem.selectedImage = image
                      }
                      
                      //탭바 아이템에 타이틀을 설정한다.
                      tbItems[0].title = "calendar"
                      tbItems[1].title = "file"
                      tbItems[2].title = "photo"
                      
                  }
      //            // ⑤ 탭 바 아이템의 이미지 색상을 변경한다.
//                  tbC.tabBar.tintColor = .white // 선택된 탭 바 아이템의 색상
//                  tbC.tabBar.unselectedItemTintColor = .gray // 선택되지 않은 나머지 탭 바 아이템의 색상
//      //
//      //            // ⑥ 탭 바에 배경 이미지를 설정한다.
//                  tbC.tabBar.backgroundImage = UIImage(named:"menubar-bg-mini")
              }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

