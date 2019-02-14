//
//  CorneredButton.swift
//  MyDictionary
//
//  Created by Gökhan Kılıç on 14.02.2019.
//  Copyright © 2019 Gökhan Kılıç. All rights reserved.
//

import UIKit


@IBDesignable
class CorneredButton: UIButton {

    override func prepareForInterfaceBuilder() {
        customizeView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }
    
    func  customizeView() {
        layer.cornerRadius = 10.0
    }

}
