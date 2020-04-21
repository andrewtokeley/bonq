//
//  Colours.swift
//  bonq
//
//  Created by Andrew Tokeley on 10/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    // MARK: - Game Colours
    
    public class var app_backgroundDark: UIColor {
        return UIColor(red: 33/255, green: 85/255, blue: 102/255, alpha: 1)
        //return UIColor(red: 47/255, green: 84/255, blue: 100/255, alpha: 1)
    }
    
    public class var app_backgroundLight: UIColor {
        return .white
    }
    
    public class var app_buttonBackground: UIColor {
        return UIColor(red: 230/255, green: 158/255, blue: 76/255, alpha: 1)
    }
    
    public class var app_buttonText: UIColor {
        return UIColor(red: 255/255, green: 242/255, blue: 204/255, alpha: 1)
    }
    
    public class var app_buttonTextDisabled: UIColor {
        return UIColor(red: 249/255, green: 203/255, blue: 156/255, alpha: 1)
    }
    
    public class var app_textColourOnDark: UIColor {
        return app_buttonText
    }
    
    public class var app_textColourOnLight: UIColor {
        return app_backgroundDark
    }
}
