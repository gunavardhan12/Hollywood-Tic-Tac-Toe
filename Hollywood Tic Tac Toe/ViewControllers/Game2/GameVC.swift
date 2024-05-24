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
    var setTime = 30
    var ind: Int = 0
    var keyStore = NSUbiquitousKeyValueStore()
    var score = "0"
    var randomNumbers:[Int] = []
    var lastBtn:UIButton!
    var isGameInProgress = false
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
    var board = [UIButton]()
    private lazy var menu = UIMenu(children: elements)
    private lazy var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        let image = UIImage(systemName: "ellipsis.circle", withConfiguration: config)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.showsMenuAsPrimaryAction = true
        button.menu = menu
        return button
    }()
    private lazy var restart = UIAction(title: "Restart",image: UIImage(systemName: "arrow.circlepath"), attributes: [],state: .off, handler: {(_) in
        self.resetBtn()
    })
    private lazy var timerSettings: UIMenu = {
        return createDeferredMenu()
    }()

//    private lazy var elements: [UIMenuElement] = [restart,timerSettings]
    
    @IBOutlet weak var startTimerView:UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        startTimerView.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    @objc func viewTapped() {
        setupFunction()
        startTimerView.removeFromSuperview()
        isGameInProgress = true
        updateMenu()
        if !timer.isValid {
            startTimer()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
        }
    }
    func setupFunction(){
        numberLabel.isHidden = false
        timerLabel.isHidden = false
        initBoard()
        GenerateRandomNumbers()
    }
    @objc func startTimer(){
        if ind == 17 {
            timer.invalidate()
            lastBtn.isHidden = true
            showAlert(message: "Won")
            return
        }
        timerLabel.text = self.timeFormatted(self.totalTime)
        if totalTime != 0 {
            totalTime -= 1
        }else {
            timer.invalidate()
            showAlert(message: "Lost")
            return
        }
    }

    func showAlert(message: String){
        numberLabel.isHidden = true
        timerLabel.isHidden = true
        isGameInProgress = false
        updateMenu()
        gameScore(message: message);
        let alert = UIAlertController(title: "Result", message: message, preferredStyle: .alert)
//        let label = UILabel(frame: CGRect(x: 60, y: 45, width: 150, height: 50))
//        label.text = "Your score: " + gameScore()
//        alert.view.addSubview(label)
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: {(_)in
            self.resetBtn()
        }))
        alert.addAction(UIAlertAction(title: "Back", style: .default, handler: {(_)in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.editButtonItem.tintColor = UIColor.black
        present(alert, animated: true, completion: nil)
    }
    func gameScore(message: String){
        if message == "Won" {
            score = "100"
        }
        else if (message == "Lost"){
            score = "-50"
        }
        pref.currentScore = score
        saveScoreValue()
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    func initBoard(){
        board.append(a1)
        board.append(a2)
        board.append(a3)
        board.append(a4)
        board.append(b1)
        board.append(b2)
        board.append(b3)
        board.append(b4)
        board.append(c1)
        board.append(c2)
        board.append(c3)
        board.append(c4)
        board.append(d1)
        board.append(d2)
        board.append(d3)
        board.append(d4)
    }
}


extension GameVC{
    @IBAction func ButtonTapped(_ sender: UIButton){
        if sender.titleLabel?.text == numberLabel.text{
            sender.isHidden = true
            if ind < 16{
                numberLabel.text = "\(String(describing: randomNumbers[ind]))"
            }
            lastBtn = sender
            ind += 1
        }
    
    }
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func resetBtn(){
        board.removeAll()
        randomNumbers.removeAll()
        totalTime = setTime
//        timerLabel.text = "00:00"
        ind = 0
        setupFunction()
        resetButtons()
        if !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
        }
        isGameInProgress = true
        updateMenu()
    }
    func resetButtons(){
        for button in board{
            button.isHidden = false
        }
    }
}


extension GameVC{
    func GenerateRandomNumbers(){
        srand48(Int(Date().timeIntervalSince1970))
        
        var uniqueNumbers = Set<Int>()
        
        while uniqueNumbers.count < 16 {
            let randomNumber = Int.random(in: 1...99)
            uniqueNumbers.insert(randomNumber)
        }
        
        randomNumbers = Array(uniqueNumbers)
        AddButtonLabels()
    }
    func AddButtonLabels(){
        guard randomNumbers.count >= board.count else {
            print("Error: Insufficient random numbers to populate all buttons")
            return
        }
        randomNumbers.shuffle()
        print(randomNumbers)
        var i = 0
        for button in board{
            button.setTitle("\(randomNumbers[i])", for: .normal)
            i = i+1
        }
        randomNumbers.shuffle()
        numberLabel.text = "\(String(describing: randomNumbers[ind]))"
        ind += 1
    }
}
extension GameVC{
    private func createDeferredMenu() -> UIMenu {
        let fifteenSeconds = UIAction(title: "15 sec", image: nil, state: .off) { _ in
            self.setTimer(seconds: 15)
        }
        let thirtySeconds = UIAction(title: "30 sec", image: nil, state: .off) { _ in
            self.setTimer(seconds: 30)
        }
        let fortyFiveSeconds = UIAction(title: "45 sec", image: nil, state: .off) { _ in
            self.setTimer(seconds: 45)
        }
        let sixtySeconds = UIAction(title: "60 sec", image: nil, state: .off) { _ in
            self.setTimer(seconds: 60)
        }
        let seventyFiveSeconds = UIAction(title: "75 sec", image: nil, state: .off) { _ in
            self.setTimer(seconds: 75)
        }
        let ninetySeconds = UIAction(title: "90 sec", image: nil, state: .off) { _ in
            self.setTimer(seconds: 90)
        }

        let timeOptions = UIMenu(title: "Timer Options", children: [fifteenSeconds, thirtySeconds, fortyFiveSeconds, sixtySeconds, seventyFiveSeconds, ninetySeconds])
        
        return timeOptions
    }
    func setTimer(seconds: Int) {
        timer.invalidate()
        totalTime = seconds
        setTime = seconds
    }
    private var elements: [UIMenuElement] {
        if isGameInProgress {
            return [restart]
        } else {
            return [timerSettings]
        }
    }


    func updateMenu() {
        button.menu = UIMenu(children: elements)
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
