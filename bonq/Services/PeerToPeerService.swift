//
//  PeerToPeerService.swift
//  bonq
//
//  Created by Andrew Tokeley on 15/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation

import Foundation
import MultipeerConnectivity

class PeerToPeerService : NSObject {

    // singleton instance
    static let instance = PeerToPeerService()
    
    // Service type must be a unique string, at most 15 characters long
    // and can contain only ASCII lowercase letters, numbers and hyphens.
    private let SERVICE_ID = "bonqService"

    private var serviceAdvertiser : MCNearbyServiceAdvertiser!
    private var serviceBrowser : MCNearbyServiceBrowser!
    
    var localPeerID: MCPeerID!
    var opponentPeerID: MCPeerID?
    
    var session : MCSession!
    
    var matchDelegate: PeerToPeerServiceMatchDelegate?
    var gameDelegate: PeerToPeerServiceGameDelegate?
    
    override init() {
        
        super.init()
        
        let settingsService = SettingsService()
        settingsService.get { (settings) in
            self.localPeerID = settings.peerId
            self.resetService()
        }
    }

    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    func resetService() {
        
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: localPeerID, discoveryInfo: nil, serviceType: SERVICE_ID)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: localPeerID, serviceType: SERVICE_ID)
        
        session = MCSession(peer: self.localPeerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self

        startService()
    }
    
    private func startService() {
        
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
        
    }
    /**
        Invite a nearby player to connect to the shared session.
     */
    func invitePlayer(peer: MCPeerID, invitationMessage: String) {
        let messageAsData = invitationMessage.data(using: .utf8)
        self.serviceBrowser.invitePeer(peer, to: self.session, withContext: messageAsData, timeout: 10)
    }
    
    func sendTestMessage(message: String, sendTo peer: MCPeerID) {
        if self.session.connectedPeers.count > 0 {
            if let messageData = message.data(using: .utf8) {
                do {
                    try self.session.send(messageData, toPeers: [peer], with: .reliable)
                } catch let error as NSError {
                    //
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func threadSafeCallback(callback: @escaping () -> Void) {
        DispatchQueue.main.async {
            callback()
        }
    }
    
}

extension PeerToPeerService : MCNearbyServiceAdvertiserDelegate {

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        
        
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        // Default invitation message
        var invitationMessage = "Join me!"

        // If there's a string message in the context, use that instead
        if let context = context, let message = String(data: context, encoding: .utf8) {
            invitationMessage = message
        }

        threadSafeCallback() {
            self.matchDelegate?.peerToPeer(self, invitationReceivedFromPlayer: peerID, invitationMessage: invitationMessage) { (response) in
                invitationHandler(response, self.session)
            }
        }
        
    }
}

extension PeerToPeerService : MCNearbyServiceBrowserDelegate {

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        
        print("didNotStartBrowsingForPeers")
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        self.opponentPeerID = peerID
        
        threadSafeCallback() {
            self.matchDelegate?.peerToPeer(self, foundNearbyPlayer: peerID)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        self.opponentPeerID = nil
        
        threadSafeCallback() {
            self.matchDelegate?.peerToPeer(self, lostNearbyPlayer: peerID)
        }
    }

}

extension PeerToPeerService : MCSessionDelegate {

    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("State of \(peerID.displayName) changed to \(state.name)")
        
        threadSafeCallback() {
            if state == .connected {
                self.matchDelegate?.peerToPeer(self, invitationAcceptedFromPlayer: peerID, accepted: true)
            } else if state == .notConnected {
                self.matchDelegate?.peerToPeer(self, invitationAcceptedFromPlayer: peerID, accepted: false)
            }
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        threadSafeCallback {
            self.matchDelegate?.peerToPeer(self, receivedData: data, fromPlayer: peerID)
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
        NSLog("%@", "didReceiveStream")
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
        NSLog("%@", "didStartReceivingResourceWithName")
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
        NSLog("%@", "didFinishReceivingResourceWithName")
    }

}
