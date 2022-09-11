//
//  InfiniteScrollView.swift
//  Help.Heal.Healthy
//
//  Created by iMac01 on 2019/7/9.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class InfiniteScrollView: UIView{
    private var CnH2nOn:Float
    private var protein:Float
    private var fat:Float
    private var sugar:Float
    private var salt:Float
    private var water:Float
    private var CnH2nOnSuggest:Float
    private var proteinSuggest:Float
    private var fatSuggest:Float
    private var sugarSuggest:Float
    private var saltSuggest:Float
    private var waterSuggest:Float
    
    var current = Date()
    let index = 4//放想要在中間的日期１～７
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .clear
        scroll.showsHorizontalScrollIndicator = false
        scroll.isPagingEnabled = true
        return scroll
    }()
    
    var datasource: [String]?{
        didSet{
            modifyDataSource()
        }
    }
    
    public var _datasource: [String]?{
        didSet{
            setupContentView()
        }
    }
    
    private func modifyDataSource(){
        guard var tempInput = datasource, tempInput.count >= 2 else{
            return
        }
        tempInput.append(tempInput.first!)
        tempInput.append(tempInput[1])
        tempInput.append(tempInput[2])
        tempInput.append(tempInput[3])
        
        
        tempInput.insert(tempInput[6], at: 0)//製作循環
        tempInput.insert(tempInput[6], at: 0)
        tempInput.insert(tempInput[6], at: 0)
        tempInput.insert(tempInput[6], at: 0)
        
        self._datasource = tempInput
    }
    
    private func setupContentView(){
        let subviews = scrollView.subviews
        for subview in subviews{
            subview.removeFromSuperview()
        }
        
        guard let data = _datasource else{return }
        self.scrollView.contentSize = CGSize(width: scrollView.frame.size.width / CGFloat(7) * CGFloat(data.count) , height: scrollView.frame.size.height)
        for i in 0..<data.count {
            var frame = CGRect()
            frame.origin.x = self.frame.width / 7 * CGFloat(i)
            frame.origin.y = 0
            frame.size.width = scrollView.frame.size.width / CGFloat(7)
            frame.size.height = scrollView.frame.size.height
            
            let label = UILabel(frame:frame)
            label.text = data[i]
            label.textColor = #colorLiteral(red: 1, green: 0.9770757556, blue: 0.9392765164, alpha: 1)
            label.font = label.font.withSize(20)
            label.textAlignment = .center
            self.scrollView.addSubview(label)
            
        }
        
        scrollView.contentOffset = CGPoint(x: (scrollView.frame.width / CGFloat(7) * CGFloat(index)) ,y: 0)//設定初始位子
    }

    
    lazy var tapView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        let swipToRight = UISwipeGestureRecognizer(target: self, action: #selector(didReceiveSwipToRight(sender:)))
        swipToRight.direction = .right
        let swipToLeft = UISwipeGestureRecognizer(target: self, action: #selector(didReceiveSwipToLeft(sender:)))
        swipToLeft.direction = .left
        view.addGestureRecognizer(swipToLeft)
        view.addGestureRecognizer(swipToRight)
        return view
    }()
    
    override init(frame: CGRect) {
        self.CnH2nOn = 0.0
        self.CnH2nOnSuggest = 600.0
        self.protein = 0.0
        self.proteinSuggest = 400.0
        self.fat = 0.0
        self.fatSuggest = 130.0
        self.sugar = 0.0
        self.sugarSuggest = 25.0
        self.salt = 0.0
        self.saltSuggest = 25.0
        self.water = 0.0
        self.waterSuggest = 2000.0
        
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        //scrollView.delegate = self
        setupSubViews()
        setLabel(currentDate : Date())
    }
    
    func setLabel(currentDate:Date){
        //要改的東西寫這裡
        let dateFormater = DateFormatter()
        let dateWeekFinder = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        dateWeekFinder.dateFormat = "EEEE"
        print(dateFormater.string(from: currentDate),"/",dateWeekFinder.string(from: currentDate))
        
        
        //以下是連結資料庫
        var url = "http://140.134.26.159:5000/dateInfo/" + accountForEverySwift + "/" //加入帳號
        url = url + dateFormater.string(from: currentDate)//加入日期
        Alamofire.request(url,method: .get,encoding:JSONEncoding.default).responseJSON(completionHandler: {
            response in
            if(response.result.isSuccess){
                print("success")
                let res: JSON = try! JSON(data: response.data!)
                print(res)
                self.CnH2nOn = res["CnH2nOn"].float!
                self.protein = res["protein"].float!
                self.fat = res["fat"].float!
                self.sugar = res["sugar"].float!
                self.salt = res["salt"].float!
                self.water = res["water"].float!
                print("CnH2nOn = ",self.CnH2nOn)
                print("protein = ",self.protein)
                //print("fat = ",self.fat)
                //判斷get是否成功
            }
            else{
                print(" ")
            }
        })
    }
    
    func getCnH2nOnProportion() -> Float{
        return CnH2nOn/CnH2nOnSuggest
    }
    func getProteinProportion() -> Float{
        return protein/proteinSuggest
    }
    func getFatProportion() -> Float{
        return fat/fatSuggest
    }
    func getSugarProportion() -> Float{
        return sugar/sugarSuggest
    }
    func getSaltProportion() -> Float{
        return salt/saltSuggest
    }
    func getWaterProportion() -> Float{
        return water/waterSuggest
    }
    
    @objc
    func didReceiveSwipToRight(sender:UISwipeGestureRecognizer) {
        let x = scrollView.contentOffset.x
        let lastRect = CGRect(x: x - scrollView.frame.width / 7 , y: 0, width: scrollView.frame.width , height: scrollView.frame.height)//滑動幅度
        scrollView.scrollRectToVisible(lastRect, animated: true)//滑動指令
        
        current = Calendar.current.date(byAdding: .day,value: -1 ,to: current)!//減一天
        setLabel(currentDate: current)
    }
    
    @objc
    func didReceiveSwipToLeft(sender:UISwipeGestureRecognizer) {
        let x = scrollView.contentOffset.x
        let nextRect = CGRect(x: x + scrollView.frame.width / 7 , y: 0, width: scrollView.frame.width , height: scrollView.frame.height)//滑動幅度
        scrollView.scrollRectToVisible(nextRect, animated: true)//滑動指令
        
        current = Calendar.current.date(byAdding: .day,value: 1 ,to: current)!//加一天
        setLabel(currentDate: current)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    func setupSubViews(){
        scrollView.frame = CGRect(x:0,y:0,width: self.frame.width,height: 40)//scrollView初始大小設定
        self.addSubview(scrollView)
        tapView.frame = self.bounds
        self.addSubview(tapView)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
}
/*
extension InfiniteScrollView : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("keep scroll")
        guard _datasource != nil else {return}
        let x = scrollView.contentOffset.x
        if x  >= scrollView.contentSize.width - scrollView.frame.size.width - 1 {//設定當contentoffset 顯示 五
            self.scrollView.contentOffset = CGPoint(x: scrollView.frame.width / 7 , y: 0)//跳回五
        }
        else if x <= 1  {
            self.scrollView.contentOffset = CGPoint(x: scrollView.frame.width, y: 0)
        }
    }
}
 */
