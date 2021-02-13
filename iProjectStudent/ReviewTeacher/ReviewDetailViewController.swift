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
    var numofBeforeScore: Double = 1
    var numofAfterScore: Double = 1
    var review: ReviewTeacher?
    var teacherId: String?
    var studentId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //描画の設定
        // ここからコメントの編集設定をする
        
        // スター半分の評価ができるようにする(本人だけが編集できるよう設定してある）
        ratingScore.settings.fillMode = .half
        if isAbletoEdit {
            // ビューから指を離した時に呼ばれる
            ratingScore.didFinishTouchingCosmos = { rating in
                // ratingでレートの値（Double）が受け取れる
                self.numofAfterScore = rating
            }

        } else{
            sendButton.setTitle("編集不可", for: .normal)
            ratingScore.settings.updateOnTouch = false
        }
        self.commentBox.isEditable = isAbletoEdit
        self.titleField.isEnabled = isAbletoEdit
        
    }
    
    @IBAction func sendReview(){
        if isAbletoEdit{
            var object: NCMBObject?
            if review != nil {
                object = NCMBObject(className: "Review")
            }else{
                object = NCMBObject(className: "Review",objectId: self.review!.objectId)
            }
            object?.setObject(numofAfterScore, forKey: "Reviewscore")
            object?.setObject(commentBox.text!, forKey: "Reviewcomment")
            object?.setObject(titleField.text!, forKey: "Reviewtitle")
            object?.setObject(self.studentId!, forKey: "studentId")
            object?.setObject(self.teacherId!, forKey: "teacherId")
            object?.saveInBackground({ (error) in
                if error == nil{
                    if self.review != nil {
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                }else{
                    self.showOkAlert(title:"エラー", message:error!.localizedDescription)
                }
            })
            
            let object2 = NCMBObject(className: "TeacherParameter")
            if review != nil {
                object2?.setObject(numofAfterScore, forKey: "averageScore")
                object2?.setObject((numofAfterScore * 2).i, forKey: "totalScore")
                object2?.setObject(1, forKey: "totalNum")
                object2?.saveInBackground({ _ in})
            }else{
                object2?.setObject(numofAfterScore, forKey: "averageScore")
                object2?.setObject((numofAfterScore * 2).i, forKey: "totalScore")
                object2?.setObject(1, forKey: "totalNum")
                object2?.saveInBackground({ _ in})
            }
            
        }
        
    }
    
    
}
