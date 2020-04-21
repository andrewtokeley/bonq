//
//  MatchInteractor.swift
//  bonq
//
//  Created by Andrew Tokeley on 16/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import Viperit

// MARK: - MatchInteractor Class
final class MatchInteractor: Interactor {
}

// MARK: - MatchInteractor API
extension MatchInteractor: MatchInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension MatchInteractor {
    var presenter: MatchPresenterApi {
        return _presenter as! MatchPresenterApi
    }
}
