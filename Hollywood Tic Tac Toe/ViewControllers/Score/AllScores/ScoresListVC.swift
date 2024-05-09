//
//  ScoresListVC.swift
//  Hollywood Tic Tac Toe
//
//  Created by Wegile-Gunavardhan on 08/05/24.
//

import Foundation
import UIKit

class ScoresListVC: UIViewController {
        
    @IBOutlet weak var scoreTable: UITableView!
    
    var keyStore = NSUbiquitousKeyValueStore()
    var scoreDict = NSDictionary()
    var scoreArr = NSArray()
    @IBOutlet weak var headerLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseAppearance()
        scoreArr = scoreDict.value(forKey: "allScores") as! NSArray
        headerLabel.text = "All Scores of :\n\(scoreDict.value(forKey: "date") as! String)"
    }
}


// MARK: - Private
private extension ScoresListVC {
    func setupBaseAppearance() {
        scoreTable.rowHeight = UITableView.automaticDimension
        scoreTable.estimatedRowHeight = UITableView.automaticDimension
        scoreTable.contentInsetAdjustmentBehavior = .never
        scoreTable.register(UINib.init(nibName: "ScoresListTVC", bundle: nil), forCellReuseIdentifier: "ScoresListTVC")

    }
    
}

// MARK: - Action
extension ScoresListVC {
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ScoresListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scoreArr.count > 0 {
            return scoreArr.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoresListTVC") as! ScoresListTVC
        let dict = scoreArr[indexPath.row]
        cell.setupCell(dict: dict as! NSDictionary, indexPath: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
