//
//  AlertExtensions.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/06/04.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

extension UIViewController{
    func showOkAlert(title: String, message: String) {
        showOkAlert(title: title, message: message) {}
    }
    
    func showOkAlert(title: String, message: String, okAction: @escaping () -> Void ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "OK", style: .default) { (action) in
            okAction()
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertOkAction)
        self.present(alertController, animated: true, completion: nil)
        print("AlertController is opened!!!!!!!!!!")
    }
    
    func showOkCancelAlert(title: String, message: String, okAction: @escaping () -> Void ,cancelAction: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "OK", style: .default) { (action) in
            okAction()
            alertController.dismiss(animated: true, completion: nil)
        }
        let alertCancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            cancelAction()
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertOkAction)
        alertController.addAction(alertCancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
