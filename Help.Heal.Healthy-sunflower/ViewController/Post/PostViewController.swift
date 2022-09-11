//
//  PostViewController.swift
//  Help.Heal.Healthy
//
//  Created by iMac01 on 2019/6/26.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PostViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var healthyPost: UITableView!
    private var posts:[PostMessage] = []
    private var topic =  ""
    private var document = ""
    let server = Server()
    override func viewDidLoad() {
        super.viewDidLoad()
        healthyPost.delegate = self
        healthyPost.dataSource = self
        server.getPost() {
            (result) in
            if(!result.isEmpty){
                self.posts = result
            }
            self.healthyPost.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.backgroundColor = #colorLiteral(red: 1, green: 0.9545667768, blue: 0.8456578851, alpha: 1)
        
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostTableViewCell
        cell.backgroundColor = #colorLiteral(red: 1, green: 0.9545667768, blue: 0.8456578851, alpha: 1)
        cell.title.backgroundColor = #colorLiteral(red: 1, green: 0.9545667768, blue: 0.8456578851, alpha: 1)
        cell.title.text = posts[indexPath.row].title
        cell.date.text = posts[indexPath.row].date
        //cell.document.text = posts[indexPath.row].document
        return cell
        // Configure the cell...
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        topic = posts[indexPath.row].title!
        document = posts[indexPath.row].document!
        //let docu = UIStoryboard().instantiateViewController(withIdentifier: "post")
        //self.navigationController?.pushViewController(docu, animated: true)
        performSegue(withIdentifier: "toDocument", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let controller = segue.destination as! LoadDataViewController
        controller.topic = self.topic
        controller.document = self.document
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
