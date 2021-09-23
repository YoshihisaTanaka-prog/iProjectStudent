//
//  CommentTeacherViewController.swift
//  iProjectStudent
//
//  Created by user on 2021/02/10.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB
import Cosmos

class ReviewDetailViewController: UIViewController, UITextFieldDelegate {
    
    var isAbletoEdit: Bool!
    var lecture: Lecture?
    var review: Review?
    
    var isExistsNavigationbar = true
    var isExistingTabbar = true
    
    private var subjectName: String!
    private var student: User!
    private var teacher: User!
    private var isEditted: Bool = false
    private var numofBeforeScore: Int = 2
    private var numofAfterScore: Int = 2
    

    @IBOutlet private var userImageView: UIImageView?
    @IBOutlet private var userNameLabel: UILabel?
    @IBOutlet private var ratingScore: CosmosView!  //星
    @IBOutlet private var titleField: UITextField!  //タイトル
    @IBOutlet private var commentBox: UITextView!   //コメント
    @IBOutlet private var sendButton: UIButton!     //送信・通報ボタン

    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImageView?.layer.cornerRadius = 64.f
        
        titleField.delegate = self
        
        if review == nil || review!.student.userId == currentUserG.userId{
            isAbletoEdit = true
        } else {
            isAbletoEdit = false
        }
        
        //描画の設定
        // スター半分の評価ができるようにする(本人だけが編集できるよう設定してある）
        ratingScore.settings.fillMode = .half
        let ud = UserDefaults.standard
        if isAbletoEdit {
            userImageView?.image = ud.image(forKey: currentUserG.userId)
            userNameLabel?.text = currentUserG.userName
            // ビューから指を離した時に呼ばれる
            ratingScore.didFinishTouchingCosmos = { rating in
                // ratingでレートの値（Double）が受け取れる
                self.numofAfterScore = (rating * 2).i
                self.isEditted = true
            }

        } else{
            let student = review!.student
            userImageView?.image = ud.image(forKey: student.userId)
            userNameLabel?.text = student.userName
            sendButton.setTitle("通報", for: .normal)
            ratingScore.settings.updateOnTouch = false
        }
        
        self.commentBox.isEditable = isAbletoEdit
        self.commentBox.isSelectable = isAbletoEdit
        self.titleField.isEnabled = isAbletoEdit
        
        if review == nil {
            teacher = lecture!.teacher
            student = lecture!.student
            subjectName = lecture!.subject
        } else{
            numofBeforeScore = ( review!.score * 2 ).i
            ratingScore.rating = review!.score
            teacher = review!.teacher
            student = review!.student
            commentBox.text = review!.comment
            subjectName = review!.subject
            titleField.text = review!.title
        }
        
        setBackGround(isExistsNavigationbar, isExistingTabbar)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction private func tappedReport(){
        if !isAbletoEdit{
            showOkAlert(title: "通報", message: "このレビューを通報しますか？"){
                self.reportToRailsServer(className: "Review", objectId: self.review!.ncmb.objectId)
                if reportedDataG["Review"] == nil{
                    reportedDataG["Review"] = [self.review!.ncmb.objectId]
                } else{
                    reportedDataG["Review"]!.append(self.review!.ncmb.objectId)
                }
                NCMBUser.current().setObject(reportedDataG, forKey: "reportInfo")
                NCMBUser.current().saveInBackground { error in
                    if error == nil{
                        self.showOkAlert(title: "報告", message: "通報が完了しました。"){
                            self.blockUserAlert(user: self.review!.student)
                        }
                    } else {
                        self.showOkAlert(title: "Saving report infomation error", message: error!.localizedDescription)
                    }
                }
            }
        }
    }
    
    @IBAction private func sendReview(){
        if (isAbletoEdit){
            if(review == nil && !isEditted){
                showOkAlert(title: "注意", message: "評価をしてください。")
            } else if titleField.text!.count * commentBox.text!.count == 0 {
                showOkAlert(title: "注意", message: "タイトルと感想を記入してください。")
            } else{
                var object: NCMBObject?
                if review == nil {
                    object = NCMBObject(className: "Review")
                    object?.setObject(lecture!.subject, forKey: "subject")
                }else{
                    object = review?.ncmb
                }
                object?.setObject(numofAfterScore, forKey: "score")
                object?.setObject(commentBox.text!, forKey: "comment")
                object?.setObject(titleField.text!, forKey: "title")
                object?.setObject(self.student.userId, forKey: "studentId")
                object?.setObject(self.teacher.userId, forKey: "teacherId")
                object?.saveInBackground({ (error) in
                    if error == nil{
                        if self.review == nil {
                            self.teacher.teacherParameter!.ncmb.setObject(self.numofAfterScore, forKey: self.subjectName + "TotalScore")
                            self.teacher.teacherParameter!.ncmb.setObject(1, forKey: self.subjectName + "TotalNum")
                            self.teacher.teacherParameter!.ncmb.saveInBackground({ (error) in
                                if error == nil{
                                    let lectureObject = NCMBObject(className: "Lecture", objectId: self.lecture!.objectId)
                                    lectureObject?.setObject(object!.objectId, forKey: "reviewId")
                                    lectureObject?.saveInBackground({ error in
                                        if error == nil{
//                                            メイン画面へ
                                            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                                            let rootViewController = storyboard.instantiateViewController(identifier: "RootTabBarController")
                                            self.present(rootViewController, animated: true, completion: nil)
                                        } else{
                                            self.showOkAlert(title: "Error", message: error!.localizedDescription)
                                        }
                                    })
                                }
                                else{
                                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                                }
                            })
                        }else{
                            self.teacher.teacherParameter!.ncmb.setObject(self.numofAfterScore, forKey: self.subjectName + "TotalScore")
                            self.teacher.teacherParameter!.ncmb.setObject(1, forKey: self.subjectName + "TotalNum")
                            self.teacher.teacherParameter!.ncmb.saveInBackground({ (error) in
                                if error == nil{
                                    self.navigationController?.popViewController(animated: true)
                                }
                                else{
                                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                                }
                            })
                        }
                    }else{
                        self.showOkAlert(title:"Error", message:error!.localizedDescription)
                    }
                })
            }
        }
    }
    
}
