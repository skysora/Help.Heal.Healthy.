//
//  MapViewController.swift
//  
//
//  Created by YuMing Haung on 2019/10/15.
//

import UIKit
import MapKit
import Foundation
import CoreLocation

class MapViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate{
    let locationManager = CLLocationManager()
    let stadiums = [
        PositionData(title:"test",locationName: "紫金港餐饮中心临湖餐厅",subtitle:"test",  coordinate: CLLocationCoordinate2D(latitude:30.304103,longitude: 120.085608)),
        PositionData(title:"test",locationName: "紫金港西区留学生食堂",subtitle:"test",  coordinate: CLLocationCoordinate2D(latitude:30.261501,longitude:  120.126050)),
        PositionData(title:"test",locationName: "清真餐厅",subtitle:"test",  coordinate: CLLocationCoordinate2D(latitude:30.307932,longitude: 120.084159)),
        PositionData(title:"test",locationName: "紫金港餐饮中心风味餐厅",subtitle:"test",  coordinate: CLLocationCoordinate2D(latitude:30.308139,longitude: 120.083965)),
        PositionData(title:"test",locationName: "麦香餐厅",subtitle:"test",  coordinate: CLLocationCoordinate2D(latitude:30.296719,longitude: 120.087201))

    ]
    @IBOutlet weak var mapView: MKMapView!
    var myLocationManager :CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 建立一個 CLLocationManager
        myLocationManager = CLLocationManager()

        // 設置委任對象
        myLocationManager.delegate = self
        mapView.delegate = self
        // 距離篩選器 用來設置移動多遠距離才觸發委任方法更新位置
        myLocationManager.distanceFilter =
          kCLLocationAccuracyNearestTenMeters

        // 取得自身定位位置的精確度
        myLocationManager.desiredAccuracy =
          kCLLocationAccuracyBest
        // 地圖樣式
        mapView.mapType = .standard
        // 顯示自身定位位置
         mapView.showsUserLocation = true

        // 允許縮放地圖
        mapView.isZoomEnabled = true
        // 4. 加入測試數據
        fetchStadiumsOnMap(stadiums)
        
        
    }
    
    private func locationManager(manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]) {
      // 印出目前所在位置座標
      let currentLocation :CLLocation =
        locations[0] as CLLocation
        print("\(currentLocation.coordinate.latitude)")
        print(", \(currentLocation.coordinate.longitude)")
        
        // 設置地圖顯示的範圍與中心點座標
        let center:CLLocation = CLLocation(
            latitude: currentLocation.coordinate.latitude,
            longitude: currentLocation.coordinate.longitude)
        // 地圖預設顯示的範圍大小 (數字越小越精確)
        let latDelta = 0.05
        let longDelta = 0.05
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let currentRegion:MKCoordinateRegion =
          MKCoordinateRegion(
            center: center.coordinate,
            span: currentLocationSpan)
        mapView.setRegion(currentRegion, animated: true)
        
    }
    func fetchStadiumsOnMap(_ stadiums: [PositionData]) {
      for stadium in stadiums {
        let annotations = PositionData(title: stadium.locationName!,
                                       locationName: stadium.locationName!,
                                       subtitle: "null",
                                       coordinate: stadium.coordinate)
        mapView.addAnnotation(annotations)
      }
        
    }
    
    func mapView(_ mapView: MKMapView , viewFor annotation : MKAnnotation)->MKAnnotationView?{
        let image = UIImage(named:"pin")
        if let annotation = annotation as? PositionData{
            var myView = mapView.dequeueReusableAnnotationView(withIdentifier: "Pins")
            if myView == nil {
                myView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Pins")
                myView?.image = image
                if annotation.title == "紫金港餐饮中心风味餐厅" {
                // 設定左方圖片
                let imageView = UIImageView(image: UIImage(named: "soymilk"))
                imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                imageView.layer.cornerRadius = 6
                imageView.clipsToBounds = true
                myView?.leftCalloutAccessoryView = imageView
                 
                // 設定中間描述
                let label = UILabel()
                label.text = "余杭塘路388号"
                label.font = UIFont(name: "PingFangTC-Medium", size: 14)
                myView?.detailCalloutAccessoryView = label
                
                // 設定右方按鈕
                let button = UIButton(type: .detailDisclosure)
                button.addTarget(self, action: #selector(checkDetail), for: .touchUpInside)
                myView?.rightCalloutAccessoryView = button
                myView?.canShowCallout = true
                }
            }else{
                myView?.annotation = annotation
            }
            return myView
        }else{
             return nil
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.showsUserLocation = true   //顯示user位置
        mapView.userTrackingMode = .follow  //隨著user移動
        // 首次使用 向使用者詢問定位自身位置權限
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // 取得定位服務授權
            myLocationManager.requestWhenInUseAuthorization()

            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
        }
        // 使用者已經拒絕定位自身位置權限
        else if CLLocationManager.authorizationStatus() == .denied {
            // 提示可至[設定]中開啟權限
            let alertController = UIAlertController(
              title: "定位權限已關閉",
              message:
              "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
              preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "確認", style: .default, handler:nil)
            alertController.addAction(okAction)
            
            self.present(
              alertController,
              animated: true, completion: nil)
        }
        // 使用者已經同意定位自身位置權限
        else if CLLocationManager.authorizationStatus()
            == .authorizedWhenInUse {
            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 停止定位自身位置
        myLocationManager.stopUpdatingLocation()
    }
     @objc func checkDetail(_ sender: UIButton) {
        
        let controller = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let names = ["詳細推薦菜單", "知道更多"]
        for name in names {
           let action = UIAlertAction(title: name, style: .default) {
            _ in
            if let nextPage = self.storyboard?.instantiateViewController(withIdentifier:"MealRecommendList") as? MealRecommendViewPage2ViewController{
                self.navigationController?.pushViewController(nextPage, animated: true)
            }

//            self.performSegue(withIdentifier: "mapGoToMealCommendList", sender: self)
           }
            controller.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        
        present(controller, animated: true, completion: nil)
        }
}

