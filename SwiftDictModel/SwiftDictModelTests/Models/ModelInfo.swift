//
//  ModelInfo.swift
//  SwiftDictModel
//
//  Created by 刘凡 on 15/2/17.
//  Copyright (c) 2015年 joyios. All rights reserved.
//

import UIKit

///  模型信息测试类
class ModelInfo: NSObject, DictModelProtocol {
    ///  字符串
    var str1: NSString?
    var str2: String?
    ///  数值型属性
    var b: Bool = false
    var i: Int = 0
    var i8: Int8 = 0
    var i16: Int16 = 0
    var i32: Int32 = 0
    var i64: Int64 = 0
    var f: Float = 0
    var d: Double = 0
    var num: NSNumber?
    ///  数组
    var a1: NSMutableArray?
    var a2: NSArray?
    var a3: [String]?
    ///  字典
    var d1: NSMutableDictionary?
    var d2: NSDictionary?
    var d3 = ["name": "name value"]
    // 只读属性，使用 KVC 赋值不会报错
    private(set) internal var readonlyProperty: Int = 100
    
    // 自定义类属性
    var other: OtherModel?
    // 自定义类数组属性
    var others: [OtherModel]?
    // 自定义类泛型数组属性
    var others2: Array<OtherModel>?

    static func customClassMapping() -> (Dictionary<String, String>?) {
        return(["other": "\(OtherModel.self)",
            "others": "\(OtherModel.self)",
            "others2": "\(OtherModel.self)"])
    }
}

///  自定义属性测试类
class OtherModel: NSObject {
    var modelName: String?
}

///  自定义子类
class SubModelInfo: ModelInfo {
    var name: String?
}

