//
//  Dict2ModelTest.swift
//  SwiftDictModel
//
//  Created by 刘凡 on 15/2/18.
//  Copyright (c) 2015年 joyios. All rights reserved.
//

import UIKit
import XCTest

class Dict2ModelTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDict2Model() {
        
        var json: NSDictionary = serializationJSON("ModelInfo.json")! as! NSDictionary
        var modelInfo: ModelInfo? = modelManager.objectWithDictionary(json, cls: ModelInfo.self) as? ModelInfo
        
        printLog("------\(modelInfo)")
        printLog(modelInfo?.other?.modelName)
        printLog(modelInfo?.num)
        printLog(modelInfo?.others)
    }
    
    func testPerformence() {
        var json: NSDictionary = serializationJSON("ModelInfo.json")! as! NSDictionary
        
        performenceRunFunction(10000) {
            autoreleasepool({ () -> () in
                var modelInfo: ModelInfo? = modelManager.objectWithDictionary(json, cls: ModelInfo.self) as? ModelInfo
            })
        }
    }
    
    func performenceRunFunction(var loopTimes:Int, testFunc: ()->()) {
        var start = CFAbsoluteTimeGetCurrent()
        
        println("测试开始...")
        for _ in 0...loopTimes {
            testFunc()
        }
        
        var end = CFAbsoluteTimeGetCurrent()
        println("运行 \(loopTimes) 次，耗时 \(end - start)")
    }
    
    func testModel2Dict() {
        var json: NSDictionary = serializationJSON("ModelInfo.json")! as! NSDictionary
        
        if let modelInfo: ModelInfo = modelManager.objectWithDictionary(json, cls: ModelInfo.self) as? ModelInfo {
            var dict = modelManager.objectDictionary(modelInfo) as NSDictionary
            printLog(dict)
        }
    }
}
