//
//  JsonData.swift
//  垃圾車來了
//
//  Created by 林松賢 on 2018/5/17.
//  Copyright © 2018年 林松賢. All rights reserved.
//

import Foundation

struct DustCartModel {
    var lineid: String
    var car: String
    var time: String
    var location: String
    var longitude: String
    var latitude: String
    var cityid: String
    var cityname: String
    var distanceFromUser: Int
    
    init(lineid: String, car: String, time: String, location: String, longitude: String, latitude: String, cityid: String, cityname: String, distanceFromUser: Int) {
        self.lineid = lineid
        self.car = car
        self.time = time
        self.location = location
        self.longitude = longitude
        self.latitude = latitude
        self.cityid = cityid
        self.cityname = cityname
        self.distanceFromUser = distanceFromUser
    }
}
