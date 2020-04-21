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

protocol PeerToPeerServiceGameDelegate {
//    func peerToPeer(_ service : PeerToPeerService, changedConnectedDevices: [String])
//    func peerToPeer(_ service : PeerToPeerService, ballArrivedOnVector: CGVector)
    
}

protocol PeerToPeerServiceMatchDelegate {
    func peerToPeer(_ service: PeerToPeerService, receivedData: Data, fromPlayer player: MCPeerID)
    
    func peerToPeer(_ service : PeerToPeerService, invitationReceivedFromPlayer player: MCPeerID, invitationMessage: String, response: @escaping (Bool) -> Void)

    func peerToPeer(_ service : PeerToPeerService, invitationAcceptedFromPlayer player: MCPeerID, accepted: Bool)
    
    func peerToPeer(_ service : PeerToPeerService, foundNearbyPlayer player: MCPeerID)
    func peerToPeer(_ service : PeerToPeerService, lostNearbyPlayer player: MCPeerID)
}
