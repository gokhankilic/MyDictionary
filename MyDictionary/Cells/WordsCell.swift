//
//  WordsCell.swift
//  MyDictionary
//
//  Created by Gökhan Kılıç on 14.02.2019.
//  Copyright © 2019 Gökhan Kılıç. All rights reserved.
//

import UIKit

class WordsCell: UITableViewCell {

    @IBOutlet weak var englishMeanLbl: UILabel!
    @IBOutlet weak var turkishMeanLbl: UILabel!
    var dateAdded:Date?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        englishMeanLbl.adjustsFontSizeToFitWidth = true
        turkishMeanLbl.adjustsFontSizeToFitWidth = true
        
        
        
    }
    
    func configureCell(word:Word){
        self.englishMeanLbl.text = word.englishMean
        self.turkishMeanLbl.text = word.turkishMean
    }
    
    
}
