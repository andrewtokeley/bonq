//
//  GameDelegate.swift
//  bonq
//
//  Created by Andrew Tokeley on 12/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation

protocol MatchDelegate {
    func match(updatedScore score: Int, forPlayer player: Player)
    func match(setSideBarOrientation orientation: SideBarOrientation)
}
