//
//  SettingsPresenter.swift
//  bonq
//
//  Created by Andrew Tokeley on 19/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import Viperit

// MARK: - SettingsPresenter Class
final class SettingsPresenter: Presenter {
    var settings: Settings!
    
    override func viewHasLoaded() {

        self.view.displayMessage(message: "What's your gamer name, partner?")
        
        interactor.getSettings { (settings) in
            self.view.displayPlayerName(name: settings.name)
            self.settings = settings
        }
        
    }
}

// MARK: - SettingsPresenter API
extension SettingsPresenter: SettingsPresenterApi {
    
    func didUpdateName(name: String?) {
        if let name = name {
            settings.name = name
        } else {
            view.displayErrorMessage(message: "Hey, you didn't enter a name!")
        }
    }
    
    func didSelectClose() {
        
        interactor.saveSettings(settings: self.settings) { (error) in
            if let error = error {
                self.view.displayErrorMessage(message: error.localizedDescription)
            } else {
                // successfully saved
                self.router.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

// MARK: - Settings Viper Components
private extension SettingsPresenter {
    var view: SettingsViewApi {
        return _view as! SettingsViewApi
    }
    var interactor: SettingsInteractorApi {
        return _interactor as! SettingsInteractorApi
    }
    var router: SettingsRouterApi {
        return _router as! SettingsRouterApi
    }
}
