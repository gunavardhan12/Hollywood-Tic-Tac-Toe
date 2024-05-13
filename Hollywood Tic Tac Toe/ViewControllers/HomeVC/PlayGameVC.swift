//
//  PlayGameVC.swift
//  Hollywood Tic Tac Toe
//
//  Created by Wegile-Gunavardhan on 07/05/24.
//
import UIKit

class PlayGameVC: UIViewController {

    @IBOutlet weak var ticTacToeView: UIView!
    @IBOutlet weak var Game2View: UIView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Private
private extension PlayGameVC {
    
    func setupBaseAppearance() {
        setupNavigationBar()
        ticTacToeView.addViewShadow()
        ticTacToeView.roundCorners(corners:UIRectCorner.allCorners , radius: 10)
        Game2View.addViewShadow()
        Game2View.roundCorners(corners:UIRectCorner.allCorners , radius: 10)
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - Action
extension PlayGameVC {
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func ticTacToeBtn(_ sender: Any) {
        self.navigationController?.pushViewController(TicTacToeGameVC.view(from: .Main)!, animated: true)
    }
    @IBAction func Game2Btn(_ sender: Any) {
        self.navigationController?.pushViewController(GameVC.view(from: .Main)!, animated: true)
    }
}
