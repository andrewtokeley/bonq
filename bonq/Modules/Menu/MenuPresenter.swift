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
    
    // remember all the peers we find (but we're only going to show one)
    var foundPeers = [MCPeerID]()
    
    override func viewHasLoaded() {
        
        self.service.matchDelegate = self
        
        self.displayWelcomeMessage()
        
        view.enablePlayButton(false)
        view.displayLocalPlayerName(name: service.localPeerID.displayName)
        view.displaySearchingForPlayer()
    }
    
    private func displayWelcomeMessage() {
//        let settingsService = SettingsService()
//        settingsService.get { (settings) in
//            self.view.displayMessage(text: "Welcome Back \(settings.name)")
//        }
    }
}

// MARK: - PeerToPeerServiceMatchDelegate

extension MenuPresenter: PeerToPeerServiceMatchDelegate {
    
    // TODO: this may no longer be needed
    func peerToPeer(_ service: PeerToPeerService, opponentChangedName name: String) {
        view.showOpponentPlayer(name: name)
    }
    
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
        
        if !foundPeers.contains(player) {
            foundPeers.append(player)
        }
        
        view.showOpponentPlayer(name: player.displayName)
        view.enablePlayButton(true)
    }
    
    func peerToPeer(_ service: PeerToPeerService, lostNearbyPlayer player: MCPeerID) {
        print("Lost - \(player.displayName)")
        
        foundPeers.removeAll { (peer) -> Bool in
            peer == player
        }
        
        if let _ = foundPeers.last {
            // display the last peer found
            view.showOpponentPlayer(name: foundPeers.last!.displayName)
        } else {
            // all found peers gone
            view.displaySearchingForPlayer()
            view.enablePlayButton(false)
        }
        
    }
    
}

// MARK: - MenuPresenter API
extension MenuPresenter: MenuPresenterApi {
    
    func didClickPlayButton() {
        
        // invite the other player
        if let foundPeer = foundPeers.last {
            
            view.displayMessage(text: "Inviting \(foundPeer.displayName). One moment please...")
            
            service.invitePlayer(peer: foundPeer, invitationMessage: "\(service.localPeerID.displayName) wants to play!")
        }
        
        // we'll get notified whether the player accepts or not in the
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
