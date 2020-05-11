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
import MultipeerConnectivity

// MARK: - GamePresenter Class
final class GamePresenter: Presenter {
    
    var delegate: GameDelegate?
    
    var sideBarOrientation: SideBarOrientation = .left
    var scores = [Int]()
    var hasServe: Bool = false
    
    override func setupView(data: Any) {
        if let data = data as? GameSetupData {
            hasServe = data.hasServe
            sideBarOrientation = data.sideBarOrientation
            view.setSideBarOrientation(orientation: sideBarOrientation)
        }
    }
    
    override func viewHasLoaded() {
        super.viewHasLoaded()
        
        PeerToPeerService.instance.gameDelegate = self
        
        // TEMP
        scores.append(0) // local player
        scores.append(0) // opponenent
        
        let setupData = GameSideBarSetupData(localPlayerName: PeerToPeerService.instance.localPeerID.displayName, opponentName: PeerToPeerService.instance.opponentPeerID!.displayName, delegate: self)
        
        let gameSideBarPresenter = router.showSideBar(within: view.viewController, inside: view.sideBarContainer, setupData: setupData)
        
        // set where the delegate is that will receive updates to score
        self.delegate = gameSideBarPresenter as? GameSideBarPresenter
        
        self.delegate?.gameDelegate(self, updatedScore: 0, forPlayer: .local)
        self.delegate?.gameDelegate(self, updatedScore: 0, forPlayer: .opponent)
                
    }
    
    /**
     Tell your opponenet about the latest scores
     */
    private func tellOpponentAboutScores() {
        
        interactor.tellOpponentTheScores(theirScore: scores[Player.opponent.rawValue], yourScore: scores[Player.local.rawValue])
    }
}

// MARK: - GamePresenter API
extension GamePresenter: GamePresenterApi {
    
    func viewHasCreatedScene() {
        if hasServe {
            view.prepareBallForServe()
        }
    }
    
    func didSelectToMoveBat(direction: BatMovement) {
        view.moveBat(direction: direction)
    }
    
    func ballHitBat(location: CGFloat) {
        
        // You successfully hit the ball back so get 10 points!
        scores[Player.local.rawValue] += 10
        
        // let the delegate (SideBarPresenter) know the score has changed
        delegate?.gameDelegate(self, updatedScore: scores[Player.local.rawValue], forPlayer: .local)
        
        self.tellOpponentAboutScores()
        
        // create the bounce vector based on the location the ball hit the bat
        // location is between 0 and 1, 0 is the left most part of bat, 1 the rightmost, 0.5 in the middle
        var vector = CGVector(angle: 0, coordinateSystem: .cartesian)
        if location < 0.1 {
            vector = CGVector(angle: 290, coordinateSystem: .cartesian) // left, flat, up
        } else if location < 0.4 {
            vector = CGVector(angle: 315, coordinateSystem: .cartesian) // left 45 up
        } else if location > 0.9 {
            vector = CGVector(angle: 75, coordinateSystem: .cartesian) // right flat up
        } else if location > 0.6 {
            vector = CGVector(angle: 45, coordinateSystem: .cartesian) // right 45 up
        }
        
        view.serveBall(vector: vector)
    }
    
    func ballHitGround(location: CGFloat) {
        
        // The ball got past your defenses so your opponent gets 10 points!
        scores[Player.opponent.rawValue] += 10
        
        // let the delegate (SideBarPresenter) know the score has changed
        delegate?.gameDelegate(self, updatedScore: scores[Player.opponent.rawValue], forPlayer: .opponent)
        
        self.tellOpponentAboutScores()
        
        // The person who loses the point gets to serve
        view.prepareBallForServe()
    }
    
    func didSelectToServe(vector: CGVector) {
        view.serveBall(vector: vector)
    }
    
    func ballHasLeftScreen(xLocationAsAProportionOfWidth widthProportion: CGFloat, vector: CGVector) {
        interactor.tellOpponentBallIsComing(xLocationAsAProportionOfWidth: widthProportion, vector: vector)
    }

}

// MARK: - PeerToPeerServiceGameDelegate
extension GamePresenter: PeerToPeerServiceGameDelegate {
    
    
    func peerToPeer(_ service: PeerToPeerService, ballLeavingOpponentSceneAtWidthProportion widthProportion: CGFloat, vector: CGVector) {
        
        view.receiveBallFromOpponent(opponentXLocationAsAProportionOfWidth: widthProportion, opponentVector: vector)
    }
    
    
    func peerToPeer(_ service: PeerToPeerService, scoreChanged score: Int, forPlayer player: Player) {
        
        // update the score variables
        if player == .local {
            scores[Player.local.rawValue] = score
        } else if player == .opponent {
            scores[Player.opponent.rawValue] = score
        }
        
        delegate?.gameDelegate(self, updatedScore: score, forPlayer: player)
    }
    
    
    func peerToPeer(_service: PeerToPeerService, leftGameByPlayer player: MCPeerID) {
        // close game and go back to menu screen
        view.prepareForQuit()
        router.dismiss(animated: true, completion: nil)
    }
    
    
}

// MARK: - GameSideBarDelegate

extension GamePresenter: GameSideBarDelegate {
    
    func gameSideBarOrientation() -> SideBarOrientation {
        return self.sideBarOrientation
    }
    
    func gameSideBar(_ presenter: GameSideBarPresenterApi, selectedAction action: GameSideBarAction) {
        if action == .quit {
            view.prepareForQuit()
            router.dismiss(animated: true, completion: nil)
        }
    }
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
