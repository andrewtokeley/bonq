//
//  SettingsDelegate.swift
//  bonq
//
//  Created by Andrew Tokeley on 3/05/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation

protocol SettingsDelegate {
    func settings(_ SettingsPresenter: SettingsPresenterApi, didUpdateName name: String)
}
