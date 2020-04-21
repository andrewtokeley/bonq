//
//  SettingsView.swift
//  bonq
//
//  Created by Andrew Tokeley on 19/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import UIKit
import Viperit

//MARK: SettingsView Class
final class SettingsView: UserInterface {
    
    // MARK: - Subviews
    lazy var backgroundImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "BackgroundImage"))
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "Close")?.changeColor(.app_buttonText), for: .normal)
        view.addTarget(self, action: #selector(closeButton(sender:)), for: .touchUpInside)
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.app_normal
        view.textColor = UIColor.app_textColourOnDark
        return view
    }()
    
    lazy var errorMessageLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.app_normal
        view.textColor = UIColor.red
        return view
    }()
    
    lazy var nameTextInput: UITextField = {
        let view = UITextField()
        view.backgroundColor = .app_buttonText
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor.app_buttonBackground.cgColor
        view.textColor = .app_buttonBackground
        view.delegate = self
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: Layout.buttonSize.height))
        view.leftView = paddingView
        view.leftViewMode = .always
        
        return view
    }()
    
    // MARK: - UIViewController
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = .app_backgroundDark
        
        //self.view.addSubview(backgroundImage)
        self.view.addSubview(closeButton)
        self.view.addSubview(messageLabel)
        self.view.addSubview(nameTextInput)
        self.view.addSubview(errorMessageLabel)
        
        setConstraints()
    }
        
    func setConstraints() {
        //backgroundImage.autoPinEdgesToSuperviewEdges()
        
        closeButton.autoPinEdge(toSuperviewEdge: .top, withInset: Layout.spacerNormal)
        closeButton.autoPinEdge(toSuperviewEdge: .right, withInset: Layout.spacerNormal)
        closeButton.autoSetDimension(.width, toSize: 40)
        closeButton.autoSetDimension(.height, toSize: 40)
        
        messageLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 50)
        messageLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        
        nameTextInput.autoPinEdge(.top, to: .bottom, of: messageLabel, withOffset: Layout.spacerSmall)
        nameTextInput.autoAlignAxis(toSuperviewAxis: .vertical)
        nameTextInput.autoSetDimension(.width, toSize: 300)
        nameTextInput.autoSetDimension(.height, toSize: Layout.buttonSize.height)
        
        errorMessageLabel.autoPinEdge(.top, to: .bottom, of: nameTextInput, withOffset: Layout.spacerSmall)
        errorMessageLabel.autoAlignAxis(toSuperviewAxis: .vertical)
    }
    
    // MARK: Event
    
    @objc func closeButton(sender: UIButton) {
        nameTextInput.resignFirstResponder()
        presenter.didSelectClose()
    }
    
}

// MARK: - TextFieldDelegate
extension SettingsView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        presenter.didUpdateName(name: textField.text)
    }
}

//MARK: - SettingsView API
extension SettingsView: SettingsViewApi {
    
    func displayPlayerName(name: String) {
        nameTextInput.text = name
    }
    
    func displayMessage(message: String) {
        messageLabel.text = message
    }
    
    func displayErrorMessage(message: String) {
        errorMessageLabel.text = message
    }
}


// MARK: - SettingsView Viper Components API
private extension SettingsView {
    var presenter: SettingsPresenterApi {
        return _presenter as! SettingsPresenterApi
    }
    var displayData: SettingsDisplayData {
        return _displayData as! SettingsDisplayData
    }
}
