//
//  SettingsInteractor.swift
//  bonq
//
//  Created by Andrew Tokeley on 19/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import Viperit

// MARK: - SettingsInteractor Class
final class SettingsInteractor: Interactor {
    
    private let service: SettingsServiceInterface = SettingsService()
    
    private var currentSettings: Settings?
}

// MARK: - SettingsInteractor API
extension SettingsInteractor: SettingsInteractorApi {
    
    func saveSettings(settings: Settings, completion: ((Error?) -> Void)?) {
        service.save(settings: settings) { (error) in
            if self.currentSettings?.name != settings.name {
                
                // this won't work because we're not connected to the same session yet.
                
                // let the opponent know you've changed your name
                //let profileUpdateMessage = ProfileUpdateMessage(name: settings.name)
                //PeerToPeerService.instance.sendMessage(message: profileUpdateMessage)
                
            }
            completion?(error)
        }
    }
    
    func getSettings(completion: ((Settings) -> Void)?) {
        service.get { (settings) in
            self.currentSettings = settings
            completion?(settings)
        }
    }
    
}

// MARK: - Interactor Viper Components Api
private extension SettingsInteractor {
    var presenter: SettingsPresenterApi {
        return _presenter as! SettingsPresenterApi
    }
}
