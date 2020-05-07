//
//  MenuPresenter.swift
//  bonq
//
//  Created by Andrew Tokeley on 8/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import Viperit
import MultipeerConnectivity

// MARK: - MenuPresenter Class
final class MenuPresenter: Presenter {
    
    let service = PeerToPeerService.instance
    
    var opponent: MCPeerID?
    
    override func viewHasLoaded() {
        
        self.service.matchDelegate = self
        
        view.enablePlayButton(false)
        view.displayLocalPlayerName(name: service.localPeerID.displayName)
        view.displaySearchingForPlayer()
    }
}

// MARK: - PeerToPeerServiceMatchDelegate

extension MenuPresenter: PeerToPeerServiceMatchDelegate {
        
    func peerToPeer(_ service: PeerToPeerService, invitationAcceptedFromPlayer player: MCPeerID, accepted: Bool) {
        
        if accepted {
            
            // Your invite was accepted - start the game and take the serve
            self.router.navigateToGame(setup: GameSetupData(sideBarOrientation: .bottom, hasServe: true))

        } else {
            
            view.displayMessage(text: "\(player.displayName) said NO :-(")
        }
    }       
    
    func peerToPeer(_ service : PeerToPeerService, invitationReceivedFromPlayer player: MCPeerID, invitationMessage: String, response: @escaping (Bool) -> Void) {
        
        self.view.displayMessage(text: "Received Invite from \(player.displayName)")
        self.view.showInvitation(message: invitationMessage) { (respo) in
            response(respo)
            
            // If you accepted, start the game and be ready to receive the serve
            if respo {
                self.router.navigateToGame(setup: GameSetupData(sideBarOrientation: .bottom, hasServe: false))
            }
        }
    }
    
    func peerToPeer(_ service: PeerToPeerService, foundNearbyPlayer player: MCPeerID) {
        print("Found - \(player.displayName)")
        
        self.opponent = player
        
        view.showOpponentPlayer(name: player.displayName)
        view.enablePlayButton(true)
    }
    
    func peerToPeer(_ service: PeerToPeerService, lostNearbyPlayer player: MCPeerID) {
        print("Lost - \(player.displayName)")
        
        // Despite losing this peer, check if there is someone else nearby
        if let anotherPeer = PeerToPeerService.instance.nearbyPeers.last {
            self.opponent = anotherPeer
            view.showOpponentPlayer(name: anotherPeer.displayName)
            view.enablePlayButton(true)
            
        } else {
            // there is no-one else nearby :-(
            self.opponent = nil
            view.displaySearchingForPlayer()
            view.enablePlayButton(false)
        }
        
    }
    
}

// MARK: - MenuPresenter API
extension MenuPresenter: MenuPresenterApi {
    
    func didClickPlayButton() {
        
        // invite the other player
        if let opponent = self.opponent  {
            
            view.displayMessage(text: "Inviting \(opponent.displayName). One moment please...")
            service.invitePlayer(peer: opponent, invitationMessage: "\(service.localPeerID.displayName) wants to play!")
        }
    }
    
    func didTapLocalProfileView() {
        
        // Show settings button if this is for the local player
        let module = AppModules.settings.build()
        let setupData = SettingsSetupData(delegate: self)
        module.router.show(from: view.viewController, embedInNavController: false, setupData: setupData)
    }
    
    func didTapOpponentProfileView() {
        //PeerToPeerService.instance.resetService()
        
    }
    
}

// MARK: - SettingsDelegate

extension MenuPresenter: SettingsDelegate {
    
    func settings(_ SettingsPresenter: SettingsPresenterApi, didUpdateName name: String) {
        view.displayLocalPlayerName(name: name)
        PeerToPeerService.instance.resetService()
    }
}

// MARK: - Menu Viper Components
private extension MenuPresenter {
    var view: MenuViewApi {
        return _view as! MenuViewApi
    }
    var interactor: MenuInteractorApi {
        return _interactor as! MenuInteractorApi
    }
    var router: MenuRouterApi {
        return _router as! MenuRouterApi
    }
}
