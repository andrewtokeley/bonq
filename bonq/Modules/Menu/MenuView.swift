//
//  MenuView.swift
//  bonq
//
//  Created by Andrew Tokeley on 8/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import UIKit
import Viperit

//MARK: MenuView Class
final class MenuView: UserInterface {

    // MARK: - Variables
    private let PLAYER_LOCAL = 0
    private let PLAYER_OPPONENT = 1
    
    // MARK: - Subviews
    lazy var backgroundImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "BackgroundImage"))
        return view
    }()
    
    lazy var localPlayerIcon: ProfileView = {
        let view = ProfileView()
        view.tag = PLAYER_LOCAL
        
        view.isUserInteractionEnabled = true
        
        view.setSelectedState(isSelected: false)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapPlayerIcon(sender:)))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    lazy var opponentPlayerIcon: ProfileView = {
        let view = ProfileView()
        
        // default to invisible, will be turned on if a peer is found
        view.tag = PLAYER_OPPONENT
        
        view.isUserInteractionEnabled = true
        view.setSelectedState(isSelected: false)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapPlayerIcon(sender:)))
        view.addGestureRecognizer(tap)

        return view
    }()
    
    lazy var playButton: UIButton = {
        let view = UIButton()
        view.setTitle("Play", for: .normal)
        view.backgroundColor = .app_buttonBackground
        view.setTitleColor(.app_buttonText, for: .normal)
        view.setTitleColor(.app_buttonTextDisabled, for: .disabled)
        view.addTarget(self, action: #selector(clickPlay(sender:)), for: .touchUpInside)
        return view
    }()
        
    lazy var message: UILabel = {
        let view = UILabel()
        view.textColor = .app_textColourOnDark
        view.font = UIFont.app_normal
        return view
    }()
    
    lazy var vsLabel: UILabel = {
        let view = UILabel()
        view.textColor = .app_textColourOnDark
        view.font = UIFont.app_largeSemiBold
        view.text = "VS"
        return view
    }()
    
    // MARK: - UIViewController
    
    // TEMP
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(backgroundImage)
        
        self.view.addSubview(localPlayerIcon)
        self.view.addSubview(vsLabel)
        self.view.addSubview(opponentPlayerIcon)
        
        self.view.addSubview(playButton)
        self.view.addSubview(message)
        
        setConstraints()
    }
        
    func setConstraints() {
        
        backgroundImage.autoPinEdgesToSuperviewEdges()
        
        vsLabel.autoCenterInSuperview()
        
        localPlayerIcon.autoAlignAxis(toSuperviewAxis: .horizontal)
        localPlayerIcon.autoSetDimension(.width, toSize: 70)
        localPlayerIcon.autoSetDimension(.height, toSize: 100)
        localPlayerIcon.autoPinEdge(.right, to: .left, of: vsLabel, withOffset: -2 * Layout.spacerLarge)

        opponentPlayerIcon.autoAlignAxis(toSuperviewAxis: .horizontal)
        opponentPlayerIcon.autoSetDimension(.width, toSize: 70)
        opponentPlayerIcon.autoSetDimension(.height, toSize: 100)
        opponentPlayerIcon.autoPinEdge(.left, to: .right, of: vsLabel, withOffset: 2 * Layout.spacerLarge)

        playButton.autoAlignAxis(toSuperviewAxis: .vertical)
        playButton.autoPinEdge(.top, to: .bottom, of: localPlayerIcon, withOffset: Layout.spacerLarge)
        playButton.autoSetDimension(.width, toSize: Layout.buttonSize.width)
        playButton.autoSetDimension(.height, toSize: Layout.buttonSize.height)

        message.autoAlignAxis(toSuperviewAxis: .vertical)
        message.autoPinEdge(toSuperviewEdge: .bottom, withInset: 2 * Layout.spacerLarge)

    }
    
    // MARK: Events
    
    @objc func clickPlay(sender: UIButton) {
        presenter.didClickPlayButton()
    }
    
    @objc func tapPlayerIcon(sender: UITapGestureRecognizer) {
        
        if sender.view?.tag == PLAYER_LOCAL {
            presenter.didTapLocalProfileView()
        } else if sender.view?.tag == PLAYER_OPPONENT {
            presenter.didTapOpponentProfileView()
        }
    }
    
}


//MARK: - MenuView API
extension MenuView: MenuViewApi {
    
    func enablePlayButton(_ enabled: Bool) {
        playButton.isEnabled = enabled
    }
    
    func displayMessage(text: String) {
        self.message.text = text
    }
    
    func showInvitation(message: String, completion: ((Bool) -> Void)?) {
        let actionSheet = UIAlertController(title: "Join Game", message: message, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (action) in
            completion?(true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Decline", style: .default, handler: { (action) in
            completion?(false)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func displayLocalPlayerName(name: String) {
        localPlayerIcon.profileName.text = name
    }
    
    func showOpponentPlayer(name: String) {
        opponentPlayerIcon.profileName.text = name
    }
    
    func displaySearchingForPlayer() {
        opponentPlayerIcon.profileName.text = "Searching..."
    }
    
}

// MARK: - MenuView Viper Components API
private extension MenuView {
    var presenter: MenuPresenterApi {
        return _presenter as! MenuPresenterApi
    }
    var displayData: MenuDisplayData {
        return _displayData as! MenuDisplayData
    }
}
