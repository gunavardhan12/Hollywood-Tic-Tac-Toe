//
//  ScoreVC.swift
//  Hollywood Tic Tac Toe
//
//  Created by Wegile-Gunavardhan on 08/05/24.
//

import UIKit

class ScoreVC: UIViewController {
        
    @IBOutlet weak var scoreTable: UITableView!
    
    var keyStore = NSUbiquitousKeyValueStore()
    var scoreArray = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseAppearance()
    }
}

// MARK: - Private
private extension ScoreVC {
    func setupBaseAppearance() {
        scoreTable.rowHeight = UITableView.automaticDimension
        scoreTable.estimatedRowHeight = UITableView.automaticDimension
        scoreTable.contentInsetAdjustmentBehavior = .never
        scoreTable.register(UINib.init(nibName: "ScoreTVC", bundle: nil), forCellReuseIdentifier: "ScoreTVC")
        if let appleId = keyStore.string(forKey: "appleId") {
            if appleId == pref.userProfileModel.appleId {
                if let scoreArr = keyStore.array(forKey: "savedScore") {
                    print("scoreArr: \(scoreArr.count)")
                    scoreArray = scoreArr as NSArray
                    if scoreArray.count > 0 {
                        let arr = scoreArray.reversed()
                        scoreArray = arr as NSArray
                    }
                }else {
                    print("no score")
                }
            }
        }
    }
}

// MARK: - Action
extension ScoreVC {
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ScoreVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scoreArray.count > 0 {
            return scoreArray.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreTVC") as! ScoreTVC
        let dict = scoreArray[indexPath.row]
        cell.setupCell(dict: dict as! NSDictionary, indexPath: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ScoresListVC") as! ScoresListVC
        vc.scoreDict = scoreArray[indexPath.row] as! NSDictionary
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

