//
//  MenuRouter.swift
//  bonq
//
//  Created by Andrew Tokeley on 8/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import Viperit
import GameKit

// MARK: - MenuRouter class
final class MenuRouter: Router {
    
}

// MARK: - MenuRouter API
extension MenuRouter: MenuRouterApi {
    
    func navigateToGame(setup: GameSetupData) {
        
        let module = AppModules.game.build()
        module.router.present(from: viewController, embedInNavController: false, presentationStyle: .fullScreen, transitionStyle: .crossDissolve, setupData: setup, completion: nil)
    }
}

// MARK: - Menu Viper Components
private extension MenuRouter {
    var presenter: MenuPresenterApi {
        return _presenter as! MenuPresenterApi
    }
}
