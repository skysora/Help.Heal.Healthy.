//
//  FirstEnterAPPViewController.swift
//  Help.Heal.Healthy-sunflower
//
//  Created by YuMing Haung on 2019/10/8.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit
import ResearchKit
class FirstEnterAPPViewController: UIViewController, ORKTaskViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }
    

    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        
        
        taskViewController.dismiss(animated: true, completion: nil)
    }
}
