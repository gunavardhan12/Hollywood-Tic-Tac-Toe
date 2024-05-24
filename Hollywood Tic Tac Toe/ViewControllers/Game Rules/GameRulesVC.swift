//
//  GameRulesVC.swift
//  Hollywood Tic Tac Toe
//
//  Created by Wegile-Gunavardhan on 07/05/24.
//

import UIKit

class GameRulesVC: UIViewController {
    @IBOutlet weak var rulesText:UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBaseAppearance()
        rulesText.text = """
Objective:
The objective of the Finding Numbers game is to find and click on all displayed numbers within the given time limit.

Gameplay:
A 4x4 grid containing 16 numbers will be displayed.
At each interval (15 seconds, 30 seconds, etc.), a single random number will be shown on the grid.
You need to click on the displayed number to make it disappear.
The game continues until all 16 numbers have been clicked, or the timer runs out.
Winning:

You win the game if you successfully click on all 16 numbers before the timer expires.

Time Limits:
The game will offer progressively increasing time limits, starting from 15 seconds and potentially going up to 90 seconds (depending on your implementation).

Scoring:
The scoring system for this game is not yet defined. Here are some options to consider:
Points per number: Award a fixed number of points for each clicked number (e.g., 1 point per number).
Bonus for faster completion: Grant bonus points for completing the game under a certain time threshold (e.g., additional points for finishing within half the time limit).
Time-based scoring: Assign a higher score based on the remaining time when all numbers are clicked (e.g., more points for finishing with more time remaining).
"""
    }
}

// MARK: - Private
private extension GameRulesVC {
    
    func setupBaseAppearance() {
        self.navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - Action
private extension GameRulesVC {
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
