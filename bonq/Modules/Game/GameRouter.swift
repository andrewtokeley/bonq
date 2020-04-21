//
//  GameRouter.swift
//  bonq
//
//  Created by Andrew Tokeley on 8/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import Viperit

// MARK: - GameRouter class
final class GameRouter: Router {
    
}

// MARK: - GameRouter API
extension GameRouter: GameRouterApi {
    
    func showSideBar(within viewController: UIViewController, inside viewContainer: UIView, setupData: GameSideBarSetupData) -> GameSideBarPresenterApi {
        let module = AppModules.gameSideBar.build()
        module.router.show(from: viewController, insideView: viewContainer, setupData: setupData)
        return module.presenter as! GameSideBarPresenter
    }
    
}

// MARK: - Game Viper Components
private extension GameRouter {
    var presenter: GamePresenterApi {
        return _presenter as! GamePresenterApi
    }
}
