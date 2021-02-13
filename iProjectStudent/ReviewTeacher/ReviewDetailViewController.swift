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
    @IBOutlet var ratingScore: CosmosView!
    @IBOutlet var commentBox: UITextView!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var titleField: UITextField!
    
    var isAbletoEdit: Bool!
    var numofBeforeScore: Int = 2
    var numofAfterScore: Int = 2
    var review: ReviewTeacher?
    var teacherId: String?
    var studentId: String?
    var subjectName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //描画の設定
        
        // スター半分の評価ができるようにする(本人だけが編集できるよう設定してある）
        ratingScore.settings.fillMode = .half
        if isAbletoEdit {
            // ビューから指を離した時に呼ばれる
            ratingScore.didFinishTouchingCosmos = { rating in
                // ratingでレートの値（Double）が受け取れる
                self.numofAfterScore = (rating * 2).i
            }

        } else{
            sendButton.setTitle("編集不可", for: .normal)
            ratingScore.settings.updateOnTouch = false
        }
        
        if review != nil {
            numofBeforeScore = ( review!.score * 2 ).i
        }
        
        self.commentBox.isEditable = isAbletoEdit
        self.titleField.isEnabled = isAbletoEdit
        
    }
    
    @IBAction func sendReview(){
        if isAbletoEdit{
            var object: NCMBObject?
            if review == nil {
                object = NCMBObject(className: "Review",objectId: self.review!.objectId)
            }else{
                object = NCMBObject(className: "Review")
            }
            object?.setObject(numofAfterScore, forKey: "Reviewscore")
            object?.setObject(commentBox.text!, forKey: "Reviewcomment")
            object?.setObject(titleField.text!, forKey: "Reviewtitle")
            object?.setObject(self.studentId!, forKey: "studentId")
            object?.setObject(self.teacherId!, forKey: "teacherId")
            object?.saveInBackground({ (error) in
                if error == nil{
                    if self.review == nil {
                        let object2 = NCMBObject(className: "TeacherParameter")
                        object2?.setObject(self.numofAfterScore, forKey: self.subjectName + "AverageScore")
                        object2?.setObject(self.numofAfterScore, forKey: self.subjectName + "TotalScore")
                        object2?.setObject(1, forKey: self.subjectName + "TotalNum")
                        object2?.saveInBackground({ (error) in
                            if error == nil{
                                self.dismiss(animated: true, completion: nil)
                            }
                            else{
                                self.showOkAlert(title: "Error", message: error!.localizedDescription)
                            }
                        })
                    }else{
                        let object2 = NCMBObject(className: "TeacherParameter")
                        object2?.setObject(self.numofAfterScore, forKey: self.subjectName + "AverageScore")
                        object2?.setObject(self.numofAfterScore, forKey: self.subjectName + "TotalScore")
                        object2?.setObject(1, forKey: self.subjectName + "TotalNum")
                        object2?.saveInBackground({ (error) in
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
