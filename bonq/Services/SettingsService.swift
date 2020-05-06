//
//  SettingsService.swift
//  bonq
//
//  Created by Andrew Tokeley on 19/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

enum SettingsServiceError: Error {
    case ErrorSavingState(String)
}

protocol SettingsServiceInterface {
    func get(completion: ((Settings) -> Void)?)
    func save(settings: Settings, completion: ((SettingsServiceError?) -> Void)?)
}

class SettingsService {
    private let KEY_NAME = "name"
    private let KEY_PEERID = "peerId"
}

extension SettingsService: SettingsServiceInterface {
    
    func get(completion: ((Settings) -> Void)?) {
        
        // defaults
        var name: String!
        var peerId: MCPeerID!
        
        let userDefault = UserDefaults.standard
        
        // Name
        if let savedName = userDefault.string(forKey: KEY_NAME) {
            name = savedName
        } else {
            name = UIDevice.current.name
        }
        
        // Try and read from a saved version - apparently it's better to keep the PeerID across sessions if possible, for stability.
        if let peerIdData = userDefault.data(forKey: KEY_PEERID) {
            peerId = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(peerIdData) as? MCPeerID
        }
        
        // If there is no saved PeerId, we couldn't restore it, or it's saved but with a different displayName, then we should just create a new one
        if peerId == nil || peerId?.displayName != name {
            peerId = MCPeerID(displayName: name)
        }
        
        completion?(Settings(peerId: peerId, name: name))
    }
    
    func save(settings: Settings, completion: ((SettingsServiceError?) -> Void)?) {
        
        guard settings.name.count > 0 else {
            completion?(SettingsServiceError.ErrorSavingState("Name must be set."))
            return
        }
        
        let userDefault = UserDefaults.standard
        
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: settings.peerId, requiringSecureCoding: false) {
            
            userDefault.set(data, forKey: KEY_PEERID)
            userDefault.set(settings.name, forKey: KEY_NAME)
            
            completion?(nil)
            
        } else {
            completion?(SettingsServiceError.ErrorSavingState("Error saving State: couldn't archive peerId."))
        }
    }
    

}
