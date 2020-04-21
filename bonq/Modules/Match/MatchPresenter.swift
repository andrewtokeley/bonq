//
//  MatchPresenter.swift
//  bonq
//
//  Created by Andrew Tokeley on 16/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import Viperit

// MARK: - MatchPresenter Class
final class MatchPresenter: Presenter {
}

// MARK: - MatchPresenter API
extension MatchPresenter: MatchPresenterApi {
}

// MARK: - Match Viper Components
private extension MatchPresenter {
    var view: MatchViewApi {
        return _view as! MatchViewApi
    }
    var interactor: MatchInteractorApi {
        return _interactor as! MatchInteractorApi
    }
    var router: MatchRouterApi {
        return _router as! MatchRouterApi
    }
}
