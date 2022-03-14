//
//  ViewController.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/01.
//

import UIKit
import CoreData

// 우선순위 레벨설정을위한 타입
enum PriorityLevel : Int64 {
    case level1
    case level2
    case level3
}

// 우선순위 레벨에 따른 컬러값 설정
extension PriorityLevel {
    var color: UIColor {
        switch self {
        case.level1:
            return .green
        case.level2:
            return .orange
        case.level3:
            return .red
        }
    }
}

class ViewController: UIViewController {
    // 테이블뷰 연결
    @IBOutlet weak var todoTableView: UITableView!
    
    // 앱델리게이트 접근
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    // 코어데이터에 저장되어있는 값
    var todoList = [TodoList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.네비바 타이틀 및 설정내용을 실행한다.
        self.title = "To Do List"
        // 네비바 설정실행
        self.makeNavigationBar()
        
        todoTableView.delegate = self
        todoTableView.dataSource = self
        
        // 코어데이터불러오기
        fetchData()
        // 다시 리로드하기
        todoTableView.reloadData()
    }
    
    // 네비바 설정
    func makeNavigationBar(){
        //바버튼 아이템생성, 눌렀을때 addNewTodo()실행
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTodo))
        
        // 네비바 타이틀컬러
        item.tintColor = .black
        // 오른쪽에 부착
        navigationItem.rightBarButtonItem = item
        
        // 컬러설정안됨 ???????스크롤해야 보임?????
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .brown
        self.navigationController?.navigationBar
            .standardAppearance = barAppearance
    }
    
    // 앱델리게이트에 있는 코어데이터 불러오기
    func fetchData(){
        let fetchRequest : NSFetchRequest<TodoList> = TodoList.fetchRequest()
        let context = appdelegate.persistentContainer.viewContext
        
        do {
            self.todoList = try context.fetch(fetchRequest)
            
        }catch {
            print(error)
        }
    }
    
    
    // 상세 + 로 DetailViewController 띄우기
    @objc func addNewTodo(){
        let detailVC = TodoDetailViewController.init(nibName: "TodoDetailViewController", bundle: nil)
        //델리게이트 연결
        detailVC.delegate = self
        self.present(detailVC, animated: true, completion: nil)
    }

}

// todolist에 있는 값 가져와서 테이블뷰에 표기하기
extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
        
        cell.topTitleLabel.text = todoList[indexPath.row].title
        
        if let hasDate = todoList[indexPath.row].date {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd hh:mm:ss"
            
            let dateString = formatter.string(from: hasDate)
            cell.dateLabel.text = dateString
        }else{
            cell.dateLabel.text = ""
        }
        
        // 선택했을때 컬러변경
        let priority = todoList[indexPath.row].priorityLevel //TodoList에 저장된 우선순위값
        let priorityColor = PriorityLevel(rawValue: priority)?.color
         
        cell.levelView.backgroundColor = priorityColor
        //동그라미 형태로 만들기
        cell.levelView.layer.cornerRadius = cell.levelView.bounds.height/2
        return cell
    }
    
    // 셀클릭!!!!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = TodoDetailViewController.init(nibName: "TodoDetailViewController", bundle: nil)
        //델리게이트 연결
        detailVC.delegate = self
        detailVC.selectedTodoList = todoList[indexPath.row]
        self.present(detailVC, animated: true, completion: nil)
    }
}

// 디테일 컨트롤러뷰랑 연결된 프로토콜 구현부
extension ViewController: TodoDetailViewControllerDelegate {
    func didFinishSaveData() {
        // 저장한것 불러온뒤에
        self.fetchData()
        //테이블뷰 리로드하기
        self.todoTableView.reloadData()
    }
}
