//
//  noticeVC.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/28.
//

import UIKit


class HeartVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
//    var numberOfCell: Int = 10
    let cellIdentifier:String = "cell"
    var friends: [Friend] = []
    // 콜렉션뷰 연결
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //델리게이트연결안하면 뷰에 보이지도 않음
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // 제이슨가져오기
        let jsonDecoder: JSONDecoder = JSONDecoder()
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "friends") else {
            return
        }
        
        do{
            self.friends = try jsonDecoder.decode([Friend].self, from: dataAsset.data)
        }catch {
            print(error.localizedDescription)
        }
        self.collectionView?.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.numberOfCell
        return self.friends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FriendCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! FriendCollectionViewCell
        
        let friend: Friend = self.friends[indexPath.item]

        cell.nameAgeLabel.text = friend.nameAndAge
        cell.addressLabel.text = friend.fullAddress
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        // 컬랙션뷰의 데이터를 먼저 삭제 해주고, 데이터 배열의 값을 삭제해줍니다!! , '반대로할시에 데이터가 꼬이는 현상이 발생합니다.'
//        self.numberOfCell += 1
        // 선택한 번호에 해당하는 셀지우기 어떻게????
        print(indexPath.row)

        // 섹삭제
        if let selectedCells = collectionView.indexPathsForSelectedItems {
            // 1
            let items = selectedCells.map { $0.item }.sorted().reversed()
            // 2
            for item in items {
                friends.remove(at: item)
            }
            // 3
            collectionView.deleteItems(at: selectedCells)
            collectionView.reloadData()
        }
    }

}


