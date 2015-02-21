//
//  StatusTests.swift
//  SwiftDictModel
//
//  Created by 刘凡 on 15/2/21.
//  Copyright (c) 2015年 joyios. All rights reserved.
//

import UIKit
import XCTest

///  微博字典转模型测试
class StatusTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStatusModel() {
        
        var json: NSDictionary = serializationJSON("status.json")! as! NSDictionary
        if let statuses = modelManager.objectsWithArray(json["statuses"] as! NSArray, cls: Status.self) as? [Status] {

            for status in statuses {
                println(status.text)
                
                if status.pic_urls != nil {
                    for url in status.pic_urls! {
                        println(url.thumbnail_pic)
                    }
                }
            }
        }
    }
}
