//
//  GameSideBarInteractor.swift
//  bonq
//
//  Created by Andrew Tokeley on 12/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import Viperit

// MARK: - GameSideBarInteractor Class
final class GameSideBarInteractor: Interactor {
}

// MARK: - GameSideBarInteractor API
extension GameSideBarInteractor: GameSideBarInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension GameSideBarInteractor {
    var presenter: GameSideBarPresenterApi {
        return _presenter as! GameSideBarPresenterApi
    }
}
