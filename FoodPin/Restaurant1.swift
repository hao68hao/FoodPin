//
//  Restaurant.swift
//  FoodPin
//
//  Created by lauda on 16/6/26.
//  Copyright © 2016年 lauda. All rights reserved.
//

import Foundation

/*
 变量在结构体中，不必赋值
 变量在类中，必须赋值
*/

//结构体的方式声明变量
struct Restaurant1 {
    var name: String
    var type: String
    var location: String
    var image: String
    var isVisited: Bool
    var rating = ""
    
    init (name: String, type: String, location: String, image: String, isVisited: Bool) {
                self.name = name
                self.type = type
                self.location = location
                self.image = image
                self.isVisited = isVisited
    }
    

    
}

//类的方式声明变量
//class Restaurant {
//    var name : String
//    var type : String
//    var location : String
//    var image : String
//    var isVisited : Bool
//    
//    init (name: String, type: String, location: String, image: String, isVisited: Bool) {
//        self.name = name
//        self.type = type
//        self.location = location
//        self.image = image
//        self.isVisited = isVisited
//    }
//}

