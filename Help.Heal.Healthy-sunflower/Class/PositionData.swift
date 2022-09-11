//
//  PositionData.swift
//  Help.Heal.Healthy-sunflower
//
//  Created by YuMing Haung on 2019/10/18.
//  Copyright © 2019 sunflower. All rights reserved.
//
import MapKit
import Foundation
import CoreLocation


class PositionData : NSObject,MKAnnotation{
    let title: String?
    let locationName: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    init(title: String,locationName: String,subtitle: String,coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.subtitle = subtitle
        self.coordinate = coordinate
        
    }
    
}
