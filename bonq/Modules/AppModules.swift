//
//  AppModules.swift
//  bonq
//
//  Created by Andrew Tokeley on 8/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import Viperit

//MARK: - Application modules
enum AppModules: String, ViperitModule {
    case game
    
    var viewType: ViperitViewType {
        return .code
    }
}
