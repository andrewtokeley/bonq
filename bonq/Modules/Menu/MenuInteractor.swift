//
//  MenuInteractor.swift
//  bonq
//
//  Created by Andrew Tokeley on 8/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import Viperit

// MARK: - MenuInteractor Class
final class MenuInteractor: Interactor {
}

// MARK: - MenuInteractor API
extension MenuInteractor: MenuInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension MenuInteractor {
    var presenter: MenuPresenterApi {
        return _presenter as! MenuPresenterApi
    }
}
