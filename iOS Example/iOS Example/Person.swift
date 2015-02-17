//
//  Person.swift
//  DictModel
//
//  Created by 刘凡 on 15/2/16.
//  Copyright (c) 2015年 joyios. All rights reserved.
//

import Foundation
import SwiftDictModel

class Person: NSObject {
    var name: String?
}

class Student: Person, DictModelProtocol {
    var school: String?
    var bag: Bag?
    
    static func customClassMapping() -> (Dictionary<String, String>?) {
        return ["bag": "\(Bag.self)"]
    }
}

class Bag: NSObject, DictModelProtocol {
    var bagName: String?
    var books: [Book]?

    static func customClassMapping() -> (Dictionary<String, String>?) {
        return ["books": "\(Book.self)"]
    }
}

class Book: NSObject {
    var bookName: String?
    var price: NSNumber?
}