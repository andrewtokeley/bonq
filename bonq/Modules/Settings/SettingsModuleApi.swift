//
//  SettingsModuleApi.swift
//  bonq
//
//  Created by Andrew Tokeley on 19/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Viperit

//MARK: - SettingsRouter API
protocol SettingsRouterApi: RouterProtocol {
}

//MARK: - SettingsView API
protocol SettingsViewApi: UserInterfaceProtocol {
    func displayPlayerName(name: String)
    func displayMessage(message: String)
    func displayErrorMessage(message: String)
}

//MARK: - SettingsPresenter API
protocol SettingsPresenterApi: PresenterProtocol {
    func didUpdateName(name: String?)
    func didSelectClose()
}

//MARK: - SettingsInteractor API
protocol SettingsInteractorApi: InteractorProtocol {
    func saveSettings(settings: Settings, completion: ((Error?) -> Void)?)
    func getSettings(completion: ((Settings) -> Void)?)
}
