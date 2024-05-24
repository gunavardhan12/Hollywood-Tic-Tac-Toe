//
//  TicTacToeGameVC.swift
//  Hollywood Tic Tac Toe
//
//  Created by Wegile-Gunavardhan on 07/05/24.
//
import UIKit

class TicTacToeGameVC: UIViewController {
    var keyStore = NSUbiquitousKeyValueStore()
    var score = "0"
    enum Turn{
        case user
        case system
    }
    let winningPatterns: [[Int]] = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]
        ]
    var currentPlayer: Turn = .user
    var userSymbol: String = ""
    var systemSymbol: String = ""
    var board = [UIButton]()
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBoard()
        startGame()
    }
    func startGame() {
        currentPlayer = Bool.random() ? .user : .system
        userSymbol = Bool.random() ? "X" : "O"
        systemSymbol = userSymbol == "X" ? "O" : "X"
        if currentPlayer == .user {
            turnLabel.text = "Your turn (\(userSymbol))"
        } else {
            turnLabel.text = "System's turn (\(systemSymbol))"
            systemMove()
        }
    }
    func initBoard(){
        board.append(a1)
        board.append(a2)
        board.append(a3)
        board.append(b1)
        board.append(b2)
        board.append(b3)
        board.append(c1)
        board.append(c2)
        board.append(c3)
    }
    func fullBoard()->Bool{
        for button in board{
            if(button.title(for: .normal) == nil){
                return false
            }
        }
        return true
    }
    @IBAction func boardTapAction(_ sender: UIButton) {
        if currentPlayer == .user {
            if sender.title(for: .normal) == nil {
                sender.setTitle(userSymbol, for: .normal)
                sender.setTitleColor(.black, for: .normal)
                sender.isEnabled = false
                checkForWinOrDraw()
                if !checkForWin(player: userSymbol) && !fullBoard() {
                    currentPlayer = .system
                    turnLabel.text = "System's turn (\(systemSymbol))"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.systemMove()
                    }
                }
            }
        }
    }
    func systemMove() {
        if let winningMove = findWinningMove(for: systemSymbol) {
            addToBoard(winningMove)
            checkForWinOrDraw()
            return
        }
        
        if let blockingMove = findWinningMove(for: userSymbol) {
            addToBoard(blockingMove)
            checkForWinOrDraw()
            return
        }
        
        
        let availableButtons = board.filter { $0.title(for: .normal) == nil }
        if let randomButton = availableButtons.randomElement() {
            addToBoard(randomButton)
            checkForWinOrDraw()
        }
    }
    func findWinningMove(for playerSymbol: String) -> UIButton? {
        let playerMoves = board.enumerated().compactMap { index, button in
            button.title(for: .normal) == playerSymbol ? index : nil
        }
        
        for pattern in winningPatterns {
            let intersection = Set(pattern).intersection(playerMoves)
            if intersection.count == 2 {
                let winningPosition = Set(pattern).subtracting(intersection).first!
                if board[winningPosition].title(for: .normal) == nil {
                    return board[winningPosition]
                }
            }
        }
        
        return nil
    }
    func thisSymbul(_ button:UIButton,_ symbol: String) ->Bool{
        return button.title(for: .normal) == symbol
    }
    func resultAlert(title:String){
        let alert = UIAlertController(title: title, message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Reset", style: .default, handler: {(_)in
            self.resetBoard()
        } ))
        self.present(alert, animated: true)
    }
    func resetBoard(){
        for button in board{
            button.setTitle(nil, for: .normal)
            button.isEnabled = true
        }
        startGame()
    }
    func addToBoard(_ sender: UIButton){
        if(sender.title(for: .normal) == nil){
            sender.setTitle(systemSymbol, for: .normal)
            sender.isEnabled = false
            sender.setTitleColor(.black,for: .normal)
            currentPlayer = .user
            turnLabel.text = "Your turn (\(userSymbol))"
        }
    }
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func checkForWinOrDraw() {
        
        if checkForWin(player: userSymbol) {
            showResult(message: "You win!")
            score = "100"
            pref.currentScore = score
            saveScoreValue()
        } else if checkForWin(player: systemSymbol) {
            showResult(message: "System wins!")
                score = "-50"
            pref.currentScore = score
            saveScoreValue()
        } else if fullBoard() {
            showResult(message: "It's a draw!")
        }
        
    }
    
    func checkForWin(player: String) -> Bool {
        let winPatterns: Set<Set<Int>> = [
            [0,1,2], [3,4,5], [6,7,8],
            [0,3,6], [1,4,7], [2,5,8],
            [0,4,8], [2,4,6]
        ]
        
        let playerMoves = board.enumerated().compactMap { index, button in
            button.title(for: .normal) == player ? index : nil
        }
        let playerPositions = Set(playerMoves)
        
        for pattern in winPatterns {
            if pattern.isSubset(of: playerPositions) {
                return true
            }
        }
        
        return false
    }
    
    func showResult(message: String) {
        let alert = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.resetBoard()
        }))
        present(alert, animated: true)
    }
    func saveScoreValue() {
        let date = Date().toString(format: "dd-MM-yyyy")
        let time = Date().toString(format: "HH:mm")
        
        if let appleId = keyStore.string(forKey: "appleId") {
            if appleId == pref.userProfileModel.appleId {
                if let scoreArr = keyStore.array(forKey: "savedScore") {
                    if scoreArr.count > 0 {
                        let arr = NSMutableArray(array: scoreArr)
                        var isToday = true
                        var index = 0
                        for dict in scoreArr {
                            let dictScore = (dict as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            let scoreDate = "\(dictScore["date"] ?? "")"
                            if scoreDate == date {
                                isToday = false
                                let scoreValue = "\(dictScore["finalScore"] ?? "")"
                                let scoreVal = Int(scoreValue) ?? 0
                                let currentScore = Int(score) ?? 0
                                var finalScore = ""
                                if score == "JACKPOT" {
                                    finalScore = "\(scoreVal - 100)"
                                } else {
                                    finalScore = "\(scoreVal + currentScore)"
                                    //finalScore = "\(score)"
                                }
                                let arrAllScore = (((dict as! NSDictionary).object(forKey: "allScores")) as! NSArray).mutableCopy() as! NSMutableArray
                                
                                let currentDict = NSMutableDictionary()
                                currentDict["score"] = currentScore
                                currentDict["time"] = time
                                arrAllScore.add(currentDict)
                                dictScore["allScores"] = arrAllScore
                                
                                dictScore["finalScore"] = finalScore
                                pref.finalScore = finalScore
                                print(pref.finalScore)
                                arr.replaceObject(at: index, with: dictScore)
                                saveScoreArrayData(arr: arr)
                                break
                            }
                            index = index + 1
                        }
                        if isToday {
                        
                            let dictAllScroe = NSMutableDictionary()
                            dictAllScroe["score"] = score
                            dictAllScroe["time"] = time
                            let ArrAllScore = NSMutableArray()
                            ArrAllScore.add(dictAllScroe)
                            
                            
                            let dictCurrent = NSMutableDictionary()
                            dictCurrent["finalScore"] = score
                            dictCurrent["date"] = date
                            dictCurrent["allScores"] = ArrAllScore
                            
                            arr.add(dictCurrent)
                            saveScoreArrayData(arr: arr)
                        }
                    }else {
                        saveScoreData(scoreVal: score, dateVal: date, timeVal: time)
                    }
                }else {
                    saveScoreData(scoreVal: score, dateVal: date, timeVal: time)
                }
            }else {
                saveScoreData(scoreVal: score, dateVal: date, timeVal: time)
            }
        }else {
            saveScoreData(scoreVal: score, dateVal: date, timeVal: time)
        }
        keyStore.synchronize()
    }
    
    func saveScoreData(scoreVal: String, dateVal: String, timeVal: String) {
        let dictAllScroe = NSMutableDictionary()
        dictAllScroe["score"] = scoreVal
        dictAllScroe["time"] = timeVal
        let ArrAllScore = NSMutableArray()
        ArrAllScore.add(dictAllScroe)
        
        
        let dictCurrent = NSMutableDictionary()
        dictCurrent["finalScore"] = scoreVal
        dictCurrent["date"] = dateVal
        dictCurrent["allScores"] = ArrAllScore
        
        let arrSave = NSMutableArray()
        arrSave.add(dictCurrent)
        
        keyStore.set(arrSave, forKey: "savedScore")
    }
    
    func saveScoreArrayData(arr: NSMutableArray) {
        keyStore.set(arr, forKey: "savedScore")
    }
}

    
