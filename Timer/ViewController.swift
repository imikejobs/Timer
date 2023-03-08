//
//  ViewController.swift
//  Timer
//
//  Created by Mike on 11.10.2022.
//  Copyright © 2022 iMikeJobs. All rights reserved.
//

import Cocoa
import MediaPlayer

class Audio {
    static let sharedInstance = Audio()
    var player : AVPlayer!
    func playSound() {
        let url = URL(fileURLWithPath: Bundle.main.path(forSoundResource: NSSound.Name("iphone_alarm.mp3"))!)
        player = AVPlayer(url: url)
        player.play()
    }
}

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        label.font = NSFont.monospacedDigitSystemFont(ofSize: 50, weight: .regular)
        
        slider.integerValue = saved
        time = saved
        showTime()
         

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var resetButton: NSButton!
    
    var timer: Timer?
    var time: Int = 0
    
    func showTime() {
        let min: Int = time / 60
        let sec: Int = time - (min * 60)
        
        var minStr = "\(min)"
        var secStr = "\(sec)"
        
        if min < 10 {
            minStr = "0" + minStr
        }
        if sec < 10 {
            secStr = "0" + secStr
        }
        label.stringValue = "\(minStr):\(secStr)"
    }
    
    
    @IBAction func sliderAction(_ sender: Any) {
        time = slider.integerValue
        saved = slider.integerValue
        showTime()
        
    }
    @IBAction func startAction(_ sender: Any) {
        self.slider.isEnabled = false
        
        if timer == nil {
            startButton.title = "Pause"
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
//                self.time = self.time - 1
                self.time -= 1
                self.slider.integerValue = self.time
                self.showTime()
                if self.time == 0 {
                    self.timer?.invalidate()
                    self.timer = nil
                    self.startButton.title = "Start"
                    self.slider.isEnabled = true
                    Audio.sharedInstance.playSound()
                    }
                }
            } else {
                startButton.title = "Countinue"
            
                timer?.invalidate()
                //self.slider.isEnabled = true
                timer = nil
            }
        }
        
    @IBAction func resetAction(_ sender: Any) {
        startButton.title = "Start"
        label.stringValue = "Setup timer"
        time = saved
        self.slider.isEnabled = true
        slider.integerValue = time
        timer?.invalidate()
        timer = nil
        showTime()
    }
    
    @IBAction func tenButton(_ sender: Any) {
        slider.integerValue = 600
        time = slider.integerValue
        showTime()
    }
    
    @IBAction func fifteenButton(_ sender: Any) {
        slider.integerValue = 900
        time = slider.integerValue
        showTime()
    }
    
    @IBAction func thirtyButton(_ sender: Any) {
        slider.integerValue = 1800
        time = slider.integerValue
        showTime()
    }
    
}

var saved: Int {
    get {
        let st = UserDefaults.standard.integer(forKey: "saved")
        if st == 0 {
            return 60
        } else {
            return st
        }
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "saved")
        UserDefaults.standard.synchronize()
    }
}
