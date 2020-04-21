//
//  GameModuleApi.swift
//  bonq
//
//  Created by Andrew Tokeley on 8/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Viperit

//MARK: - GameRouter API
protocol GameRouterApi: RouterProtocol {
    func showSideBar(within viewController: UIViewController, inside viewContainer: UIView, setupData: GameSideBarSetupData) -> GameSideBarPresenterApi
}

//MARK: - GameView API
protocol GameViewApi: UserInterfaceProtocol {
    func setSideBarOrientation(orientation: SideBarOrientation)
    func moveBat(direction: BatDirection)
    var sideBarContainer: UIView { get }
}

//MARK: - GamePresenter API
protocol GamePresenterApi: PresenterProtocol {
    func didSelectToMoveBat(direction: BatDirection)
    func ballHitBat(location: CGFloat)
    func ballHitGround(location: CGFloat)
}

//MARK: - GameInteractor API
protocol GameInteractorApi: InteractorProtocol {
}
