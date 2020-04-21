//
//  Match.swift
//  bonq
//
//  Created by Andrew Tokeley on 12/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import GameKit

extension GKMatch {
    
    /** Returns the opponent player instance, if it exists. Otherwise nil.
    */
    var opponentPlayer: GKPlayer? {
        let otherPlayers = self.players.filter { $0 != GKLocalPlayer.local }
        return otherPlayers.first
    }
    
}
