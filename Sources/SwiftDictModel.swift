//
//  SwiftDictModel.swift
//
//
//  Created by 刘凡 on 15/2/17.
//
//

import Foundation

/// 私有全局变量，单例实例
private let sharedInstance = DictModelManager()

///  字典转模型协议
@objc public protocol DictModelProtocol {
    ///  自定义类映射表
    ///
    ///  :returns: 属性和自定义类的对应字典
    ///  :mark:    返回定义为 Self 是因为这个接口本身是没有包含类信息的
    ///            我们并不知道哪个类会实现这个接口，所以我们使用 Self 来指代将要实现这个接口的类
    static func customClassMapping() -> (Dictionary<String, String>?)
}

///  字典转模型管理器
public class DictModelManager {
    
    /// 单例类变量 - 全局的访问入口
    public class var sharedManager: DictModelManager {
        return sharedInstance
    }
    
    // MARK: - 公共函数
    ///  字典转模型方法
    ///
    ///  :param: dict 数据字典
    ///  :param: cls  模型类
    ///
    ///  :returns: 实例化后的模型对象
    public func objectWithDictionary(dict: NSDictionary, cls: AnyClass!) -> AnyObject? {
        
        // 提取模型字典
        let modelInfo = fullModelInfo(cls)
        
        // 实例化对象
        var obj: AnyObject = cls.alloc()
        
        // 遍历模型字典
        for (key, customClass) in modelInfo {
            // 如果赋值字典中存在内容
            if let value: AnyObject = dict[key] {
                if customClass == nil && !(value === NSNull()) {
                    obj.setValue(value, forKey: key)
                } else {
                    let type = NSStringFromClass(value.classForCoder)
                    if type == "NSDictionary" || type == "NSMutableDictionary" {
                        if let subObj: AnyObject = self.objectWithDictionary(value as! NSDictionary, cls: NSClassFromString(customClass as! String)) {
                            obj.setValue(subObj, forKey: key)
                        }
                    } else if type == "NSArray" || type == "NSMutableArray" {
                        if let subObjs = self.objectsWithArray(value as! NSArray, cls: NSClassFromString(customClass as! String)) {
                            obj.setValue(subObjs, forKeyPath: key)
                        }
                    }
                }
            }
        }
        
        return obj
    }
    
    ///  使用数组实例化模型对象数组
    ///
    ///  :param: array 数组
    ///  :param: cls   模型类
    ///
    ///  :returns: 实例化的模型数组
    public func objectsWithArray(array: NSArray, cls: AnyClass!) -> NSArray? {
        var list = [AnyObject]()
        
        // TODO: - 目前默认数组中存储的就是字典
        for dict in array {
            if let obj: AnyObject = objectWithDictionary(dict as! NSDictionary, cls: cls) {
                list.append(obj)
            }
        }
        
        return list
    }
    
    ///  返回指定对象的字典信息
    ///
    ///  :param: obj 模型对象
    ///
    ///  :returns: 字典信息
    public func objectDictionary(obj: AnyObject) -> Dictionary<NSString, AnyObject> {
        
        // 提取模型字典
        let modelInfo = fullModelInfo(obj.classForCoder)
        
        var infoDict = Dictionary<NSString, AnyObject>()
        
        for (key, customClass) in modelInfo {
            
            var value: AnyObject? = obj.valueForKey(key)
            if value == nil {
                value = NSNull()
            }
            
            if customClass == nil || value === NSNull() {
                infoDict[key] = value
            } else {
                let type = NSStringFromClass(value!.classForCoder)
                if type == "NSArray" || type == "NSMutableArray" {
                    infoDict[key] = objectArray(value as! [AnyObject])
                } else {
                    infoDict[key] = objectDictionary(value!)
                }
            }
        }
        
        return infoDict
    }

    ///  返回指定对象数组的字典数组信息
    ///
    ///  :param: objs 模型对象数组
    ///
    ///  :returns: 字典数组信息
    public func objectArray(objs: [AnyObject]) -> [AnyObject] {
        var array = [AnyObject]()
        
        for obj in objs {
            array.append(objectDictionary(obj))
        }
        
        return array
    }
    
    // MARK: - 私有函数
    ///  获取完整模型信息
    ///
    ///  :param: cls 模型类
    func fullModelInfo(cls: AnyClass) -> Dictionary<String, AnyObject?> {
        
        if let cache = cacheModel(cls) {
            return cache
        }
        
        // 遍历模型类的继承关系
        var c: AnyClass? = cls
        
        // 属性字典
        var infoDict = Dictionary<String, AnyObject?>()
        do {
            // 追加属性字典
            infoDict.merge(modelInfo(c!))
            
            c = c!.superclass()
            if NSStringFromClass(c).hasPrefix("NS") {
                break
            }
        } while c != nil
        
        // 将属性字典保存至模型缓冲池
        modelCahce["\(cls)"] = infoDict
        
        return cacheModel(cls)!
    }
    
    ///  获取模型信息
    ///
    ///  :param: cls 模型类
    func modelInfo(cls: AnyClass) -> Dictionary<String, AnyObject?> {
        
        if let cache = cacheModel(cls) {
            return cache
        }
        
        // 提取自定义属性类字典
        var customMappingDict: Dictionary<String, String>?
        if cls.respondsToSelector("customClassMapping") {
            customMappingDict = cls.customClassMapping()
        }
        
        var count: UInt32 = 0
        let properties = class_copyPropertyList(cls, &count)
        
        // 属性信息字典
        var infoDict = Dictionary<String, AnyObject?>()
        
        // 遍历属性列表
        for i in 0..<count {
            let property = properties[Int(i)]
            
            // 属性名称
            let cname = property_getName(property)
            let name = String.fromCString(cname)
            
            // 记录自定义类信息
            infoDict[name!] = customMappingDict?[name!]
        }
        
        free(properties)
        
        return infoDict
    }
    
    ///  返回模型缓冲池中的模型字典
    ///
    ///  :param: cls 模型类
    ///
    ///  :returns: 如果存在返回模型信息字典，否则返回 nil
    func cacheModel(cls: AnyClass) -> Dictionary<String, AnyObject?>? {
        return modelCahce["\(cls)"]
    }
    
    /// 模型缓冲池
    var modelCahce = Dictionary<String, Dictionary<String, AnyObject?>>()
}

extension Dictionary {
    mutating func merge<K, V>(dict: [K: V]) {
        for (k, v) in dict {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}

func printLog<T>(message: T, file: String = __FILE__, method: String = __FUNCTION__, line: Int = __LINE__) {
    println("\(file.lastPathComponent)[\(line)], \(method): \(message)")
}

