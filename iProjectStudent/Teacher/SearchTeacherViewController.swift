//
//  SearchTeacherViewController.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/02/23.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

class SearchTeacherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var pickerView: UIPickerView!
    var teachers = Teachers()
    var selectedSubject = "指導希望教科を選択"
    let subjectList = ["指導希望教科を選択","国語","数学","理科","社会","英語"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setBackGround(true, true)
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        // カスタムセルの登録
        let nib1 = UINib(nibName: "TeacherInfoTableViewCell", bundle: Bundle.main)
        // (「register(nib: UINib?, forCellReuseIdentifier: String)」を選ぶ。)
        tableView.register(nib1, forCellReuseIdentifier: "Cell1")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(teachers.count, 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if teachers.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.backgroundColor = .clear
            if(selectedSubject == "指導希望教科を選択"){
                cell.textLabel?.text = "教科を選択してください"
            }
            else{
                cell.textLabel?.text = "あなたの志望校に通う教師が\n見つかりませんでした。"
            }
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = dColor.font
            cell.textLabel?.textAlignment = .center
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! TeacherInfoTableViewCell
//            cell.averageScoreCosmosView.rating = teacher.teacherParameter
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if teachers.count != 0 {
            let storyboard = UIStoryboard(name: "Teacher", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController") as! UINavigationController
            let vc = rootViewController.viewControllers[0] as! TeacherInfoViewController
            vc.teacher = teachers.list[indexPath.row]
            vc.subject = selectedSubject
            self.present(rootViewController, animated: false, completion: nil)
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return subjectList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = PickerLabel(text: subjectList[row], pickerView.frame.width)
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSubject = subjectList[row]
        tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
