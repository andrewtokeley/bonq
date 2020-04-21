//
//  Layout.swift
//  bonq
//
//  Created by Andrew Tokeley on 12/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import UIKit

class Layout {
    static var spacerLarge: CGFloat = 20
    static var spacerNormal: CGFloat = 10
    static var spacerSmall: CGFloat = 5
    
    /**
     Controls should be this distance from the top of the screen to avoid overlapping with the background image title.
     */
    static var spacerHeader: CGFloat = 200
    
    /**
     Standard dimension for all buttons
     */
    static var buttonSize = CGSize(width: 150, height: 50)
    
    /**
     Standard height of input fields and labels
     */
    static var textHeight = 40
}
