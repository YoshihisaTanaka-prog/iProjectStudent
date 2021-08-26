//
//  EditUserPageViewController.swift
//  iProjectStudent
//
//  Created by Kaori Nakamura on 2/13/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB
import NYXImagesKit

class EditUserPageViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var userIdFuriganaTextField: UITextField!
    @IBOutlet var schoolTextField: UITextField!
    @IBOutlet var gradeTextField: UITextField!
    //@IBOutlet var emailTextField: UITextField!
    @IBOutlet var parentsEmailTextField: UITextField!
    //@IBOutlet var choiceTextField: UITextField!
    @IBOutlet var bunriPickerView1: UIPickerView!
    @IBOutlet var gradePickerView2: UIPickerView!
    @IBOutlet var introductionTextView: UITextView!
    @IBOutlet private var choicetableView: UITableView!

    private var imageName: String?
    var selected: String?
    let bunri = ["文理選択","文系","理系","その他"]
    let gradelist = ["1年生","2年生","3年生","その他"]
//    var youbiCheckBox: CheckBox!
//    let youbiList: [CheckBoxInput] = [
//        CheckBoxInput("月曜日"),
//        CheckBoxInput("火曜日"),
//        CheckBoxInput("水曜日"),
//        CheckBoxInput("木曜日"),
//        CheckBoxInput("金曜日"),
//        CheckBoxInput("土曜日", color: .blue),
//        CheckBoxInput("日曜日", color: .red)
//    ]
    var youbiCheckBoxList: [CheckBox] = []
    var youbiList_: [[CheckBoxInput]] = []
    let youbiAlertController = UIAlertController(title: "曜日を選んでください。", message: "", preferredStyle: .actionSheet)
    
    var choice = [[String]]()
    //var selectedchoice:
    private var selectedIndex: Int!
    var selectedchoice: [String]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackGround(true, true)
        
        //youbiCheckBox = CheckBox(youbiList)
        for i in 0..<7{
            youbiList_.append([])
            for j in businessHoursG[i].first..<businessHoursG[i].last{
                youbiList_[i].append(CheckBoxInput(j.s02+":00-"+(j+1).s02+":00", key: j.s02+":00"))
            }
        }
        
        for i in 0..<youbiList_.count{
            let youbiCheckBox = CheckBox(youbiList_[i])
            youbiCheckBox.setSelectedKey(currentUserG.youbiTimeList[i])
            youbiCheckBoxList.append(youbiCheckBox)
        }
        
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
        
        userIdTextField.delegate = self
        userIdFuriganaTextField.delegate = self
        schoolTextField.delegate = self
        gradeTextField.delegate = self
        //emailTextField.delegate = self
        parentsEmailTextField.delegate = self
        bunriPickerView1.delegate = self
        bunriPickerView1.dataSource = self
        bunriPickerView1.tag = 1
        gradePickerView2.delegate = self
        gradePickerView2.dataSource = self
        gradePickerView2.tag = 2
        //choiceTextField.delegate = self
        introductionTextView.delegate = self
        
        userIdTextField.text = currentUserG.userName
        //emailTextField.text = mailAddress_
        userIdFuriganaTextField.text = currentUserG.furigana
        schoolTextField.text = currentUserG.studentParameter?.schoolName
        gradeTextField.text = currentUserG.grade
        introductionTextView.text = currentUserG.introduction
        bunriPickerView1.selectRow(getSelectionNum(selesction: currentUserG.selection), inComponent: 0, animated: false)
        gradePickerView2.selectRow(getSelectionNum(selesction: currentUserG.selection), inComponent: 0, animated: false)
        selected = currentUserG.selection
        //choiceTextField.text = (currentUserG.studentParameter?.choice.first ?? []).first ?? ""
        
        parentsEmailTextField.text = currentUserG.studentParameter?.parentEmailAdress
        
        userImageView.image = userImagesCacheG[currentUserG.userId] ?? UIImage(named: "studentNoImage.png")
        
        //youbiCheckBox.setSelection(currentUserG.studentParameter?.youbi ?? "")
        
        choicetableView.delegate = self
        choicetableView.dataSource = self
        choicetableView.tableFooterView = UIView()
        choicetableView.rowHeight = 44.f
        
        let nib = UINib(nibName: "ChoiceTableViewCell", bundle: Bundle.main)
        choicetableView.register(nib, forCellReuseIdentifier: "Cell")

        setBackGround(true, true)
        choice = currentUserG.studentParameter?.choice ?? []
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        choicetableView.reloadData()
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        let size = NSData(data: selectedImage.pngData()!).count.d
        let scale = Float(sqrt(min(1.d, 90000.d / size)))
        let resizedImage = selectedImage.scale(byFactor: scale)
        
        picker.dismiss(animated: true, completion: nil)
        
        let data = UIImage.pngData(resizedImage!)
        let file = NCMBFile.file(withName: NCMBUser.current()?.objectId, data: data()) as! NCMBFile
        file.saveInBackground { (error) in
            if error != nil{
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            } else {
                self.imageName = NCMBUser.current()!.objectId
                self.userImageView.image = selectedImage
                userImagesCacheG[NCMBUser.current()!.objectId] = resizedImage
            }
        } progressBlock: { (progress) in
            print(progress)
        }
    }
    

    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return bunri.count
        } else if pickerView.tag == 2 {
            return gradelist.count
        } else {
            return 0
        }
        
        
    }
    
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1 {
            return bunri[row]
        } else if pickerView.tag == 2 {
            return gradelist[row]
        } else {
            return "0"
        }
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row != 0 {
            
            if pickerView.tag == 1 {
                selected = bunri[row]
            } else if pickerView.tag == 2 {
                selected = gradelist[row]
            } else {
               
            }
            
    
        } else {
            selected = nil
        }
    }

    
    @IBAction func closeEditViewController(){
        if isChanged() == true {
            //はい，いいえで戻るか否か設定
            let alert = UIAlertController(title: "注意！", message: "変更内容は保存されませんが，よろしいですか？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                //OKボタンを押したときのアクション
                alert.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
            let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
                //キャンセルボタンを押したときのアクション
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    //上書きしたかどうかを判定する関数
    func isChanged () -> Bool {
        //currentUserG = 保存押すまで変わらないもの
        if userIdTextField.text != currentUserG.userName {
            return true
        }
        if userIdFuriganaTextField.text != currentUserG.furigana {
            return true
        }
        if schoolTextField.text != currentUserG.studentParameter?.schoolName {
            return true
        }
        if gradeTextField.text != currentUserG.grade {
            return true
        }
        if introductionTextView.text != currentUserG.introduction {
            return true
        }
        if parentsEmailTextField.text != currentUserG.studentParameter?.parentEmailAdress {
            return true
        }
//        if youbiCheckBox.selectionText != currentUserG.studentParameter?.youbi {
//            return true
//        }
        if selected != currentUserG.selection {
            return true
        }
        // 一旦この形式で。（志望校は1つとは限らない　＆　後々のアップデートで大学・学部・学科は分けられるようにしといた方がいいと思うので、二重配列として保存します。）
        // e.g. [[(第一志望の)大学名,学部,学科],[(第二志望の)大学名,学部,学科],...]
        if choice != currentUserG.studentParameter!.choice {
            return true
        }
        return false
    }
    
    @IBAction func saveUserInfo(){
        let param = currentUserG.studentParameter!.ncmb
        let im = param.object(forKey: "imageName")
        if im == nil{
            param.setObject(imageName, forKey: "imageName")
        }
        param.setObject(userIdTextField.text, forKey: "userName")
        param.setObject(userIdFuriganaTextField.text, forKey: "furigana")
        param.setObject(schoolTextField.text, forKey: "schoolName")
        param.setObject(gradeTextField.text, forKey: "grade")
        //param.setObject([[choiceTextField.text]], forKey: "choice")
        param.setObject(choice, forKey: "choice")
        param.setObject(parentsEmailTextField.text, forKey: "parentEmailAdress")
        if(selected != nil){
            param.setObject(selected!, forKey: "selection")
        }
        param.setObject(introductionTextView.text, forKey: "introduction")
        //param.setObject(youbiCheckBox.selectionText, forKey: "youbi")
        
        var youbi = ""
        let youbiList = ["Monday","Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        for i in 0..<youbiCheckBoxList.count {
            param.setObject(youbiCheckBoxList[i].selectedKeys, forKey: youbiList[i]+"Time")
            if youbiCheckBoxList[i].selectedKeys.count == 0 {
                youbi += "F"
            } else {
                youbi += "T"
            }
        }
        param.setObject(youbi, forKey: "youbi")
        
        
        param.saveInBackground { (error) in
            if error == nil{
                currentUserG = User(NCMBUser.current()!)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else{
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        }
    }
    
    @IBAction func selectImage() {
        let actionController = UIAlertController(title: "画像の選択", message: "選択して下さい", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (action) in
            //カメラ起動
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                self.showOkAlert(title: "エラー", message: "この機種ではカメラが使用出来ません。")
            }
        }
        let albumAction = UIAlertAction(title: "フォトライブラリ", style: .default) { (action) in
            //アルバム起動
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                self.showOkAlert(title: "エラー", message: "この機種ではフォトライブラリが使用出来ません。")
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            actionController.dismiss(animated: true, completion: nil)
        }
        actionController.addAction(cameraAction)
        actionController.addAction(albumAction)
        actionController.addAction(cancelAction)
        self.present(actionController, animated: true, completion: nil)
    }
    
//    @IBAction func selectWeek(){
//        let alertController = UIAlertController(title: "曜日を選んでください。", message: "\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
//        let alertOkAction = UIAlertAction(title: "選択完了", style: .default) { (action) in
//            self.youbiCheckBox.mainView.removeFromSuperview()
//            alertController.dismiss(animated: true, completion: nil)
//        }
//        alertController.view.addSubview(youbiCheckBox.mainView)
//        alertController.addAction(alertOkAction)
//        self.present(alertController, animated: true, completion: nil)
//    }
    
    @IBAction func selectWeek(){
        var alertOkActionList = [UIAlertAction(title: "終了", style: .cancel) { (action) in
            self.youbiAlertController.dismiss(animated: true, completion: nil)
        }]
        for i in 0..<youbiList_.count{
            alertOkActionList.append( makeAlertAction2(i) )
        }
        if youbiAlertController.actions.count == 0{
            for action in alertOkActionList{
                youbiAlertController.addAction(action)
            }
        }
        self.present(youbiAlertController, animated: true, completion: nil)
    }
    
    func makeAlertAction2(_ i : Int) -> UIAlertAction{
        let youbiList = ["月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日", "日曜日"]
        return UIAlertAction(title: youbiList[i], style: .default) { (action) in
            self.youbiAlertController.dismiss(animated: true, completion: nil)
            self.selectDetailYoubi(i)
        }
    }
    
    func selectDetailYoubi(_ i : Int) {
 
        let alertController = UIAlertController(title: "時間帯を選んでください。", message: youbiCheckBoxList[i].msg, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "他の曜日も設定する", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
            self.present(self.youbiAlertController, animated: true, completion: nil)
        }
        let action2 = UIAlertAction(title: "選択完了", style: .default) { (action) in
            self.youbiCheckBoxList[i].mainView.removeFromSuperview()
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.view.addSubview(youbiCheckBoxList[i].mainView)
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getSelectionNum(selesction: String?) -> Int {
        if(selesction == nil){
            return 0
        }
        let i = bunri.firstIndex(of: selesction!)
        if i == nil {
            return 0
        }
        return i!
    }
    
    //セルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choice.count + 1
    }
    
    //表示する内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //PlusCell
        if indexPath.row == choice.count{
            let cell = choicetableView.dequeueReusableCell(withIdentifier: "PlusCell")!
            cell.textLabel?.text = "+"
            cell.textLabel?.textAlignment = .center
            cell.setFontColor()
            return cell
        }
        let cell = choicetableView.dequeueReusableCell(withIdentifier: "Cell") as! ChoiceTableViewCell
        cell.choiceTextField.text = choice[indexPath.row][0]
        cell.choiceLabel.text = "第" + (indexPath.row + 1).s + "志望"
        cell.setFontColor()
        return cell
    }
    
    //タップされたときの処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == choice.count{
            choice.append([""])
        }
        else {
        selectedchoice = choice[indexPath.row]
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "Detail", sender: nil)
        }
        tableView.reloadData()
    }
    
    //セルの編集許可
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
     {
         return true
     }

     //スワイプしたセルを削除　※arrayNameは変数名に変更してください
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == UITableViewCell.EditingStyle.delete {
             choice.remove(at: indexPath.row)
             tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            tableView.reloadData()
         }
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let preVC = segue.destination as! DetailChoiceViewController
        preVC.selectedIndex = self.selectedIndex
        preVC.choice = selectedchoice
    }
    

    
}
