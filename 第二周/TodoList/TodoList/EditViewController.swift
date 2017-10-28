//
//  EditViewController.swift
//  TodoList
//
//  Created by 刘勇刚 on 25/10/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    /// 记录当前选中的按钮
    private var selectedBtn: UIButton?
    private var textFiled: UITextField!
    /// 日期
    private var dateStr: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Edit"
        
        let margin: CGFloat = 10.0
        for i in 0 ..< 4 {
            let btn = UIButton(type: .custom)
            let w = (UIScreen.main.bounds.size.width - margin * 5) / 4
            let h = w
            btn.frame = CGRect(x: CGFloat(i) * (w + margin) + margin, y: 100, width: w, height: h)
            btn.tag = i
            btn.layer.cornerRadius = w * 0.5
            btn.layer.masksToBounds = true
            btn.layer.borderWidth = 0.5
            btn.layer.borderColor = UIColor.green.cgColor
            btn.setImage(UIImage(named: "l\(i + 2)"), for: .normal)
            let image = UIImage(named: "l\(i + 2)")
            btn.setImage(image?.withRenderingMode(.alwaysTemplate), for: .selected)
            btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
            view.addSubview(btn)
        }
        
        let titlelabel = UILabel(frame: CGRect(x: 10, y: 250, width: 80, height: 20))
        titlelabel.font = UIFont.systemFont(ofSize: 14.0)
        titlelabel.text = "Todo Title:"
        view.addSubview(titlelabel)
        
        textFiled = UITextField(frame: CGRect(x: 90, y: 245, width: UIScreen.main.bounds.size.width - 90 - 10, height: 30))
        textFiled.layer.borderWidth = 0.5
        textFiled.layer.borderColor = UIColor.black.withAlphaComponent(0.8).cgColor
        textFiled.layer.cornerRadius = 5
        textFiled.layer.masksToBounds = true
        textFiled.delegate = self
        view.addSubview(textFiled)
        
        let doneBtn = UIButton(type: .custom)
        doneBtn.setTitle("Done", for: .normal)
        doneBtn.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        doneBtn.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        doneBtn.setTitleColor(.blue, for: .normal)
        doneBtn.layer.position = CGPoint(x: UIScreen.main.bounds.size.width * 0.5, y: UIScreen.main.bounds.size.height * 0.5 + 20)
        doneBtn.addTarget(self, action: #selector(doneBtnClick), for: .touchUpInside)
        view.addSubview(doneBtn)
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 200))
        datePicker.locale = Locale.init(identifier: "zh")
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        view.addSubview(datePicker)
        
    }
    
    
    @objc private func btnClick(btn: UIButton) {
        
        selectedBtn?.isSelected = false
        btn.isSelected = true
        selectedBtn = btn
        
    }
    
    @objc private func valueChanged(datePicker: UIDatePicker) {
        
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        dateStr = fmt.string(from: datePicker.date)
    }
    
    @objc private func doneBtnClick() {
        
        // 2.传值
        let vc = navigationController?.childViewControllers[0] as! ViewController
        if let btnCallback = vc.doneBtnCallback,
            let text = textFiled.text,
            let selectedBtn = selectedBtn,
            let date = dateStr {
            btnCallback("l\(selectedBtn.tag + 2)", date, text)
        }
        // 1.关闭
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textFiled.resignFirstResponder()
    }

}

extension EditViewController: UITextFieldDelegate {
    
}
