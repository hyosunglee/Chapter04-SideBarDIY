//
//  FrontViewController.swift
//
//  Created by prologue on 2017. 6. 8..
//  Copyright © 2017년 rubypaper. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

struct Lecture: Codable {
    var id: Int
    var author: String
    var nickname: String
}

class FrontViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  // 사이드 바 오픈 기능을 위임할 델리게이트
  var delegate: RevealViewController?
    
    func naming(completion: @escaping ([(String, String)]) -> Void) {


                // 시간이 오래 걸리는 작업
                // 작업이 완료
    //        let BaseURL = URL(string: "https://json-mock-server.herokuapp.com/posts")!
            let BaseURL = URL(string: "http://cccvlm.com/111pray/list.php")!
                // let BaseURL = "http://cccvlm.com/111pray/list.php"
                // https://github.com/Alamofire/Alamofire


            AF.request(BaseURL)
                    .responseJSON(completionHandler: { response in
                        // Enummeration Associated Value

                         print("IN ALAMOFIRE")

                        print(response)
                        switch response.result {

                        case .success(let data):
                            if let d = data as? [[String: Any]] {

                                // print(d)
                                // [[String: Any]] 타입에서 원하는 데이터를 추출하여 [String] 으로 매핑하는 과정
                                // Array 타입의 내장함수 map(), filter(), reduce() 확인
                                let result:[(String, String)] = d.map {
                                    element in
                                    if let author = element["text"] as? String,
                                        let nickname = element["name"] as? String {
                                        return (author, nickname)
                                    } else {
                                        return ("", "")
                                    }
                                }
                                completion(result)
                                //print(result)
                                                     }
                            break
                        case .failure:
        //                    print(error)
                            break
                        }
                    })
            print("API AFTER")

            }
    
    var author:[String] = ["1","2","3","4Z"]
    
    var nickname:[String] = []
    
    
     
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return author.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PrayCell = tableView.dequeueReusableCell(withIdentifier: "PrayCell", for: indexPath) as! PrayCell
        cell.nickNameLabel?.text = nickname[indexPath.row]
        cell.detailLabel?.text = author[indexPath.row]
        return cell
    }
    
   
    
    
    @IBOutlet weak var tableView: UITableView!
    
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
    
    
    // 사이드 바 오픈용 버튼 정의
    let btnSideBar = UIBarButtonItem(image: UIImage(named: "sidemenu.png"),
                                     style: UIBarButtonItem.Style.plain,
                                     target: self,
                                     action: #selector(moveSide) )
    // 버튼을 내비게이션 바의 왼쪽 영역에 추가
    self.navigationItem.leftBarButtonItem = btnSideBar
    
    // 화면 끝에서 다른 쪽으로 패닝하는 제스처를 정의
    let dragLeft = UIScreenEdgePanGestureRecognizer(
      target: self,
      action: #selector(moveSide(_:)))
    dragLeft.edges = UIRectEdge.left // 시작 모서리는 왼쪽
    self.view.addGestureRecognizer(dragLeft) // 뷰에 제스처 객체를 등록
    
    // 화면을 스와이프하는 제스처를 정의(사이드 메뉴 닫기용)
    let dragRight = UISwipeGestureRecognizer( target: self, action: #selector(moveSide))
    dragRight.direction = .left // 방향은 왼쪽
    self.view.addGestureRecognizer(dragRight) // 뷰에 제스처 객체를 등록
    
    
    self.naming() { source in
        self.author = source.map { $0.0 }
        self.nickname = source.map { $0.1 }
        self.tableView.reloadData()
    }
    
    self.tableView.delegate = self
//    self.tableView.dataSource = self
    
  }
  
  // 사용자의 액션에 따라 델리게이트 메소드를 호출한다.
  @objc func moveSide(_ sender: Any) {
    if sender is UIScreenEdgePanGestureRecognizer {
      self.delegate?.openSideBar(nil)
    } else if sender is UISwipeGestureRecognizer {
      self.delegate?.closeSideBar(nil)
    } else if sender is UIBarButtonItem {
      if self.delegate?.isSideBarShowing == false {
        self.delegate?.openSideBar(nil) // 사이드 바를 연다.
      } else {
        self.delegate?.closeSideBar(nil)// 사이드 바를 닫는다.
      }
    }
  }
    
    
}
