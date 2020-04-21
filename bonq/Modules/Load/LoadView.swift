//
//  LoadView.swift
//  bonq
//
//  Created by Andrew Tokeley on 8/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import UIKit
import Viperit
import PureLayout

//MARK: LoadView Class
final class LoadView: UserInterface {
    
    // MARK: - Subviews
    lazy var backgroundImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "launchscreen_2436x1125"))
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        return view
    }()
    
    // MARK: - UIViewController
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(backgroundImage)
        self.view.addSubview(messageLabel)
        setConstraints()
    }
        
    func setConstraints() {
        backgroundImage.autoPinEdgesToSuperviewEdges()
        messageLabel.autoCenterInSuperview()
    }
}

//MARK: - LoadView API
extension LoadView: LoadViewApi {
    
    func displayMessage(text: String) {
        messageLabel.text = text
    }
    
}

// MARK: - LoadView Viper Components API
private extension LoadView {
    var presenter: LoadPresenterApi {
        return _presenter as! LoadPresenterApi
    }
    var displayData: LoadDisplayData {
        return _displayData as! LoadDisplayData
    }
}
