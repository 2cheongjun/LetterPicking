//
//  TodoDetailViewController.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/01.
//

import UIKit
import CoreData

// 프로토콜 선언부
protocol TodoDetailViewControllerDelegate: AnyObject{
    // 구현은 연결된 델리게이트 뷰컨트롤러에
    func didFinishSaveData()
}

class TodoDetailViewController: UIViewController {
    // 델리게이트 선언
    weak var delegate: TodoDetailViewControllerDelegate?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var lowButton: UIButton!
    @IBOutlet weak var normalButton: UIButton!
    @IBOutlet weak var hignButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    //앱델리게이트안에 있는 코어데이터 엔티티에 저장하기
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //눌렀을때 값 처리
    var selectedTodoList: TodoList?
    
    // 우선순위값
    var priority: PriorityLevel? // 뷰컨에 정의해놓은 값
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //화면이 나타나기 시작할때 // 목록 눌러서 가져온값 // 데이터가 있는지 없느지 체크한다.
    override func viewWillAppear(_ animated: Bool) {
        if let hasData = selectedTodoList{
            titleTextField.text = hasData.title // 타이틀 가져오기
            
            priority = PriorityLevel(rawValue: hasData.priorityLevel)
            //우선순위이미지값가져오기
            // 버튼 디자인
            makePriorityButtonDesign()
            //데이터가 있으면, 삭제버튼 보이게
            deleteButton.isHidden = false
            saveButton.setTitle("update", for: .normal)
        }else{
            //데이터가 없으면, 삭제버튼 안보이게
            deleteButton.isHidden = true
            saveButton.setTitle("save", for: .normal)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // 중요도 액션
    @IBAction func setPriority(_ sender: UIButton) {
        //버튼클릭시에
        switch sender.tag {
        case 1:
            priority = .level1
        case 2:
            priority = .level2
        case 3:
            priority = .level3
        default:
            break
        }
        makePriorityButtonDesign()
    }
    
    // 우선순위 디자인 설정
    func makePriorityButtonDesign(){
        lowButton.backgroundColor = .clear
        normalButton.backgroundColor = .clear
        hignButton.backgroundColor = .clear
        
        switch self.priority {
        case .level1:
            lowButton.backgroundColor = priority?.color
        case .level2:
            normalButton.backgroundColor = priority?.color
        case .level3:
            hignButton.backgroundColor = priority?.color
        default:
            break
        }
    }
    
    //저장 액션
    @IBAction func saveTodo(_ sender: Any) {
        
        if selectedTodoList != nil {
            updateTodo()
        }else {
            saveTodo()
        }
        
        // 프로토콜함수 호출
        delegate?.didFinishSaveData()
        // 화면닫기
        self.dismiss(animated: true, completion: nil)
    }
    
    // 저장하기******
    func saveTodo(){
        //todolist엔티티를 가져오기
        guard let entityDescription = NSEntityDescription.entity(forEntityName:
                                                                    "TodoList", in: context) else { return }
        //엔티티내용 가져오기
        guard let object = NSManagedObject(entity: entityDescription,
                                           insertInto: context) as? TodoList else {
            return
        }
        
        object.title = titleTextField.text  // 텍스트필드에서 가져온값 넣기
        object.date = Date() // 지금시간값 넣기
        object.uuid = UUID() // 유니크한ID 생성해넣기
        // 우선순위 컬러값 설정(Int로 구분해 넣기)
        object.priorityLevel = priority?.rawValue ?? PriorityLevel.level1.rawValue
        
        // 앱델리게이트 저장메소드호출
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.saveContext()
    }
    
    
    //수정하기 **********************************************************
    func updateTodo(){
        // 선택한 데이터가 있으면 실행 없으면 실행 X
        guard let hasData = selectedTodoList else {
            return
        }
        //uuid 가져오기 없으면 그 이후 코드 실행 X
        guard let hasUUID = hasData.uuid else {
            return
        }
        
        //선택한것만 가져오기
        let fetchRequest: NSFetchRequest<TodoList> = TodoList.fetchRequest()
        
        // 저장된 uuid만 가져오겠다. CvarArg가 uuid의 타입
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", hasUUID as CVarArg)
        
        do{
            let loadedData = try context.fetch(fetchRequest)
            // 로드데이터의 첫번째 값
            loadedData.first?.title = titleTextField.text
            loadedData.first?.date = Date() // 시간값새로생성
            // 저장된값이 있으면 그값을 사용하고, 없으면 레벨1로 출력한다.
            loadedData.first?.priorityLevel = self.priority?.rawValue ?? PriorityLevel.level1.rawValue
            
            //저장호출
            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
            // 저장한다.
            appDelegate.saveContext()
            // 프로토콜함수 호출 (테이블 리로드함수)
            delegate?.didFinishSaveData()
            
        }catch{
            print(error)
        }
    }
    
    //삭제하기
    @IBAction func deleteTodo(_ sender:UIButton){
        // 선택한 데이터가 있으면 실행 없으면 실행 X
        guard let hasData = selectedTodoList else {
            return
        }
        //uuid 가져오기 없으면 그 이후 코드 실행 X
        guard let hasUUID = hasData.uuid else {
            return
        }
        
        let fetchRequest: NSFetchRequest<TodoList> = TodoList.fetchRequest()
        //선택한것만 가져오기
        
        // 저장된 uuid
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", hasUUID as CVarArg)
        
        do{
            let loadedData = try context.fetch(fetchRequest)
            // 첫번째 데이터 삭제하기
            if let loadFirstData = loadedData.first{ context.delete(loadFirstData)
                
                // 저장호출
                let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                appDelegate.saveContext()
            }
            
        }catch {
            print(error)
        }
        // 프로토콜함수 호출( 테이블 리로드)
        delegate?.didFinishSaveData()
        // 화면닫기
        self.dismiss(animated: true, completion: nil)
    }
    
}
