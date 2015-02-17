//
//  ModelInfoTests.swift
//  SwiftDictModel
//
//  Created by 刘凡 on 15/2/17.
//  Copyright (c) 2015年 joyios. All rights reserved.
//

import UIKit
import XCTest

class ModelInfoTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    ///  测试模型信息
    func testModelInfo() {
        printLog(modelManager.modelInfo(ModelInfo.self))
    }
    
    ///  测试子类模型信息
    func testSubModelInfo() {
        printLog(modelManager.modelInfo(SubModelInfo.self))
    }
    
    ///  测试遍历完整类模型信息
    func testFullModelInfo() {
        printLog(modelManager.fullModelInfo(ModelInfo.self))
        printLog(modelManager.fullModelInfo(SubModelInfo.self))
        
        // 测试模型是否被缓存
        modelManager.fullModelInfo(SubModelInfo.self)
        modelManager.fullModelInfo(ModelInfo.self)
    }
}
