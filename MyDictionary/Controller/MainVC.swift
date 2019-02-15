//
//  ViewController.swift
//  MyDictionary
//
//  Created by Gökhan Kılıç on 14.02.2019.
//  Copyright © 2019 Gökhan Kılıç. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
   
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    @IBOutlet weak var searchTextField: UITextField!
    

    @IBOutlet weak var wordsTableView: UITableView!
    
    @IBOutlet weak var englishWordTextView: UITextField!
    
    @IBOutlet weak var turkishWordTextView: UITextField!
    
    @IBOutlet weak var addButton: CorneredButton!
    
    @IBOutlet weak var trOrEngSwitch: UISwitch!
    
    var words = [Word]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordsTableView.delegate = self
        wordsTableView.dataSource = self
        searchTextField.delegate = self
        
    }


    
   
    @objc func textFieldDidChange(_ textField: UITextField) {
        search(searchedText: textField.text!)
        
        if(textField.text == ""){
            fetch()
            wordsTableView.reloadData()
        }
    }
    
    @IBAction func addButonWasPressed(_ sender: Any) {
        if englishWordTextView.text == "" || turkishWordTextView.text == "" {
            print("Please enter valid words")
            
            for i in 0..<words.count {
                var word = words[i]
                
                if word.englishMean == englishWordTextView.text || word.turkishMean == turkishWordTextView.text {
                    print("this word was already added")
                }
            }

        }else {
            save()
            fetch()
            wordsTableView.reloadData()
            englishWordTextView.text = ""
            turkishWordTextView.text = ""

        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath) as! WordsCell
        cell.configureCell(word: words[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            
           self.removeWord(atIndexPath: indexPath)
           
            //tableView.deleteRows(at: [indexPath], with: .automatic) // this code causes crash
            
            
          
          self.fetch()
          tableView.reloadData()
          self.searchTextField.text = ""
        }
        
    
        
        deleteAction.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    func save(){
        
        let currentDateTime = Date()
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let word = Word(context: managedContext)
        
        word.dateAdded = currentDateTime
        word.englishMean = englishWordTextView.text
        word.turkishMean = turkishWordTextView.text
        
        do {
            try managedContext.save()
            print("Successfully saved data")
        }catch {
            debugPrint("Could not save: \(error.localizedDescription)")
        }
    }
    
    func fetch(){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        
        do {
            try words = managedContext.fetch(fetchRequest) as! [Word]
            print("Successfuly fetch data")
            
            
        }catch{
            debugPrint("\(error.localizedDescription)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetch()
        wordsTableView.reloadData()
        
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

    }
    
    func removeWord(atIndexPath indexPath: IndexPath){
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        managedContext.delete(words[indexPath.row])
        
        do {
            try managedContext.save()
            print("Successfully removed goal!")
        }catch{
            debugPrint("Could not remove : \(error.localizedDescription)")
            
        }
    }
    
    func search(searchedText:String){
        var filteredWords = [Word]()
        
        if trOrEngSwitch.isOn {
            filteredWords = words.filter { ($0.englishMean?.lowercased().contains(searchedText.lowercased()))!}
        }else{
            filteredWords = words.filter { ($0.turkishMean?.lowercased().contains(searchedText.lowercased()))!}

        }
        words = filteredWords
        wordsTableView.reloadData()
    }
}

