//
//  MCSessionStateExtension.swift
//  bonq
//
//  Created by Andrew Tokeley on 18/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import MultipeerConnectivity

extension MCSessionState {
    var name: String {
        switch self {
        case .connected:
            return "Connected"
        case .connecting:
            return "Connecting"
        case .notConnected:
            return "Not Connected"
        default:
            return "Unknown"
        }
    }
}
