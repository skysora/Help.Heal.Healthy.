//
//  WarnViewController.swift
//  Help.Heal.Healthy
//
//  Created by iMac01 on 2019/6/24.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit

class WarnViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{

    @IBOutlet weak var today: UITableView!
    @IBOutlet weak var notToday: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        today.delegate = self
        today.dataSource = self
        notToday.delegate = self
        notToday.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    var warns:[Warn] = [
        Warn.init(type : "Important" , date : "2019/06/24" , word : "06/26 upgrade"),
        Warn.init(type : "Suggestion" , date : "2019/06/24" , word : "Please eat more vegetable"),
        Warn.init(type : "Suggestion" , date : "2019/06/24" , word : "Please eat more vegetable"),
        Warn.init(type : "Suggestion" , date : "2019/06/24" , word : "Please eat more vegetable"),
        Warn.init(type : "Suggestion" , date : "2019/06/24" , word : "Please eat more vegetable"),
        Warn.init(type : "Suggestion" , date : "2019/06/24" , word : "Please eat more vegetable"),
        Warn.init(type : "Suggestion" , date : "2019/06/24" , word : "Please eat more vegetable"),
        Warn.init(type : "Suggestion" , date : "2019/06/24" , word : "Please eat more vegetable"),
        Warn.init(type : "Suggestion" , date : "2019/06/24" , word : "Please eat more vegetable"),
        Warn.init(type : "Suggestion" , date : "2019/06/24" , word : "Please eat more vegetable"),
        Warn.init(type : "Suggestion" , date : "2019/06/24" , word : "Please eat more vegetable")
    ]
    var warns2:[Warn] = [
        Warn.init(type: "Suggestion", date: "2019/06/12", word: "You have to eat lunch!"),
        Warn.init(type: "Important", date: "2019/06/10", word: "new method to detect your food"),
        Warn.init(type: "Important", date: "2019/06/10", word: "new method to detect your food"),
        Warn.init(type: "Important", date: "2019/06/10", word: "new method to detect your food"),
        Warn.init(type: "Important", date: "2019/06/10", word: "new method to detect your food"),
        Warn.init(type: "Important", date: "2019/06/10", word: "new method to detect your food"),
        Warn.init(type: "Important", date: "2019/06/10", word: "new method to detect your food"),
        Warn.init(type: "Important", date: "2019/06/10", word: "new method to detect your food"),
        Warn.init(type: "Important", date: "2019/06/10", word: "new method to detect your food"),
        Warn.init(type: "Important", date: "2019/06/10", word: "new method to detect your food"),
        Warn.init(type: "Suggestion", date: "2019/06/08", word: "Please drink more water"),
        Warn.init(type: "Important", date: "2019/06/04", word: "First start with H.H.H")
    ]
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableView == today{
            return warns.count
        }
        else{
            return warns2.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.backgroundColor = #colorLiteral(red: 1, green: 0.9545667768, blue: 0.8456578851, alpha: 1)
        if tableView == today{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WarnTableViewCell
            cell.backgroundColor = #colorLiteral(red: 1, green: 0.9545667768, blue: 0.8456578851, alpha: 1)
            cell.typeLabel.setTitle(warns[indexPath.row].type, for: .normal)
            cell.typeLabel.layer.cornerRadius = 10
            if warns[indexPath.row].type == "Suggestion"{
                cell.typeLabel.backgroundColor = #colorLiteral(red: 1, green: 0.819445014, blue: 0.4652218223, alpha: 1)
            }
            cell.dateLabel.text = warns[indexPath.row].date
            cell.wordLabel.text = warns[indexPath.row].word
            return cell
        }
        else{
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! WarnTableViewCell
            cell2.backgroundColor = #colorLiteral(red: 1, green: 0.9545667768, blue: 0.8456578851, alpha: 1)
            cell2.typeLabel2.setTitle(warns2[indexPath.row].type, for: .normal)
            cell2.typeLabel2.layer.cornerRadius = 10
            if warns2[indexPath.row].type == "Suggestion"{
                cell2.typeLabel2.backgroundColor = #colorLiteral(red: 1, green: 0.819445014, blue: 0.4652218223, alpha: 1)
            }
            cell2.dateLabel2.text = warns2[indexPath.row].date
            cell2.wordLabel2.text = warns2[indexPath.row].word
            return cell2
        }
        // Configure the cell...
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
