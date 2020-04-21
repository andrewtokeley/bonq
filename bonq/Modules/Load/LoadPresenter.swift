//
//  LoadPresenter.swift
//  bonq
//
//  Created by Andrew Tokeley on 8/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import Viperit

// MARK: - LoadPresenter Class
final class LoadPresenter: Presenter {
    

    override func viewHasLoaded() {

        DispatchQueue.main.async {
            self.router.navigateToMenu()
        }
        
//        interactor.authenticateWithGameCentre { (viewController, error) in
//            if let vc = viewController {
//                self.view.viewController.present(vc, animated: true) {
//                    // success
//                }
//            } else {
//                if let e = error {
//                    self.view.displayMessage(text: e.localizedDescription)
//                } else {
//                    // logged in to Game Centre, can continue
//
//                    //interactor.registerLocalPlayerListener()
//                    self.router.navigateToMenu()
//                }
//            }
//        }
    }
}

// MARK: - LoadPresenter API
extension LoadPresenter: LoadPresenterApi {
}

// MARK: - Load Viper Components
private extension LoadPresenter {
    var view: LoadViewApi {
        return _view as! LoadViewApi
    }
    var interactor: LoadInteractorApi {
        return _interactor as! LoadInteractorApi
    }
    var router: LoadRouterApi {
        return _router as! LoadRouterApi
    }
}
