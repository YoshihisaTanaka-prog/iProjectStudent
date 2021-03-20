//
//  YoubiCompatibility.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/03/20.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation

class YoubiCompatibility{
    var badList: [String] = []
    
    func setBadList(_ myYoubiSchedule: String) {
        badList = []
        let ignoreInts = getIgnoreInts(myYoubiSchedule: myYoubiSchedule)
        var patern = 1
        for _ in 0..<ignoreInts.count {
            patern += patern
        }
        for i in 0..<patern {
            var bads = ["F","F","F","F","F","F","F"]
            let ignoreStrings = getIgnoreStrings(i, ignoreInts.count)
            for j in 0..<ignoreStrings.count {
                bads[ignoreInts[j]] = ignoreStrings[j]
            }
            var bad = ""
            for b in bads {
                bad += b
            }
            badList.append(bad)
        }
    }
    
    private func getIgnoreInts(myYoubiSchedule: String) -> [Int]{
        var ret: [Int] = []
        let sArray = myYoubiSchedule.sArray
        for i in 0..<sArray.count {
            if sArray[i] == "F" {
                ret.append(i)
            }
        }
        return ret
    }
    
    private func getIgnoreStrings(_ ignoreId: Int, _ length: Int) -> [String]{
        var ret: [String] = []
        var keta = 1
        for _ in 0..<length {
            if (ignoreId/keta) % 2 == 0 {
                ret.append("F")
            }
            else{
                ret.append("T")
            }
            keta += keta
        }
        return ret
    }
}
