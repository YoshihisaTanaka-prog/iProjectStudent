//
//  GlobalParameters.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/02/18.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import UIKit

//ユーザー画像を保存するための変数
var userImagesCacheG: [String:UIImage] = [:]

//フォロー中のユーザリストを保存するための変数
var followUserListG: [User] = []

//ブロック中のユーザーリストを保存するための変数
var blockUserListG: [User] = []

//ログインしているのかを判定するための変数
var isLogInG: Bool = false

//デザイン用の色を保存する定数
let dColor = OriginalCollor()


let pickerLabelG = PickerLabel()
