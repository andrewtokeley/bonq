//
//  Player.swift
//  bonq
//
//  Created by Andrew Tokeley on 17/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import UIKit

class PlayerIcon: UIView {
    
    @IBOutlet weak var playerName: UILabel!
    
    @IBOutlet weak var highlightView: UIView!
    
    func setSelectedState(isSelected: Bool) {
        highlightView.backgroundColor = isSelected ? UIColor.app_buttonBackground : .white
    }
    
}
