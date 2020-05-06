//
//  MenuModuleApi.swift
//  bonq
//
//  Created by Andrew Tokeley on 8/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Viperit
import MultipeerConnectivity

//MARK: - MenuRouter API
protocol MenuRouterApi: RouterProtocol {
    func navigateToGame(setup: GameSetupData)
}

//MARK: - MenuView API
protocol MenuViewApi: UserInterfaceProtocol {
    
    /**
        Let the view know whether to let the user press the play button. This will not be allowed until an opponent has been found.
    */
    func enablePlayButton(_ enable: Bool)
    
    /**
     Display a message on screen
     */
    func displayMessage(text: String)
    
    /**
     Show an interface that allows the user to accept or decline an invitation
     */
    func showInvitation(message: String, completion: ((Bool) -> Void)?)
    
    /**
     Display the local player's name
     */
    func displayLocalPlayerName(name: String)
    
    /**
     Show that there's an opponent available to play with
     */
    func showOpponentPlayer(name: String)
    
    /**
     Indicate that we are looking for a player.
     */
    func displaySearchingForPlayer()
}

//MARK: - MenuPresenter API
protocol MenuPresenterApi: PresenterProtocol {
    
    
    func didClickPlayButton()
    
    /**
     Called by the view when a user selects to invite a discovered player to a game
     */
    func didTapLocalProfileView()
    
    func didTapOpponentProfileView()
}

//MARK: - MenuInteractor API
protocol MenuInteractorApi: InteractorProtocol {
}
