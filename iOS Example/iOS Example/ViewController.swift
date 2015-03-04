//
//  ViewController.swift
//  iOS Example
//
//  Created by 刘凡 on 15/2/18.
//  Copyright (c) 2015年 joyios. All rights reserved.
//

import UIKit
import SwiftDictModel

class ViewController: UIViewController {

    let manager = DictModelManager.sharedManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        if let json = serializationJSON("Person.json") as? NSDictionary {
            var stu: Student? = manager.objectWithDictionary(json, cls: Student.self) as? Student
            println(manager.objectDictionary(stu!))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        testPerformence()
    }
    
    func testPerformence() {
        var json: NSDictionary = serializationJSON("Person.json") as! NSDictionary
        
        performenceRunFunction(10000) {
            autoreleasepool({ () -> () in
                var stu: Student? = self.manager.objectWithDictionary(json, cls: Student.self) as? Student
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
    
    func serializationJSON(filename: String) -> AnyObject? {
        if let fileURL = NSBundle.mainBundle().URLForResource(filename, withExtension: nil) {
            if let data = NSData(contentsOfURL: fileURL) {
                return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil)
            }
        }
        return nil
    }
}

