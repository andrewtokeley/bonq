//
//  GameSideBarDelegate.swift
//  bonq
//
//  Created by Andrew Tokeley on 29/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation

enum GameSideBarAction {
    case quit
}

protocol GameSideBarDelegate {
    func gameSideBar(_ presenter: GameSideBarPresenterApi, selectedAction action: GameSideBarAction)
    func gameSideBarOrientation() -> SideBarOrientation
}
