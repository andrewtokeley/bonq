//
//  LoadInteractor.swift
//  bonq
//
//  Created by Andrew Tokeley on 8/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import Viperit
import GameKit

// MARK: - LoadInteractor Class
final class LoadInteractor: Interactor {
}

// MARK: - LoadInteractor API
extension LoadInteractor: LoadInteractorApi {
    
//    func authenticateWithGameCentre(completion: ((UIViewController?, Error?) -> Void)?) {
//        GKLocalPlayer.local.authenticateHandler = { viewController, error in
//            completion?(viewController, error)
//        }
//    }
//    
//    func registerLocalPlayerListener() {
//        //GKLocalPlayer.local.register(<#T##listener: GKLocalPlayerListener##GKLocalPlayerListener#>)
//    }
}

// MARK: - Interactor Viper Components Api
private extension LoadInteractor {
    var presenter: LoadPresenterApi {
        return _presenter as! LoadPresenterApi
    }
}
