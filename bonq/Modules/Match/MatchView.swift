//
//  MatchView.swift
//  bonq
//
//  Created by Andrew Tokeley on 16/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import UIKit
import Viperit

//MARK: MatchView Class
final class MatchView: UserInterface {
}

//MARK: - MatchView API
extension MatchView: MatchViewApi {
}

// MARK: - MatchView Viper Components API
private extension MatchView {
    var presenter: MatchPresenterApi {
        return _presenter as! MatchPresenterApi
    }
    var displayData: MatchDisplayData {
        return _displayData as! MatchDisplayData
    }
}
