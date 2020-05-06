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
    func moveBat(direction: BatMovement)
    func serveBall(vector: CGVector)
    func prepareBallForServe()
    
    /**
    Let the view know that a ball is about to enter the screen.
    
    - Parameters:
       - opponentXLocationAsAProportionOfWidth: value between 0.0 and 1.0 that determines how far across the screen the ball left the screen. For example, 0.5 means it left the screen in the middle. This makes it easier to translate where on the opponents screen the ball enters, as some screens will differ in size.
       - vector: the direction vector at which the ball was moving
    */
    func receiveBallFromOpponent(opponentXLocationAsAProportionOfWidth widthProportion: CGFloat, opponentVector: CGVector)
    
    func prepareForQuit()
    var sideBarContainer: UIView { get }
    var gameSurfaceWidth: CGFloat { get }
}

//MARK: - GamePresenter API
protocol GamePresenterApi: PresenterProtocol {
    
    func didSelectToMoveBat(direction: BatMovement)
    func ballHitBat(location: CGFloat)
    func ballHitGround(location: CGFloat)
    
    func didSelectToServe(vector: CGVector)
    
    /**
     Called from the View to let the Presenter know the ball has left the screen.
     
     - Parameters:
        - xLocationAsAProportionOfWidth: value between 0.0 and 1.0 that determines how far across the screen the ball left the screen. For example, 0.5 means it left the screen in the middle. This makes it easier to translate where on the opponents screen the ball enters, as some screens will differ in size.
        - vector: the direction vector at which the ball was moving
     */
    func ballHasLeftScreen(xLocationAsAProportionOfWidth widthProportion: CGFloat, vector: CGVector)
    
    func viewHasCreatedScene()
}

//MARK: - GameInteractor API
protocol GameInteractorApi: InteractorProtocol {
    func tellOpponentTheScores(theirScore: Int, yourScore: Int)
    
    /**
     Sends a message to the opponent to let them know that a ball left their opponent's screen and is about to enter their screen.
     
     - Parameters:
        - xLocationAsAProportionOfWidth: value between 0.0 and 1.0 that determines how far across the screen the ball left the screen. For example, 0.5 means it left the screen in the middle. This makes it easier to translate where on the opponents screen the ball enters, as some screens will differ in size.
        - vector: the direction vector at which the ball was moving
     */
    func tellOpponentBallIsComing(xLocationAsAProportionOfWidth widthProportion: CGFloat, vector: CGVector)
}
