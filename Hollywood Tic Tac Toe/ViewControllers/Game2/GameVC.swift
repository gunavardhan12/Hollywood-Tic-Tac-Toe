//
//  GameVC.swift
//  Hollywood Tic Tac Toe
//
//  Created by Wegile-Gunavardhan on 09/05/24.
//

import UIKit

class GameVC: UIViewController {
    var timer = Timer()
    var totalTime = 30
    @IBOutlet weak var numberLabel:UILabel!
    @IBOutlet weak var timerLabel:UILabel!
    @IBOutlet weak var a1:UIButton!
    @IBOutlet weak var a2:UIButton!
    @IBOutlet weak var a3:UIButton!
    @IBOutlet weak var a4:UIButton!
    @IBOutlet weak var b1:UIButton!
    @IBOutlet weak var b2:UIButton!
    @IBOutlet weak var b3:UIButton!
    @IBOutlet weak var b4:UIButton!
    @IBOutlet weak var c1:UIButton!
    @IBOutlet weak var c2:UIButton!
    @IBOutlet weak var c3:UIButton!
    @IBOutlet weak var c4:UIButton!
    @IBOutlet weak var d1:UIButton!
    @IBOutlet weak var d2:UIButton!
    @IBOutlet weak var d3:UIButton!
    @IBOutlet weak var d4:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
    }
    @objc func startTimer(){
        timerLabel.text = self.timeFormatted(self.totalTime)
        if totalTime != 0{
            totalTime -= 1
        }
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

}

extension GameVC{
    @IBAction func ButtonTapped(_ sender: UIButton){
        sender.isHidden = true
    }
}
