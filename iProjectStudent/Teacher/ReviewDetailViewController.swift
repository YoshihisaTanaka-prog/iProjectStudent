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

class ReviewDetailViewController: UIViewController {
    
    var isAbletoEdit: Bool!
    var review: Review?
    var teacherId: String!
    var studentId: String!
    var subjectName: String!
    
    private var isEditted: Bool = false
    private var numofBeforeScore: Int = 2
    private var numofAfterScore: Int = 2
    private var teacher: User!
    
    @IBOutlet var ratingScore: CosmosView!
    @IBOutlet var commentBox: UITextView!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var titleField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackGround(false, false)
        
        //描画の設定
        // スター半分の評価ができるようにする(本人だけが編集できるよう設定してある）
        ratingScore.settings.fillMode = .half
        if isAbletoEdit {
            // ビューから指を離した時に呼ばれる
            ratingScore.didFinishTouchingCosmos = { rating in
                // ratingでレートの値（Double）が受け取れる
                self.numofAfterScore = (rating * 2).i
                self.isEditted = true
            }

        } else{
            sendButton.setTitle("編集不可", for: .normal)
            ratingScore.settings.updateOnTouch = false
        }
        
        self.commentBox.isEditable = isAbletoEdit
        self.commentBox.isSelectable = isAbletoEdit
        self.titleField.isEnabled = isAbletoEdit
        
        if review != nil {
            numofBeforeScore = ( review!.score * 2 ).i
            ratingScore.rating = review!.score
            studentId = review!.studentId
            teacherId = review!.teacherId
            commentBox.text = review!.comment
            titleField.text = review!.title
        }
        
        let tUser = NCMBUser.query()
        tUser?.whereKeyExists("parameter")
        tUser?.whereKey("objectId", equalTo: teacherId)
        tUser?.findObjectsInBackground({ (result, error) in
            if( error == nil ){
                let user = result!.first! as! NCMBUser
                self.teacher = User(user)
            }
            else{
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
                self.navigationController?.popViewController(animated: true)
            }
        })
        setBackGround(true, true)
    }
    
    @IBAction func sendReview(){
        if (isAbletoEdit){
            if(review == nil && !isEditted){
                showOkAlert(title: "注意", message: "評価をしてください。")
            }
            else{
                var object: NCMBObject?
                if review == nil {
                    object = NCMBObject(className: "Review")
                }else{
                    object = review?.ncmb
                }
                object?.setObject(numofAfterScore, forKey: "score")
                object?.setObject(commentBox.text!, forKey: "comment")
                object?.setObject(titleField.text!, forKey: "z title")
                object?.setObject(self.studentId!, forKey: "studentId")
                object?.setObject(self.teacherId!, forKey: "teacherId")
                object?.saveInBackground({ (error) in
                    if error == nil{
                        if self.review == nil {
                            self.teacher.teacherParameter!.ncmb.setObject(self.numofAfterScore, forKey: self.subjectName + "TotalScore")
                            self.teacher.teacherParameter!.ncmb.setObject(1, forKey: self.subjectName + "TotalNum")
                            self.teacher.teacherParameter!.ncmb.saveInBackground({ (error) in
                                if error == nil{
                                    self.dismiss(animated: true, completion: nil)
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
