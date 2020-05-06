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
    
    var delegate: GameSideBarDelegate?
    
    override func setupView(data: Any) {
        if let data = data as? GameSideBarSetupData {
            view.displayName(player: .local, name: data.localPlayerName)
            if let opponentName = data.opponentName {
                view.displayName(player: .opponent, name: opponentName)
            }
            delegate = data.delegate
            
            view.setOrientation(orientation: delegate?.gameSideBarOrientation() ?? .left)
        }
    }
}

// MARK: - GameSideBarPresenter API
extension GameSideBarPresenter: GameSideBarPresenterApi {
    
    func didSelectQuit() {
        // this will send a 'lostPeer' message to your opponent, so that they know you quit
        PeerToPeerService.instance.disconnectFromSession()
        
        delegate?.gameSideBar(self, selectedAction: .quit)
    }
}

// MARK: - GameDelegate
extension GameSideBarPresenter: GameDelegate {
    
    func gameDelegate(_ gameDelegate: GamePresenterApi, updatedScore score: Int, forPlayer player: Player) {
        view.displayScore(player: player, score: score)
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
