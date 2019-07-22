//
//  WorkOutManData.swift
//  iHealthS
//
//  Created by Apple on 2019/4/6.
//  Copyright © 2019年 whitelok.com. All rights reserved.
//

import UIKit
import StoreKit

struct WorkOutManAction {
    static var progress: [String:[CGFloat]] =
        ["Elementary":[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        "Intermediate":[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        "Advanced":[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]
    static var actions: [String:Int] = ["a":5, "b":4, "c":3, "d":2, "e":2, "f":1, "g":2, "h":4, "i":2, "j":2, "k":4, "l":2, "m":2, "n":4, "o":2, "p":2, "q":2, "r":2]
    static var actionList: [String:[String]] =
        ["Elementary":["a","b","c","d","e","f","b","c","d","e","f"],
         "Intermediate":["a","g","j","h","c","i","f","g","j","g","j","h"],
         "Advanced":["k","l","m","n","e","i","f","o","i","p","q","r"]]
    static var actionName: [String:String] = ["a":"開合跳", "b":"站立腳踏車卷腹", "c":"爬山式", "d":"卷腹", "e":"仰臥交替腳跟接觸", "f":"平板撐體", "g":"仰臥起坐", "h":"扭曲式", "i":"腳跟朝天式", "j":"雙臂交叉緊縮式", "k":"曲腿轉體", "l":"反向捲腹", "m":"V字卷腹", "n":"仰臥交替抬腿", "o":"X型卷腹", "p":"左側捲腹", "q":"右側捲腹", "r":"V型上舉"]
    static var actionTime: [String:[Int]] =
        ["Elementary":[30,40,40,20,32,30,40,40,20,32,30],
        "Intermediate":[20,30,30,40,52,16,60,30,30,30,30,40],
        "Advanced":[12,16,20,40,60,16,60,30,30,30,30,30]]
}

enum WorkOutManType {
    case Elementary, Intermediate, Advanced
    
    var identifier: String {
        switch self {
        case .Elementary:
            return "Elementary"
        case .Intermediate:
            return "Intermediate"
        case .Advanced:
            return "Advanced"
        }
    }
    var totle: CGFloat {
        switch self {
        case .Elementary:
            return 11
        case .Intermediate:
            return 12
        case .Advanced:
            return 12
        }
    }
}
