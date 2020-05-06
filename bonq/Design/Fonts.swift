//
//  Fonts.swift
//  bonq
//
//  Created by Andrew Tokeley on 10/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {

    public class var app_normal: UIFont {
        return UIFont(name: "KohinoorBangla-Semibold", size: 14) ?? UIFont.systemFont(ofSize: 14)
    }
    
    public class var app_largeSemiBold: UIFont {
        return UIFont(name: "KohinoorBangla-Semibold", size: 40) ?? UIFont.systemFont(ofSize: 40, weight: .semibold)
    }
    
}
