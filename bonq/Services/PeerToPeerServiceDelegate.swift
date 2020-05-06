//
//  PeerToPeerServiceDelegate.swift
//  bonq
//
//  Created by Andrew Tokeley on 15/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import CoreGraphics
import MultipeerConnectivity

/**
 This protocol defines the delegate methods used during a game
 */
protocol PeerToPeerServiceGameDelegate {
    /**
     Let the delegate (GamePresenter) know when your opponent tells you about the latest scores. The score values are the total score, not the increment.
     */
    func peerToPeer(_ service: PeerToPeerService, scoreChanged score: Int, forPlayer player: Player)

    /**
     Let the delegate (GamePresenter) know when the ball is leaving the opponent's screen
     */
    func peerToPeer(_ service: PeerToPeerService, ballLeavingOpponentSceneAtWidthProportion widthProportion: CGFloat, vector: CGVector)
    
    /**
     Let the delegate (GamePresenter) know your opponents has  quit the game or the connection is lost with them for any reason.
     */
    func peerToPeer(_service: PeerToPeerService, leftGameByPlayer player: MCPeerID)
}

/**
This protocol defines the delegate methods used to find an opponent and initiate a game
*/
protocol PeerToPeerServiceMatchDelegate {
    
    /**
     Lets the delegate know the found peer's name has changed.
     */
    func peerToPeer(_ service : PeerToPeerService, opponentChangedName name: String)

    /**
     This delegate method is called when you get invited to play a game from another player.
     */
    func peerToPeer(_ service : PeerToPeerService, invitationReceivedFromPlayer player: MCPeerID, invitationMessage: String, response: @escaping (Bool) -> Void)

    /**
     This delegate method is called when a player accepts and invitation to play. Note that this method will be called for both the sender and recipient of an invitation.
     */
    func peerToPeer(_ service : PeerToPeerService, invitationAcceptedFromPlayer player: MCPeerID, accepted: Bool)
    
    /**
     The delegate methods is called when another player has been discovered. Players will only be discovered if they have the app open and are on the menu screen.
     */
    func peerToPeer(_ service : PeerToPeerService, foundNearbyPlayer player: MCPeerID)
    
    /**
     This delegate method is called in a couple of scenarios. Firstly, when a player that was connected to a game disconnects, by closing their app or quiting the game. It can also be called when an available player disconnects before you've had a chance to send them an invitation.
     */
    func peerToPeer(_ service : PeerToPeerService, lostNearbyPlayer player: MCPeerID)
}
