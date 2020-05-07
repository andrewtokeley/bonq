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
    
    /**
     Local peer
     */
    var localPeerID: MCPeerID!
    
    /**
     This will be the last successfully found peer
     */
    var opponentPeerID: MCPeerID? {
        return nearbyPeers.last
    }
    
    /**
     Array of all the current nearby peers
     */
    var nearbyPeers = [MCPeerID]()
    
    /**
    Active session
     */
    var session : MCSession!
    
    /**
     Flag to track whether the local peer is in the process of sending an invite.
     */
    private var didSendInvite: Bool = false
    
    var matchDelegate: PeerToPeerServiceMatchDelegate?
    var gameDelegate: PeerToPeerServiceGameDelegate?
    
    override init() {
        super.init()
        self.resetService()
    }

    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    private func stopServices() {
        guard self.serviceBrowser != nil && self.serviceAdvertiser != nil else {
            return
        }
        
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    private func startService() {
        guard self.serviceBrowser != nil && self.serviceAdvertiser != nil else {
            return
        }
        
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
        
    }
    
    func resetService() {

        // clear out any peers you may have found before. We'll pick them up again once the service starts again, if they're still around.
        nearbyPeers.removeAll()
        
        self.stopServices()

        // We call the settings service to get the name we want to attribute to the LocalPeer
        let settingsService = SettingsService()
        settingsService.get { (settings) in
            
            // reset the local peer
            self.localPeerID = settings.peerId
        
            self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: self.localPeerID, discoveryInfo: nil, serviceType: self.SERVICE_ID)
            self.serviceBrowser = MCNearbyServiceBrowser(peer: self.localPeerID, serviceType: self.SERVICE_ID)
            
            self.session = MCSession(peer: self.localPeerID, securityIdentity: nil, encryptionPreference: .required)
            self.session.delegate = self

            self.startService()
        }
    }
    
    /**
        Invite a nearby player to connect to the shared session.
     */
    func invitePlayer(peer: MCPeerID, invitationMessage: String) {
        
        // remember that you've initiated the invite (used in session:didStateChange)
        self.didSendInvite = true
        
        let messageAsData = invitationMessage.data(using: .utf8)
        self.serviceBrowser.invitePeer(peer, to: self.session, withContext: messageAsData, timeout: 10)
    }

    /**
     Sends a message to the last discovered peer
     */
    func sendMessage(message: NSCoding) {
        if let lastDiscoveredPeer = nearbyPeers.last {
            sendMessage(toPeer: lastDiscoveredPeer, message: message)
        }
    }
    
    /**
     Sends a message to the given peer
     */
    func sendMessage(toPeer peer: MCPeerID, message: NSCoding) {
        
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: message, requiringSecureCoding: false) {
            
            do {
                try self.session.send(data, toPeers: [peer], with: .reliable)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
    }
    
    /**
     Disconnect's the local peer from the session
     */
    func disconnectFromSession() {
        session.disconnect()
    }
    
    /**
     Convenience method to ensure delegate callbacks are executed on the main thread. This is because it's likely the delegates will do actions on the UI which must be done on the main thread.
     */
    private func threadSafeCallback(callback: @escaping () -> Void) {
        DispatchQueue.main.async {
            callback()
        }
    }
}

// MARK: - MCNearbyServiceAdvertiserDelegate

extension PeerToPeerService : MCNearbyServiceAdvertiserDelegate {

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        // not sure whether I need to worry about this... going to ignore :-)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        // Record that you're now in the state of receiving an invitation
        self.didSendInvite = false
        
        // Default invitation message, in case we can't decode what the caller passed in via the context.
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

// MARK: - MCNearbyServiceBrowserDelegate

extension PeerToPeerService : MCNearbyServiceBrowserDelegate {

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        
        print("didNotStartBrowsingForPeers")
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        self.nearbyPeers.append(peerID)
        
        //self.opponentPeerID = peerID
        
        threadSafeCallback() {
            self.matchDelegate?.peerToPeer(self, foundNearbyPlayer: peerID)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        self.nearbyPeers.removeAll { $0 == peerID }
        
        threadSafeCallback() {
            self.matchDelegate?.peerToPeer(self, lostNearbyPlayer: peerID)
        }
    }

}

//MARK: - MCSessionDelegate

extension PeerToPeerService : MCSessionDelegate {

    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        // For some reason, the session:didChange method is also called when you didn't send the invite and the other person did. We only want to let the GameDelegate know if this connection/disconnection was as a result of your opponent responding to your invite, hence we check the self.didSendInvite flag.
        if self.didSendInvite {
            
            threadSafeCallback() {
                if state == .connected {
                        self.matchDelegate?.peerToPeer(self, invitationAcceptedFromPlayer: peerID, accepted: true)
                } else if state == .notConnected {
                    self.matchDelegate?.peerToPeer(self, invitationAcceptedFromPlayer: peerID, accepted: false)
                }
            }
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
            
        if let message = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) {
            
            if let scoreMessage = message as? ScoreMessage {
                // this message is coming from your opponent to tell you to update the scores you are displaying.
                threadSafeCallback {
                    
                    // update your own score
                    self.gameDelegate?.peerToPeer(self, scoreChanged: scoreMessage.score, forPlayer: .local)
                    
                    // update the score of your opponent
                    self.gameDelegate?.peerToPeer(self, scoreChanged: scoreMessage.opponentScore, forPlayer: .opponent)
                }
                
            } else if let ballExitMessage = message as? BallExitMessage {
                
                // this message is coming from the opponent to tell you that the ball is leaving their screen at the given location and vector. 
                threadSafeCallback {
                    self.gameDelegate?.peerToPeer(self, ballLeavingOpponentSceneAtWidthProportion: ballExitMessage.widthProportion, vector: ballExitMessage.vector)

                }
            }
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
