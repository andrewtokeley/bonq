//
//  GameInteractor.swift
//  bonq
//
//  Created by Andrew Tokeley on 8/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import Viperit

// MARK: - GameInteractor Class
final class GameInteractor: Interactor {
}

// MARK: - GameInteractor API
extension GameInteractor: GameInteractorApi {
    
    func tellOpponentTheScores(theirScore: Int, yourScore: Int) {
        let scoreMessage = ScoreMessage(score: theirScore, opponentScore: yourScore)
        PeerToPeerService.instance.sendMessage(message: scoreMessage)
    }
    
    func tellOpponentBallIsComing(xLocationAsAProportionOfWidth widthProportion: CGFloat, vector: CGVector) {
        
        let ballExitMessage = BallExitMessage(widthProportion: widthProportion, vector: vector)
        PeerToPeerService.instance.sendMessage(message: ballExitMessage)
    }
}

// MARK: - Interactor Viper Components Api
private extension GameInteractor {
    var presenter: GamePresenterApi {
        return _presenter as! GamePresenterApi
    }
}
