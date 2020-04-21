//
//  GameSideBarPresenter.swift
//  bonq
//
//  Created by Andrew Tokeley on 12/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import Viperit
import GameKit

// MARK: - GameSideBarPresenter Class
final class GameSideBarPresenter: Presenter {
    
    override func setupView(data: Any) {
        if let data = data as? GameSideBarSetupData {
            view.displayName(player: .local, name: data.localPlayerName)
            if let opponentName = data.opponentName {
                view.displayName(player: .opponent, name: opponentName)
            }
        }
    }
}

// MARK: - GameSideBarPresenter API
extension GameSideBarPresenter: GameSideBarPresenterApi {
}

extension GameSideBarPresenter: MatchDelegate {
    func match(updatedScore score: Int, forPlayer player: Player) {
        view.displayScore(player: player, score: score)
    }
    
    func match(setSideBarOrientation orientation: SideBarOrientation) {
        view.setOrientation(orientation: orientation)
    }
}
// MARK: - GameSideBar Viper Components
private extension GameSideBarPresenter {
    var view: GameSideBarViewApi {
        return _view as! GameSideBarViewApi
    }
    var interactor: GameSideBarInteractorApi {
        return _interactor as! GameSideBarInteractorApi
    }
    var router: GameSideBarRouterApi {
        return _router as! GameSideBarRouterApi
    }
}
