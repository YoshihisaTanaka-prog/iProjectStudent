//
//  GlobalParameters.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/02/18.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import UIKit
import NCMB

//ユーザー画像を保存するための変数
var userImagesCacheG: [String:UIImage] = [:]

//フォロー中のユーザリストを保存するための変数
var followUserListG: [User] = []

//ブロック中のユーザーリストを保存するための変数
var blockUserListG: [User] = []

//ログインしているのかを判定するための変数
var isLogInG: Bool = false

var currentUserG: User!

//デザイン用の色を保存する定数
let dColor = OriginalCollor()

let token = "fN4BnkumjMvnbZd47gFLYL7JpVn283eaZwxEpT8NYyhYMPUaRDzR3dQZxTUT2eQYz7gqG9UMjAm8VaM26fhH7ueN7fJbXPsfCpM8"

let pickerLabelG = PickerLabel()
