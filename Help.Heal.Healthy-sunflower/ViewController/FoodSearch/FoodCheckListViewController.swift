//
//  FoodInsertViewController.swift
//  Help.Heal.Healthy
//
//  Created by Ａlvin on 2019/7/19.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit
import Cosmos
import TinyConstraints

class FoodCheckListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var insertButton: UIButton!
    
    //catch the data pass by foodSearchViewController
    var detectedFoodName = [String]()
    var detectFoodImage = [UIImage]()
    
    var foodSize = [String:Double]()
    
    //data for foodDetailViewController
    var foodDetailImage = UIImage()
    var foodDetailName = String()
    var foodDetailSize = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBarController?.tabBar.isHidden = true
        //setUpImageScrollView()
        //navigationController?.isNavigationBarHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        //let insertButtonClicked function assign to insertButton
        insertButton.addTarget(self, action: #selector(insertButtonClicked(_:)), for: UIControl.Event.touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //鍵盤按其他位置隱藏
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
           self.resignFirstResponder()
       }
    
    
    //set up image scroll view
    func setUpImageScrollView(){
        
        imageScrollView.contentSize = CGSize(width: detectedFoodName.count * Int(UIScreen.main.bounds.size.width) + detectedFoodName.count * 20, height: 0)
        imageScrollView.isScrollEnabled = true
        imageScrollView.showsVerticalScrollIndicator = false
        imageScrollView.bounces = true
        imageScrollView.zoomScale = 1.0
        imageScrollView.minimumZoomScale = 0.5
        imageScrollView.maximumZoomScale = 2.0
        imageScrollView.isPagingEnabled = false
        //imageScrollView.delegate = self
        let totalView = UIView(frame: CGRect(x: 0, y: 0, width: detectedFoodName.count * 250, height: 300))
        imageScrollView.addSubview(totalView)
        var i = 1
        //create the food imageView
        for (index, foodName) in detectedFoodName.enumerated() {
            let foodImageView = UIImageView(frame: CGRect(x: index * 250 + 100 + index*20, y: 0, width: 200, height: 200))
            foodImageView.image = detectFoodImage[index]
            foodImageView.layer.cornerRadius = foodImageView.frame.height/2
            foodImageView.clipsToBounds = true
            //foodImageView.center.y = totalView.center.y
            foodImageView.center.x = imageScrollView.center.x * CGFloat(i)
            i = i + 2
            foodImageView.tag = index
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(tapGestureRecognizer:)))
            foodImageView.isUserInteractionEnabled = true
            foodImageView.addGestureRecognizer(tapGestureRecognizer)
            totalView.addSubview(foodImageView)
        }
    }
    //when the image view is clicked
    @objc func imageViewTapped(tapGestureRecognizer:UITapGestureRecognizer){
        let imageView = tapGestureRecognizer.view as! UIImageView
        foodDetailImage = imageView.image!
        foodDetailName = detectedFoodName[imageView.tag]
        foodDetailSize = foodSize[foodNameTranslate[foodDetailName]!]!
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    //when the insert button clicked
    @objc func insertButtonClicked(_ sender: UIButton) {
        let cells:[FoodCheckListTableViewCell] = getAllCells()
        if(!cells.isEmpty){
            var foodNameList = [String]()
            var foodPortionList = [Double]()
            for cell in cells{
                foodNameList.append(cell.foodEnglishName)
                foodPortionList.append(Double(cell.foodPortion.text!)!)
            }
            var foodData = [String:Any]()
            foodData["foodName"] = foodNameList
            foodData["foodPortion"] = foodPortionList
            Server().foodInsert(foodList: foodData)
        }
        
    }
    //get all the cell data
    func getAllCells() -> [FoodCheckListTableViewCell] {

       var cells = [FoodCheckListTableViewCell]()
       // assuming tableView is your self.tableView defined somewhere
       for i in 0...tableView.numberOfSections-1
       {
        for j in 0...tableView.numberOfRows(inSection: i)-1
           {
            if let cell = tableView.cellForRow(at: NSIndexPath(row: j, section: i) as IndexPath) as? FoodCheckListTableViewCell {
                
                  cells.append(cell)
               }

           }
       }
    return cells
    }
    
}




//set up taleView
extension FoodCheckListViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detectedFoodName.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? FoodCheckListTableViewCell
        cell?.foodNameLabel.text = foodNameTranslate[detectedFoodName[indexPath.row]]
        cell?.foodEnglishName = detectedFoodName[indexPath.row]
        foodSize[(cell?.foodNameLabel.text!)!] = 0.5
        cell?.foodPortion.text = "0.5"
        
        return cell!
    }
    //cell selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("cell select")

//        let cell = tableView.cellForRow(at: indexPath) as! FoodCheckListTableViewCell
//        cell.ratingView.didTouchCosmos = {rating in
//            self.foodSize[cell.foodNameLabel.text!] = rating
//            print("\(cell.foodNameLabel.text!) \(rating)")
//        }
        
    }
    //cell delete
    func tableView(_ tableView: UITableView, canEditRowAtindexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        foodSize.removeValue(forKey: detectedFoodName[indexPath.row])
        detectedFoodName.remove(at: indexPath.row)
        //if there do not have food, inset button is not enable to click
        if(detectedFoodName.isEmpty){
            insertButton.isEnabled = false
        }
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .right)
        tableView.endUpdates()
    }
    
    
    
    
}
