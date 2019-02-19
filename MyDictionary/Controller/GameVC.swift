//
//  GameVC.swift
//  MyDictionary
//
//  Created by Gökhan Kılıç on 18.02.2019.
//  Copyright © 2019 Gökhan Kılıç. All rights reserved.
//

import UIKit
import CoreData

class GameVC: UIViewController,UITextFieldDelegate {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    @IBOutlet weak var endTableView: UIView!
    @IBOutlet weak var timeTxt: UILabel!
    @IBOutlet weak var scoreTxt: UILabel!
    @IBOutlet weak var questionTxt: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var correctAnswerTxt: UILabel!
    @IBOutlet weak var endScoreTxt: UILabel!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!  //!!!!!!! REMOVED WEAK REFERANCE SOLVED THE NIL PROBLEM !!!!!!!!
    
    var words:[Word]?
    var correctAnswer : String?
    var score:Int = 0
    var tempBottomConstraint:NSLayoutConstraint?
    
    var unknownWords:[Word]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        score = 0
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.timeTxt.text = "0"
        self.scoreTxt.text = "0"
       
        answerTextField.delegate = self
        answerTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        generateQuestion()
        setTimer()
       
        }
      
        
        func setTimer(){
            var runCount = 15
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                
                runCount -= 1
                self.timeTxt.text = ("\(runCount)")
                if runCount == 0 {
                    timer.invalidate()
               
                    UIView.animate(withDuration: 1.5, animations: {
                        NSLayoutConstraint.deactivate([self.bottomConstraint])
                        self.endTableView.isHidden = false
                        self.endTableView.frame = CGRect(x:0, y: 0, width: 375, height: 450)
                        self.view.layoutIfNeeded()
                        self.endScoreTxt.text = ("\(self.score)")
                       
                    }) { (finished) in
                        
                    }
                }
        }
        
    }
    
    func fetch(){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        
        do {
            try words = (managedContext.fetch(fetchRequest) as! [Word])
            print("Successfuly fetch data")
            
            
        }catch{
            debugPrint("\(error.localizedDescription)")
        }
    }
    
    func generateQuestion(){
        
        fetch()
        self.answerTextField.text = ""
        correctAnswerTxt.isHidden = true
        let selectedWord = words?.randomElement()
        let englishMean = selectedWord?.englishMean
        let turkishMean = selectedWord?.turkishMean
        self.questionTxt.text = englishMean
        correctAnswer = turkishMean
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
       
        if let answer = textField.text {
            if answer.lowercased() == correctAnswer?.lowercased() {
                score = score + 1
                scoreTxt.text = ("\(score)")
                generateQuestion()
            }
        }
    }
    
    
    @IBAction func showAnswer(_ sender: Any) {
        correctAnswerTxt.isHidden = false
        correctAnswerTxt.text = correctAnswer
       }
    
    
    
    @IBAction func replayBtnWasPressed(_ sender: Any) {
        endTableView.isHidden = true
        NSLayoutConstraint.activate([self.bottomConstraint])
        self.view.layoutIfNeeded()
        score = 0
        timeTxt.text = "0"
        scoreTxt.text = "0"
        setTimer()
    }
    
    
    @IBAction func mainMenuWasPressed(_ sender: Any) {
     
    performSegue(withIdentifier: "toMainVC", sender: nil)
    
    }
    
  
}
