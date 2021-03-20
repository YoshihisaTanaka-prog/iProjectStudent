//
//  GoodCompatibility.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/03/20.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation

class SpiritCompatibility{
    //  相性の良し悪しを定義する行列 (相性がいい場合true)
    let list: [[Bool]] = [
        //            0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15
        /*  0 */ [ true],   //|      |      |      |      |      |      |      |      |      |      |      |      |      |      |    0
        /*  1 */ [ true,  true],   //|      |      |      |      |      |      |      |      |      |      |      |      |      |    1
        /*  2 */ [ true,  true,  true],   //|      |      |      |      |      |      |      |      |      |      |      |      |    2
        /*  3 */ [ true,  true,  true,  true],   //|      |      |      |      |      |      |      |      |      |      |      |    3
        /*  4 */ [ true,  true,  true,  true,  true],   //|      |      |      |      |      |      |      |      |      |      |    4
        /*  5 */ [ true,  true,  true,  true,  true,  true],   //|      |      |      |      |      |      |      |      |      |    5
        /*  6 */ [ true,  true,  true,  true,  true,  true,  true],   //|      |      |      |      |      |      |      |      |    6
        /*  7 */ [ true,  true,  true,  true,  true,  true,  true,  true],   //|      |      |      |      |      |      |      |    7
        /*  8 */ [ true,  true,  true,  true,  true,  true,  true,  true,  true],   //|      |      |      |      |      |      |    8
        /*  9 */ [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true],   //|      |      |      |      |      |    9
        /* 10 */ [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],   //|      |      |      |      |   10
        /* 11 */ [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],   //|      |      |      |   11
        /* 12 */ [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],   //|      |      |   12
        /* 13 */ [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],   //|      |   13
        /* 14 */ [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],   //|   14
        /* 15 */ [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true]// 15
        //            0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
    ]
    
    //  相性の悪い性格Idのリストを取得するための関数
    func getBad(_ mySpiritId: Int) -> [Int] {
        //  性格Idが0−15の範囲内の場合
        if (mySpiritId >= 0 && mySpiritId < 16) {
            var ret: [Int] = []
            for i in 0..<16 {
                if !getBool(myId: mySpiritId, yourId: i) {
                    ret.append(i)
                }
            }
            return ret
        }
        return [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]  // 万が一性格Idの範囲外の値が入力された時に何も検索しないようにすべてのIdと性格が悪いことにしておく
    }
    
    //  getBad()用の補助関数
    private func getBool(myId: Int, yourId:Int) -> Bool{
        var i: Int!
        var j: Int!
        if myId < yourId {
            i = yourId
            j = myId
        }else{
            i = myId
            j = yourId
        }
        return list[i][j]
    }
}
