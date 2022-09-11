//
//  FoodSearchViewController.swift
//  Help.Heal.Healthy
//
//  Created by Ａlvin on 2019/6/27.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit
import AVKit
import Vision
import AlamofireImage
import Alamofire
import SwiftyJSON

//food name translate
let foodNameTranslate = ["Lychee":"荔枝", "Longan":"龍眼","Dumpling":"水餃","Loquat":"枇杷", "Tangyuan":"湯圓", "Steamed Lotus Root":"桂花糯米藕", "DongPo Pork":"東坡肉"]
class FoodIdentifyViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var finishButton: UIButton!
    //control the scroll page
    var page:Int = 0
    //foodName contain  all the searchable food
    var foodName = ["枇杷", "東坡肉", "湯圓", "桂花糯米藕", "水餃", "荔枝", "龍眼"]
    //get the screen size
    private let fullsize = UIScreen.main.bounds.size
    
////////////////////////////////////////////////////////////////////////////////////////////////
    //Page_1
    @IBOutlet weak var page_1: UIView!
    //@IBOutlet weak var fooDInsertView: UIView!
    //@IBOutlet weak var foodInsertTableView: UITableView!
    @IBOutlet weak var foodImageScrollView: UIScrollView!
    let captureSession = AVCaptureSession()
    //food detec times
    var foodDetectCount:[String:Int] = [:]
    //how many times the food have been detected and the food buuton will appear
    let foodLabelAppear = 1
    //count the already appear food button
    var foodLabelNumber = 0
    //store deteced food data for segue to FoodInsertViewController
    var detecedFoodName = [String]()
    var detecedFoodWeight = [Double]()
    var detectedFoodCaloire = [Double]()
    var comformedFoodName = [String:Bool]()
    var comformedFoodWeight = [Double:Bool]()
    var comformedFoodCaloire = [Double:Bool]()
    var totalCalorie: Double = 0
    var totalWater: Double = 0
    var totalProtein: Double = 0
    var totalCarbonhydrate: Double = 0
    var totalFat: Double = 0
    var totalSugar: Double = 0
    var totalSalt: Double = 0
    //food button size
    var foodImageView_Width:Int = 0
    var foodImageView_Height:Int = 0
    var foodNameLabel_Width:Int = 0
    var foodNameLabel_Height:Int = 0

////////////////////////////////////////////////////////////////////////////////////////////////
    //Page_2
    @IBOutlet weak var page_2: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var foodSearchTableView: UITableView!
    //searchResult contain all the food anme search result
    var searchResult = [String]()
    //check the search bar isn't active
    var isSearching = false
    ////////////////////////////////////////////////////////////////////////////////////////////////

  

    
    
    //record the index of cell which user selected
    public var tableViewIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setUpScrollView()
        setUpFoodLabel()
        setUpPage_1()
        //setUpFoodInsertView()
        
       
        
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        captureSession.stopRunning()
        //sceneView.session.pause()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //FoodSearchViewController.instance = self
        captureSession.startRunning()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        tabBarController?.tabBar.isHidden = true
        //navigationController?.isNavigationBarHidden = true
    }
    
    /*
    //set up the scroll view
    func setUpScrollView(){
        print(fullsize.width,fullsize.height)
        //set up the scrollable size
        scrollView.contentSize = CGSize(width: fullsize.width * 2, height: 0)
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = true
        scrollView.zoomScale = 1.0
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
    }
    //when the user finish scrolling
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0) {
            print("scroll right")
            self.tabBarController?.tabBar.isHidden = true
            navigationController?.isNavigationBarHidden = true
            captureSession.startRunning()
        }
        else {
            print("scroll left")
            self.tabBarController?.tabBar.isHidden = false
            navigationController?.isNavigationBarHidden = false
            captureSession.stopRunning()
        }
    }*/
    
    
///////////////////Page_1 Function/////////////////////////////////////////////////////////////////////////////

    //generate fake food lable
    func generateFoodLabel(){
        detecedFoodName = ["炸排骨","豬血", "蒸蛋", "瓜", "白飯"]
        sleep(1)
        for foodname in detecedFoodName{
            
            let foodImageView = UIImageView(frame: CGRect(x: self.foodLabelNumber*Int(Int(self.fullsize.width)/detecedFoodName.count), y: Int(self.fullsize.height-200), width: Int(Int(self.fullsize.width)/detecedFoodName.count), height: Int(Int(self.fullsize.width)/detecedFoodName.count)))
            
            
            foodImageView.image = UIImage(named: foodname)
            //let foodImaegeView become a circle
            foodImageView.layer.cornerRadius = foodImageView.frame.height/2
            foodImageView.clipsToBounds = true
            
            
            let foodNameLength = foodname.count
            let foodLabel = UILabel(frame: CGRect(x: Int(Int(self.fullsize.width)/detecedFoodName.count)*self.foodLabelNumber + (self.foodLabelNumber+1)*20, y: Int(self.fullsize.height-110), width: Int(50 * foodNameLength), height: self.foodNameLabel_Height))
            
            foodLabel.text = foodname
            foodLabel.textColor = UIColor.black
            foodLabel.center.x = foodImageView.center.x
            //foodLabel.backgroundColor = UIColor.blue
            foodLabel.textAlignment = .center
            foodLabel.textColor = UIColor.white
            self.page_1.addSubview(foodImageView)
            self.page_1.addSubview(foodLabel)
            finishButton.isHidden = false
            foodLabelNumber += 1
            let weight = Double.random(in: 100...500)
            self.detecedFoodWeight.append(weight)
            self.detectedFoodCaloire.append(Double.random(in: 1...3) * weight)
            
            //the vlaue of weight or caloire may be reapet
            self.comformedFoodName[foodname] = true
            self.comformedFoodWeight[weight] = true
            self.comformedFoodCaloire[Double.random(in: 1...3) * weight] = true
        }
        
    
    }
    

    //set up the food label
    func setUpFoodLabel(){
        foodImageView_Width = 100
        foodImageView_Height = 100
        foodNameLabel_Width = 50
        foodNameLabel_Height = 50
    }
    
//    func setUpFoodInsertView(){
//        fooDInsertView.isHidden = true
//        fooDInsertView.alpha = 0.9
//        fooDInsertView.layer.cornerRadius = 20
//        fooDInsertView.center.x = self.view.center.x
//        fooDInsertView.center.y = self.view.center.y - 20
//    }
    
    //let page_1 become a camera
    func setUpPage_1(){
        //captureSession.sessionPreset = .photo
        self.page_1.frame.size = fullsize
        
        let captureDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
        guard let input = try? AVCaptureDeviceInput(device: captureDevice!)else {return}
        //captureSession.beginConfiguration()
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.page_1.layer.addSublayer(previewLayer)
        previewLayer.frame = self.page_1.frame
        self.page_1.layer.insertSublayer(previewLayer, at: 0)
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
        finishButton.layer.cornerRadius = 10
        finishButton.center.x = self.page_1.center.x
        //when user start to scaning the food success the button wil show
        finishButton.isHidden = true
        finishButton.addTarget(self, action: #selector(finishButtonClick(sender:)), for: .touchUpInside)
        self.page_1.addSubview(finishButton)
        
        
    }
    
    
    
    
    //when the camera detect image ouput
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let model = try? VNCoreMLModel(for: myfoodDetection_Zhejiang().model)else {return}
        let objectRecognition = VNCoreMLRequest(model: model, completionHandler: {(request, error) in
            DispatchQueue.main.async(execute: {
                let result = request.results!
                for observation in result where observation is VNRecognizedObjectObservation{
                    guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                        continue
                    }
                    let label = objectObservation.labels.first!
                    print(label.identifier, label.confidence)
                    // count the label(food) if the confidence over 93%
                    if(label.confidence >= 0.93){
                        //記錄辨識到的食物
                        let foodTranslatedName = foodNameTranslate[label.identifier]
                        if(!self.detecedFoodName.contains(label.identifier)){
                            self.detecedFoodName.append(label.identifier)
                        }
                        self.foodDetectCount[foodTranslatedName!, default: 0] += 1
                        
                        
                        
                        
                        //create the food label if the food already detect 10 times
                        if(self.foodDetectCount[foodTranslatedName!]! == self.foodLabelAppear){

                            let foodImageView = UIImageView(frame: CGRect(x: Int((self.foodImageView_Width*self.foodLabelNumber) + 10), y: Int(self.fullsize.height-200), width: self.foodImageView_Width, height: self.foodImageView_Height))
                            //request food image
                            Server().reqestFoodImage(foodName: label.identifier){
                                (result) in
                                foodImageView.image = result
                            }
                            
                            foodImageView.backgroundColor = UIColor.gray
                            //let foodImaegeView become a circle
                            foodImageView.layer.cornerRadius = foodImageView.frame.height/2
                            foodImageView.clipsToBounds = true
                            //create the food label
                            let foodNameLength = foodNameTranslate[label.identifier]?.count
                            let foodLabel = UILabel(frame: CGRect(x: self.foodImageView_Width*self.foodLabelNumber + (self.foodLabelNumber+1)*20, y: Int(self.fullsize.height-110), width: Int(50 * foodNameLength!), height: self.foodNameLabel_Height))

                            foodLabel.text = foodNameTranslate[label.identifier]
                            foodLabel.textColor = UIColor.black
                            foodLabel.center.x = foodImageView.center.x
                            //foodLabel.backgroundColor = UIColor.blue
                            foodLabel.textAlignment = .center
                            foodLabel.textColor = UIColor.white
                            //add food label nad image to view
                            self.page_1.addSubview(foodImageView)
                            self.page_1.addSubview(foodLabel)
                            self.foodLabelNumber += 1
                            //store the data
//
//                            let weight = Double.random(in: 100...500)
//                            self.detecedFoodWeight.append(weight)
                            self.detectedFoodCaloire.append(Double.random(in: 100...500))
//
//                            //the vlaue of weight or caloire may be reapet
//                            self.comformedFoodName[label.identifier] = true
//                            self.comformedFoodWeight[weight] = true
//                            self.comformedFoodCaloire[Double.random(in: 100...500)] = true
                            //request food detail
//                            let url = "http://140.134.26.159:5000/foodInfo/" + label.identifier
//                            //reqest JSON
//                            Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON(completionHandler: {response in
//
//                                if(response.result.isSuccess){
//                                    let data:JSON = try! JSON(data: response.data!)
//                                    print(data)
//                                    let mass:Double = Double(weight) / 100
//                                    self.totalCalorie += mass * data["calories"].doubleValue
//                                    self.totalWater += mass * data["water"].doubleValue
//                                    self.totalProtein += mass * data["protein"].doubleValue
//                                    self.totalCarbonhydrate += mass * data["CnH2nOn"].doubleValue
//                                    self.totalFat += mass * data["fat"].doubleValue
//                                    self.totalSugar += mass * data["sugar"].doubleValue
//                                    self.totalSalt += mass * data["salt"].doubleValue
//                                }
//                                else{
//                                    print("No respone")
//                                }
//                            })
                        }
                        if(self.foodLabelNumber == 1){
                            self.finishButton.isHidden = false
                        }
                        
                    }
                }
            })
        })
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([objectRecognition])
        
    }
/*
    //user click to select or unselect the food
    @objc func foodButtonClicked(sender:UIButton){
        if(sender.isSelected){
            sender.backgroundColor = UIColor.gray
            sender.isSelected = false
            
        }
        else{
            sender.backgroundColor = UIColor.blue
            sender.isSelected = true
        }
        
    }
 */
    //when the finsih button is clicked, show the food confirm tableView
    @objc func finishButtonClick(sender:UIButton){
//        finishButton.isHidden = true
//        fooDInsertView.isHidden = false
//        foodInsertTableView.reloadData()
    }
    
    //the food comform button clicked and push view to IngredientViewController
    @IBAction func comformButtomClick(_ sender: Any) {
        print("comfirmbuttonclick")
        //Server().foodInsert(foodList: detecedFoodName)
    }
    
    
    //passing the deteced food data to FoodCheckListViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let foodCheckListViewController = segue.destination as? FoodCheckListViewController{
            foodCheckListViewController.detectedFoodName = detecedFoodName
            self.tabBarController?.tabBar.isHidden = false
        }
    }
   
    
    
    //鍵盤按其他位置隱藏
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //self.page_2.endEditing(true)
        //self.page_2.resignFirstResponder()
    }
    //鍵盤按search位置隱藏
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

/*
//set up page_2's taleView
extension FoodIdentifyViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        if(tableView == foodSearchTableView){
            if(isSearching){
                count = searchResult.count
            }
            else{
             
                count = foodName.count
            }
        }
//        else if(tableView == foodInsertTableView){
//            count = detecedFoodName.count
//        }
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if(tableView == foodSearchTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            if(isSearching){
                cell.textLabel?.text = searchResult[indexPath.row]
            }
            else{
                cell.textLabel?.text = foodName[indexPath.row]
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "foodInsertCell") as! FoodInsertTableViewCell
            
            cell.foodNameLabel.text = foodNameTranslate[detecedFoodName[indexPath.row]]
            //cell.foodNameLabel.text = detecedFoodName[indexPath.row]
            //cell.foodWeightlabel.text = String(Int(detecedFoodWeight[indexPath.row])) + "g"
            //cell.foodCaloireLabel.text = String(Int(detectedFoodCaloire[indexPath.row])) + "kcal/100g"
            //user unselect or select the food at foodInsert tableView
            cell.actionBlock = {
                if(cell.select){
                    cell.select = false
//                    self.comformedFoodName[cell.foodNameLabel.text!] = false
//                    self.comformedFoodWeight[Double(cell.foodWeightlabel.text!)!] = false
//                    self.comformedFoodCaloire[Double(cell.foodCaloireLabel.text!)!] = false
                    cell.comformButton.setImage(UIImage(named: "foodUnComform"), for: .normal)
                    self.detecedFoodName.remove(at: self.detecedFoodName.index(of: cell.foodNameLabel.text!)!)
                }
                else{
                    cell.select = true
//                    self.comformedFoodName[cell.foodNameLabel.text!] = true
//                    self.comformedFoodWeight[Double(cell.foodWeightlabel.text!)!] = true
//                    self.comformedFoodCaloire[Double(cell.foodCaloireLabel.text!)!] = true
                    cell.comformButton.setImage(UIImage(named: "foodComform"), for: .normal)
                    self.detecedFoodName.append(cell.foodNameLabel.text!)
                }
            }
            return cell
        }
        

        
    }
    //cell selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == foodSearchTableView){
            //adding the search history
            tableViewIndex = indexPath.row
            if(isSearching){
                foodName.insert(searchResult[tableViewIndex], at: 0)
                if(foodName.contains(searchResult[tableViewIndex])){
                    foodName.remove(at: tableViewIndex)
                }
            }
            else{
                foodName.insert(foodName[tableViewIndex], at: 0)
                foodName.remove(at: tableViewIndex)
                
            }
        }
        else{
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
    }
    
    
}
//set up page_2 search bar
extension FoodIdentifyViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText != ""){
            searchResult = foodName.filter({(food) -> Bool in
                return food.contains(searchText)
            })
            isSearching = true
        }
        else{
            isSearching = false
        }
        foodSearchTableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        foodSearchTableView.reloadData()
    }
}*/
