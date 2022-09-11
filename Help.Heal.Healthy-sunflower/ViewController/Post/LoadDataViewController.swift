//
//  LoadDataViewController.swift
//  Help.Heal.Healthy
//
//  Created by iMac01 on 2019/6/26.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoadDataViewController: UIViewController {
    
    
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var documentTextView: UITextView!
    var topic = ""
    var document = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        swipToRight()
        topicLabel.text = self.topic
        documentTextView.text = self.document
        // Do any additional setup after loading the view.
    }
    @objc func forswip(withGestureRecognizer recgnizer: UISwipeGestureRecognizer){
        self.performSegue(withIdentifier: "gotopost", sender: self)
        
    }
    func swipToRight(){
        let swip = UISwipeGestureRecognizer(target: self, action: #selector(LoadDataViewController.forswip(withGestureRecognizer: )))
        swip.direction = .right
        self.view.addGestureRecognizer(swip)
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
