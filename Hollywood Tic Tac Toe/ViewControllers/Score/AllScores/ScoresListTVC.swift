//
//  ScoresListTVC.swift
//  Hollywood Tic Tac Toe
//
//  Created by Wegile-Gunavardhan on 08/05/24.
//

import UIKit

class ScoresListTVC: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.addViewShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(dict: NSDictionary, indexPath: Int) {
        scoreLabel.text = "\(dict["score"] ?? "")"
        timeLabel.text = "\(dict["time"] ?? "")"
    }
}
