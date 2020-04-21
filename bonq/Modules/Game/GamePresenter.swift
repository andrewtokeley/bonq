//
//  GamePresenter.swift
//  bonq
//
//  Created by Andrew Tokeley on 8/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import Viperit
import SpriteKit

// MARK: - GamePresenter Class
final class GamePresenter: Presenter {
    
    var delegate: MatchDelegate?
    var sideBarOrientation: SideBarOrientation = .left
    var scores = [Int]()
    
    override func setupView(data: Any) {

    }
    
    override func viewHasLoaded() {
        super.viewHasLoaded()
        
        PeerToPeerService.instance.gameDelegate = self
        
        // TEMP
        scores.append(0) // local player
        scores.append(0) // opponenent
        
        let setupData = GameSideBarSetupData(localPlayerName: PeerToPeerService.instance.localPeerID.displayName, opponentName: PeerToPeerService.instance.opponentPeerID!.displayName, orientation: self.sideBarOrientation)
        
        let gameSideBarPresenter = router.showSideBar(within: view.viewController, inside: view.sideBarContainer, setupData: setupData)
        
        // set where the delegate is that will receive updates to score
        self.delegate = gameSideBarPresenter as? GameSideBarPresenter
        
        // let the delegate know the initial scores and how
        delegate?.match(updatedScore: 0, forPlayer: .local)
        delegate?.match(updatedScore: 0, forPlayer: .opponent)
        delegate?.match(setSideBarOrientation: self.sideBarOrientation)
    }
}

// MARK: - GamePresenter API
extension GamePresenter: GamePresenterApi {
    
    func didSelectToMoveBat(direction: BatDirection) {
        view.moveBat(direction: direction)
    }
    
    func ballHitBat(location: CGFloat) {
        scores[Player.local.rawValue] += 10
        delegate?.match(updatedScore: scores[Player.local.rawValue], forPlayer: .local)
    }
    
    func ballHitGround(location: CGFloat) {
        scores[Player.opponent.rawValue] += 10
        delegate?.match(updatedScore: scores[Player.opponent.rawValue], forPlayer: .opponent)
    }
    
}

// MARK: - PeerToPeerServiceGameDelegate
extension GamePresenter: PeerToPeerServiceGameDelegate {
    
}

// MARK: - Game Viper Components
private extension GamePresenter {
    var view: GameViewApi {
        return _view as! GameViewApi
    }
    var interactor: GameInteractorApi {
        return _interactor as! GameInteractorApi
    }
    var router: GameRouterApi {
        return _router as! GameRouterApi
    }
}
