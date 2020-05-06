//
//  GameSideBarModuleApi.swift
//  bonq
//
//  Created by Andrew Tokeley on 12/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Viperit

//MARK: - GameSideBarRouter API
protocol GameSideBarRouterApi: RouterProtocol {
}

//MARK: - GameSideBarView API
protocol GameSideBarViewApi: UserInterfaceProtocol {
    func setOrientation(orientation: SideBarOrientation)
    func displayScore(player: Player, score: Int)
    func displayName(player: Player, name: String)
}

//MARK: - GameSideBarPresenter API
protocol GameSideBarPresenterApi: PresenterProtocol {
    func didSelectQuit()
}

//MARK: - GameSideBarInteractor API
protocol GameSideBarInteractorApi: InteractorProtocol {
}
