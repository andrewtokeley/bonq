//
//  SettingsRouter.swift
//  bonq
//
//  Created by Andrew Tokeley on 19/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import Viperit

// MARK: - SettingsRouter class
final class SettingsRouter: Router {
}

// MARK: - SettingsRouter API
extension SettingsRouter: SettingsRouterApi {
}

// MARK: - Settings Viper Components
private extension SettingsRouter {
    var presenter: SettingsPresenterApi {
        return _presenter as! SettingsPresenterApi
    }
}
