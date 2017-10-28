//
//  ViewController.swift
//  Counter
//
//  Created by 刘勇刚 on 15/10/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var greenView: UIView!
    /// 秒表数字
    @IBOutlet weak var timeLabel: UILabel!
    
    private var timer: Timer!
    // 当前时间
    private var currentTime: Float = 0.0
    
    // 开始
    @IBAction func start() {
        if timer != nil {
            return
        }
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [unowned self] (timer) in
            self.currentTime += 0.1
            self.timeLabel.text = "\(self.currentTime)"
        })
    }
    // 暂停
    @IBAction func stop() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    // 重置
    @IBAction func reset() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        currentTime = 0.0
        timeLabel.text = "0.0"
    }
    
}

