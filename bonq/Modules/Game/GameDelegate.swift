//
//  GameDelegate.swift
//  bonq
//
//  Created by Andrew Tokeley on 29/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation

protocol GameDelegate {
    
    /**
     Lets the delegate (probably the SideBarPresenter) know that the score has changed for one of the players.
     */
    func gameDelegate(_ gameDelegate: GamePresenterApi, updatedScore score: Int, forPlayer player: Player)
    
}
