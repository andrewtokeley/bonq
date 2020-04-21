//
//  MatchRouter.swift
//  bonq
//
//  Created by Andrew Tokeley on 16/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import Viperit

// MARK: - MatchRouter class
final class MatchRouter: Router {
}

// MARK: - MatchRouter API
extension MatchRouter: MatchRouterApi {
}

// MARK: - Match Viper Components
private extension MatchRouter {
    var presenter: MatchPresenterApi {
        return _presenter as! MatchPresenterApi
    }
}
