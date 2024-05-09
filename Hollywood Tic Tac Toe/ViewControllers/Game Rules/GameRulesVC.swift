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

1.Objective: 
    The objective of Tic Tac Toe is to place three of your marks (either "X" or "O") in a horizontal, vertical, or diagonal row on a 3x3 grid.
2.Turn-Based Gameplay: 
    Players take turns placing their marks on an empty cell of the grid. The game starts with one player placing their mark, followed by the other player placing their mark, and so on.
3.Winning Condition: 
    A player wins the game if they successfully place three of their marks in a horizontal, vertical, or diagonal row. If a player achieves this, they win the round and earn 100 points.
4.Draw Condition: 
    If all cells on the grid are filled and neither player has achieved a winning condition, the game is declared a draw or tie.
5.Scoring System:
    (i).If a player wins the round, they earn 100 points.
    (ii).If a player loses the round, they lose 50 points.
    (iii).If the game ends in a draw, neither player earns or loses any points.
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
