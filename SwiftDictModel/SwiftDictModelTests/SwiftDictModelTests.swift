//
//  SwiftDictModelTests.swift
//  SwiftDictModelTests
//
//  Created by 刘凡 on 15/2/17.
//  Copyright (c) 2015年 joyios. All rights reserved.
//

import UIKit
import XCTest

// MARK: - 全局属性
/// 字典转模型管理器单例
let modelManager = DictModelManager.sharedManager
/// 测试用例 bundle
let modelBundle = NSBundle(forClass: SwiftDictModelTests.self)

class SwiftDictModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    ///  测试单例
    func testSingleton() {
        var manager1 = DictModelManager.sharedManager
        var manager2 = DictModelManager.sharedManager
        
        XCTAssert(manager1 === manager2, "单例实例不一致")
    }

    ///  测试加载JSON数据
    func testLoadJSON() {
        XCTAssertNotNil(serializationJSON("ModelInfo.json"), "JSON 反序列化错误")
        XCTAssertNil(serializationJSON("Error.json"), "错误格式的 JSON，不应该返回数据")
    }
}

///  加载 JSON 并返回反序列化结果
func serializationJSON(filename: String) -> AnyObject? {
    if let fileURL = modelBundle.URLForResource(filename, withExtension: nil) {
        if let data = NSData(contentsOfURL: fileURL) {
            return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil)
        }
    }
    return nil
}
