//
//  LoadRouter.swift
//  bonq
//
//  Created by Andrew Tokeley on 8/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import Viperit

// MARK: - LoadRouter class
final class LoadRouter: Router {
    
    func navigateToMenu() {
        let module = AppModules.menu.build()
        module.router.present(from: viewController, embedInNavController: false, presentationStyle: .fullScreen, transitionStyle: .crossDissolve, setupData: nil, completion: nil)
    }
}

// MARK: - LoadRouter API
extension LoadRouter: LoadRouterApi {
}

// MARK: - Load Viper Components
private extension LoadRouter {
    var presenter: LoadPresenterApi {
        return _presenter as! LoadPresenterApi
    }
}
