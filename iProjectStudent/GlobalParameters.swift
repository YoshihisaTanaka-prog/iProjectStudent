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

//営業時間を設定するための変数
let businessHoursG = [
    TimeRange(first: 16, last: 22), // 月曜日の営業時間
    TimeRange(first: 16, last: 22), // 火曜日の営業時間
    TimeRange(first: 16, last: 22), // 水曜日の営業時間
    TimeRange(first: 16, last: 22), // 木曜日の営業時間
    TimeRange(first: 16, last: 22), // 金曜日の営業時間
    TimeRange(first: 9, last: 22),  // 土曜日の営業時間
    TimeRange(first: 9, last: 22)   // 日曜日・祝日の営業時間
]

//ユーザー画像を保存するための変数

//フォロー中などのユーザリストを保存するための変数
var blockedUserIdListG = [String]()
var followUserListG = [User]()
var favoriteUserListG = [User]()
var waitingUserListG = [User]()

//ログインしているのかを判定するための変数
var isLogInG: Bool = false

var currentUserG: User!

//デザイン用の色を保存する定数
let dColor = OriginalCollor()

let token = "fN4BnkumjMvnbZd47gFLYL7JpVn283eaZwxEpT8NYyhYMPUaRDzR3dQZxTUT2eQYz7gqG9UMjAm8VaM26fhH7ueN7fJbXPsfCpM8"

let pickerLabelG = PickerLabel()

var cachedScheduleG = [String: Schedule]()
var cachedLectureG = [String: Lecture]()
var myScheduleG = Schedules()
var mixedScheduleG = Schedules()

//授業ページに自動遷移するための変数
var lectureTimeListG = [LectureTimeObject]()
var lectureCheckTimerG: Timer?
var timeIntervalG = 0.0
var isAbleToStartTimerG = true
var currentVC: UIViewController?
var today = Date()

//チャット関連
var chatRoomsG = [ChatRoom]()
var cachedJoinedTimeG:[String: Date] = [:]
