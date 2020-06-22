//
//  PrayListViewController.swift
//  pray_111
//
//  Created by vlm on 2020/06/11.
//  Copyright © 2020 rubypaper. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

struct Lecture: Codable {
    var id: Int
    var author: String
    var nickname: String
}

class PrayListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
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
    
    @IBOutlet weak var tableView: UITableView!
   
    
    
    
    
    
    var author:[String] = []
    
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
    
    
    var onComplete: (([String]) -> Void) = { _ in
        
    }
    
    func myPrint(source:String) -> Void {
        print(source)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        tableView.layer.zPosition = 999;

        let hello = "Hello World"
        
        myPrint(source: hello)
        myPrint(source: "Hello World")
    

        self.naming() { source in
            self.author = source.map { $0.0 }
            self.nickname = source.map { $0.1 }
            self.tableView.reloadData()
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
}




