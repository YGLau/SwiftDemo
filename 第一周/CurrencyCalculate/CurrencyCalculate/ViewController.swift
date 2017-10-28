//
//  ViewController.swift
//  CurrencyCalculate
//
//  Created by 刘勇刚 on 14/10/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate var textF: UITextField!
    fileprivate var tipLabel: UILabel!
    fileprivate var tipCountLabel: UILabel!
    fileprivate var totalCountLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSubviews()
    }
    
    private func initialSubviews() {
        
        textF = UITextField()
        textF.textAlignment = .right
        textF.font = UIFont.systemFont(ofSize: 30)
        textF.layer.borderColor = UIColor.lightGray.cgColor
        textF.placeholder = "$0.00"
        textF.layer.borderWidth = 0.5
        textF.keyboardType = .numberPad
        textF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textF)
        let top = NSLayoutConstraint(item: textF, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 80)
        let leading = NSLayoutConstraint(item: textF, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 30)
        let trailing = NSLayoutConstraint(item: textF, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -30)
        let height = NSLayoutConstraint(item: textF, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60)
        textF.addConstraint(height)
        view.addConstraints([top, leading, trailing])
        
        let topView = UIView()
        view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        let topViewT = NSLayoutConstraint(item: topView, attribute: .top, relatedBy: .equal, toItem: textF, attribute: .bottom, multiplier: 1.0, constant: 30)
        let leadingT = NSLayoutConstraint(item: topView, attribute: .leading, relatedBy: .equal, toItem: textF, attribute: .leading, multiplier: 1.0, constant: 0)
        let trailingT = NSLayoutConstraint(item: topView, attribute: .trailing, relatedBy: .equal, toItem: textF, attribute: .trailing, multiplier: 1.0, constant: 0)
        let heightT = NSLayoutConstraint(item: topView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        view.addConstraints([topViewT, leadingT, trailingT])
        topView.addConstraint(heightT)
        
        tipLabel = UILabel()
        topView.addSubview(tipLabel)
        tipLabel.text = "Tip"
        tipLabel.textAlignment = .center
        tipLabel.font = UIFont.systemFont(ofSize: 15)
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        let topViewL = NSLayoutConstraint(item: tipLabel, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .top, multiplier: 1.0, constant: 0)
        let leadingL = NSLayoutConstraint(item: tipLabel, attribute: .leading, relatedBy: .equal, toItem: topView, attribute: .leading, multiplier: 1.0, constant: 0)
        let widthL = NSLayoutConstraint(item: tipLabel, attribute: .width, relatedBy: .equal, toItem: topView, attribute: .width, multiplier: 0.5, constant: 0)
        let bottomL = NSLayoutConstraint(item: tipLabel, attribute: .bottom, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1.0, constant: 0)
        topView.addConstraints([topViewL, leadingL, widthL, bottomL])
        
        tipCountLabel = UILabel()
        topView.addSubview(tipCountLabel)
        tipCountLabel.textAlignment = .center
        tipCountLabel.font = UIFont.systemFont(ofSize: 15)
        tipCountLabel.translatesAutoresizingMaskIntoConstraints = false
        let topViewR = NSLayoutConstraint(item: tipCountLabel, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .top, multiplier: 1.0, constant: 0)
        let leadingR = NSLayoutConstraint(item: tipCountLabel, attribute: .trailing, relatedBy: .equal, toItem: topView, attribute: .trailing, multiplier: 1.0, constant: 0)
        let widthR = NSLayoutConstraint(item: tipCountLabel, attribute: .width, relatedBy: .equal, toItem: topView, attribute: .width, multiplier: 0.5, constant: 0)
        let bottomR = NSLayoutConstraint(item: tipCountLabel, attribute: .bottom, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1.0, constant: 0)
        topView.addConstraints([topViewR, leadingR, widthR, bottomR])
        
        
        
        let bottomView = UIView()
        view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        let bottomViewTop = NSLayoutConstraint(item: bottomView, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let bottomViewL = NSLayoutConstraint(item: bottomView, attribute: .leading, relatedBy: .equal, toItem: topView, attribute: .leading, multiplier: 1.0, constant: 0)
        let bottomViewT = NSLayoutConstraint(item: bottomView, attribute: .trailing, relatedBy: .equal, toItem: topView, attribute: .trailing, multiplier: 1.0, constant: 0)
        let bottomViewH = NSLayoutConstraint(item: bottomView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        view.addConstraints([bottomViewTop, bottomViewL, bottomViewT])
        bottomView.addConstraint(bottomViewH)
        
        let lLabel = UILabel()
        bottomView.addSubview(lLabel)
        lLabel.text = "Total"
        lLabel.textAlignment = .center
        lLabel.font = UIFont.systemFont(ofSize: 15)
        lLabel.translatesAutoresizingMaskIntoConstraints = false
        let lLabelT = NSLayoutConstraint(item: lLabel, attribute: .top, relatedBy: .equal, toItem: bottomView, attribute: .top, multiplier: 1.0, constant: 0)
        let lLabelL = NSLayoutConstraint(item: lLabel, attribute: .leading, relatedBy: .equal, toItem: bottomView, attribute: .leading, multiplier: 1.0, constant: 0)
        let lLabelR = NSLayoutConstraint(item: lLabel, attribute: .width, relatedBy: .equal, toItem: bottomView, attribute: .width, multiplier: 0.5, constant: 0)
        let lLabelB = NSLayoutConstraint(item: lLabel, attribute: .bottom, relatedBy: .equal, toItem: bottomView, attribute: .bottom, multiplier: 1.0, constant: 0)
        bottomView.addConstraints([lLabelT, lLabelL, lLabelR, lLabelB])
        
        totalCountLabel = UILabel()
        bottomView.addSubview(totalCountLabel)
        totalCountLabel.textAlignment = .center
        totalCountLabel.font = UIFont.systemFont(ofSize: 15)
        totalCountLabel.translatesAutoresizingMaskIntoConstraints = false
        let rLabelT = NSLayoutConstraint(item: totalCountLabel, attribute: .top, relatedBy: .equal, toItem: bottomView, attribute: .top, multiplier: 1.0, constant: 0)
        let rLabelL = NSLayoutConstraint(item: totalCountLabel, attribute: .trailing, relatedBy: .equal, toItem: bottomView, attribute: .trailing, multiplier: 1.0, constant: 0)
        let rLabelR = NSLayoutConstraint(item: totalCountLabel, attribute: .width, relatedBy: .equal, toItem: bottomView, attribute: .width, multiplier: 0.5, constant: 0)
        let rLabelB = NSLayoutConstraint(item: totalCountLabel, attribute: .bottom, relatedBy: .equal, toItem: bottomView, attribute: .bottom, multiplier: 1.0, constant: 0)
        bottomView.addConstraints([rLabelT, rLabelL, rLabelR, rLabelB])
        
        let slider = UISlider()
        view.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(valueChanged(slider:)), for: .valueChanged)
        let sliderTop = NSLayoutConstraint(item: slider, attribute: .top, relatedBy: .equal, toItem: bottomView, attribute: .bottom, multiplier: 1.0, constant: 20)
        let sliderL = NSLayoutConstraint(item: slider, attribute: .leading, relatedBy: .equal, toItem: bottomView, attribute: .leading, multiplier: 1.0, constant: 0)
        let sliderR = NSLayoutConstraint(item: slider, attribute: .trailing, relatedBy: .equal, toItem: bottomView, attribute: .trailing, multiplier: 1.0, constant: 0)
        view.addConstraints([sliderTop, sliderL, sliderR])
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textF.resignFirstResponder()
    }
    
    // slider value changed
    @objc func valueChanged(slider: UISlider) {
        textF.resignFirstResponder()
        guard let text = textF.text,
            let numF = Float(text) else { return }
        let percent = Int(slider.value * 100)
        let num = numF * slider.value
        tipLabel.text = "Tip(\(percent)%)"
        tipCountLabel.text = "\(num)";
        totalCountLabel.text = "\(numF + num)"
    }

}

