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
    
    let service: SettingsServiceInterface = SettingsService()
    
}

// MARK: - SettingsInteractor API
extension SettingsInteractor: SettingsInteractorApi {
    
    func saveSettings(settings: Settings, completion: ((Error?) -> Void)?) {
        service.save(settings: settings) { (error) in
            completion?(error)
        }
    }
    
    func getSettings(completion: ((Settings) -> Void)?) {
        service.get { (settings) in
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
