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
    
    // for now assuming you'll only ever find one person
    var foundPeer: MCPeerID?
    
    
    override func viewHasLoaded() {
        
        self.service.matchDelegate = self
        
        self.displayWelcomeMessage()
        
        view.enablePlayButton(false)
        view.displayLocalPlayerName(name: service.localPeerID.displayName)
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
    
    func peerToPeer(_ service: PeerToPeerService, receivedData: Data, fromPlayer player: MCPeerID) {
        
        let message = String(data: receivedData, encoding: .utf8) ?? "Unknown"
        self.view.displayMessage(text: "Message: \(message), from \(player.displayName)")
        
    }
    
    func peerToPeer(_ service: PeerToPeerService, invitationAcceptedFromPlayer player: MCPeerID, accepted: Bool) {
        
        self.responseToRequestToPlay(accepted: accepted, opponent: player)
    }       
    
    func peerToPeer(_ service : PeerToPeerService, invitationReceivedFromPlayer player: MCPeerID, invitationMessage: String, response: @escaping (Bool) -> Void) {
        self.view.displayMessage(text: "Received Invite from \(player.displayName)")
        self.view.showInvitation(message: invitationMessage) { (respo) in
            response(respo)
        }
    }
    
    func peerToPeer(_ service: PeerToPeerService, foundNearbyPlayer player: MCPeerID) {
        print("Found - \(player.displayName)")
        foundPeer = player
        view.showOpponentPlayer(name: player.displayName)
        view.enablePlayButton(true)
    }
    
    func peerToPeer(_ service: PeerToPeerService, lostNearbyPlayer player: MCPeerID) {
        foundPeer = nil
        view.removeOpponentPlayer(name: player.displayName)
        view.enablePlayButton(false)
    }
    
}

// MARK: - MenuPresenter API
extension MenuPresenter: MenuPresenterApi {
    
    func responseToRequestToPlay(accepted: Bool, opponent: MCPeerID) {
        if accepted {
            router.navigateToGame()
        } else {
            view.displayMessage(text: "\(opponent.displayName) said NO :-(")
        }
    }
    
//    func didSelectReset() {
//        self.service.resetService()
//        self.displayWelcomeMessage()
//    }
    
    func didClickPlayButton() {
        
        // invite the other player
        if let foundPeer = foundPeer {
            view.displayMessage(text: "Inviting \(foundPeer.displayName). One moment please...")
            service.invitePlayer(peer: foundPeer, invitationMessage: "\(service.localPeerID.displayName) wants to play!")
        }
        
        // we'll get notified whether the player accepts or not in the
    }
    
    func didTapLocalProfileView() {
        
        // Show settings button if this is for the local player
        let module = AppModules.settings.build()
        module.router.show(from: view.viewController, embedInNavController: false, setupData: nil)
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
