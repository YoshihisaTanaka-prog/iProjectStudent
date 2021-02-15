//
//  SearchViewController.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/02/15.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    ここから性格の相性がいいかどうか判定するためのコード（メンテナンス性を重視）
    private let goodCompatibilityList: [[Int8]] = [
        [1, 0, 0, 1],
        [   1, 1, 0],
        [      1, 0],
        [         1]
    ]// 暫定的なものなので、実際に運用するまでにはこの行列(?)を要修正
    private func isGoodCompatibility(numOfMyGroupId: Int, numOfYourGroupId: Int) -> Bool?{
        //        引数が範囲外だった場合の例外処理
        if( numOfMyGroupId >= goodCompatibilityList.count ||
                numOfYourGroupId >= goodCompatibilityList.count ||
                numOfMyGroupId < 0 || numOfYourGroupId < 0 ){
            return nil
        }
        //        直感的な値からプログラム上の値に変換
        var i = 0
        var j = 0
        if(numOfMyGroupId < numOfYourGroupId){
            i = numOfMyGroupId
            j = numOfYourGroupId - numOfMyGroupId
        }
        else{
            i = numOfYourGroupId
            j = numOfMyGroupId - numOfYourGroupId
        }
        //        相性の良し悪しを返り値として返す（ちょっと乱雑なコードの書き方）
        if(goodCompatibilityList[i][j] == Int8(1)){
            return true
        }
        return false
    }
//    ここまで性格の相性がいいかどうか判定するためのコード
    
}
