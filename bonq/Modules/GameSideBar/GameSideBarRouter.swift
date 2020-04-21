//
//  GameSideBarRouter.swift
//  bonq
//
//  Created by Andrew Tokeley on 12/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import Viperit

// MARK: - GameSideBarRouter class
final class GameSideBarRouter: Router {
}

// MARK: - GameSideBarRouter API
extension GameSideBarRouter: GameSideBarRouterApi {
}

// MARK: - GameSideBar Viper Components
private extension GameSideBarRouter {
    var presenter: GameSideBarPresenterApi {
        return _presenter as! GameSideBarPresenterApi
    }
}
