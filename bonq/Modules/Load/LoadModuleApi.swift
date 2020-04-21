//
//  LoadModuleApi.swift
//  bonq
//
//  Created by Andrew Tokeley on 8/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Viperit

//MARK: - LoadRouter API
protocol LoadRouterApi: RouterProtocol {
    func navigateToMenu()
}

//MARK: - LoadView API
protocol LoadViewApi: UserInterfaceProtocol {
    func displayMessage(text: String)
}

//MARK: - LoadPresenter API
protocol LoadPresenterApi: PresenterProtocol {
}

//MARK: - LoadInteractor API
protocol LoadInteractorApi: InteractorProtocol {
//    func authenticateWithGameCentre(completion: ((UIViewController?, Error?) -> Void)?)
//    func registerLocalPlayerListener()
}
