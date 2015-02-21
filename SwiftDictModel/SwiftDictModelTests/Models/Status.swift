//
//  Stuatus.swift
//  黑马微博
//
//  Created by 刘凡 on 15/2/20.
//  Copyright (c) 2015年 joyios. All rights reserved.
//

import UIKit

///  微博数据
class Status: NSObject, DictModelProtocol {
    ///  微博创建时间
    var created_at: NSDate?
    ///  微博ID
    var id: NSNumber?
    ///  微博信息内容
    var text: String?
    ///  微博来源
    var source: String?
    ///  缩略图片地址，没有时不返回此字段
    var thumbnail_pic: String?
    /// 微博配图数组，没有时此数组为空
    var pic_urls: [StatusPicURL]?
    ///  被转发的原微博信息字段，当该微博为转发微博时返回 详细
    var retweeted_status: Status?
    ///  转发数
    var reposts_count: NSNumber?
    ///  评论数
    var comments_count: NSNumber?
    ///  表态数
    var attitudes_count: NSNumber?
    
    static func customClassMapping() -> (Dictionary<String, String>?) {
        return ["pic_urls": "\(StatusPicURL.self)",
        "retweeted_status": "\(Status.self)"]
    }
}

///  微博图片地址
class StatusPicURL: NSObject {
    ///  缩略图片地址
    var thumbnail_pic: String?
}

///  微博用户
class StatusUser: NSObject {
    ///  用户UID
    var id: NSNumber?
    ///  用户昵称
    var screen_name: String?
    ///  友好显示名称
    var name: String?
    ///  性别，m：男、f：女、n：未知
    var gender: String?
    ///  用户头像地址（中图），50×50像素
    var profile_image_url: String?
    ///  用户头像地址（大图），180×180像素
    var avatar_large: String?
    ///  是否是微博认证用户，即加V用户，true：是，false：否
    var verified: Bool = false
}
