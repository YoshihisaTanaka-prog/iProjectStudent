//
//  YoubiCompatibility.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/03/20.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation

/*
 生徒の希望曜日が"TTTTTFF"だった場合に
 ["FFFFFFF","FFFFFFT","FFFFFTF","FFFFFTT"]というように、
 生徒の"T"の部分が全て"F"にっているという "必ずマッチしないスケジュール" を全て求めるためのクラス
 (∵ or検索を避けるためには条件を満たさない人を除外した方がラク。)
 */

class YoubiCompatibility{
    var badList: [String] = []
    
    init(_ myYoubiSchedule: String){
        setBadList(myYoubiSchedule)
    }
    
//    メイン関数。主にここでマッチしない曜日状態の配列を生成する。
    func setBadList(_ myYoubiSchedule: String) {
//        初めに空にして後から追加していく。
        badList = []
//        "T"でも"F"でもいい部分が何番目なのかを探し、「ignoreInts」変数に保存する。
        let ignoreInts = getIgnoreInts(myYoubiSchedule: myYoubiSchedule)
//        badListの長さである 2^(ignoreInts.count) の値を計算
        var patern = 1
        if(ignoreInts != []){
            for _ in 0..<ignoreInts.count {
                patern += patern
            }
        }
        
        for i in 0..<patern {
            
            var bads = ["F","F","F","F","F","F","F"]  //  生徒の希望のうち"T"の部分は上書きしないので初期値は7個全て"F"にしておきます。
//            どうすればいい感じに上書きができるのか考えてみてください。　ヒント：getIgnoreStrings(i,ignoreInts.count)とignoreIntsを使います。
            
            for j in 0..<ignoreInts.count {
                bads[ignoreInts[j]] = getIgnoreStrings(i,ignoreInts.count)[j]
            }
//            badsの各要素を結合し、一つの文字列badにする。
            var bad = ""
            for b in bads {
                bad += b
            }
            badList.append(bad)
        }
    }
    
//    "T"でも"F"でもいいのが何番目かを探す関数
    private func getIgnoreInts(myYoubiSchedule: String) -> [Int]{
        var ret: [Int] = []
        // String型.sArrayで１文字ずつに分割できる（ように「Extensions.swift」で設定した。）
        let sArray = myYoubiSchedule.sArray
        for i in 0..<sArray.count {
            if sArray[i] == "F" {
                ret.append(i)
            }
        }
        return ret
    }
    
    
/*
    Int型の ignoreIfd の値を代入すると length文字のほぼ2進数表示の文字列（0->"F", 1->"T"に変換されている）を１文字毎に区切った文字列が返り値となる関数。
    例：
     getIgnoreStrings(4,3)->["T","F","F"] (4は2進数表示で100)
     getIgnoreStrings(21,5)->["T","F","T","F","T"] (21は2進数表示で10101) (計算をミスってたらごめん)
*/
    private func getIgnoreStrings(_ ignoreId: Int, _ length: Int) -> [String]{
        var ret: [String] = []
        var keta = 1
        for _ in 0..<length {
//            Int型 / Int型 の計算結果はInt型となり、小数点以下は切り捨てられることに注意する。　　　　　<--------------------------どの言語でも起こるので覚えておいた方がいいかも。
            if (ignoreId/keta) % 2 == 0 {
                ret.insert("F", at: 0)
            }
            else{
                ret.insert("T", at: 0)
            }
            keta += keta
        }
        return ret
    }
}
