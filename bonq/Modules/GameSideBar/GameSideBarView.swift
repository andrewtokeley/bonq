//
//  GameSideBarView.swift
//  bonq
//
//  Created by Andrew Tokeley on 12/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import UIKit
import Viperit

//MARK: GameSideBarView Class
final class GameSideBarView: UserInterface {
    
    // If players have their phones next to each other their sidebars should be on opposite sides to eachother. Subviews may be orientated and aligned differently depending on the sidebar's orientation itself.
    var orientation = SideBarOrientation.left
    
    // MARK: - Initialisers

    
    // MARK: - Subviews
    
    lazy var player1NameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.app_normal
        view.textColor = .app_textColourOnLight
        return view
    }()
    
    lazy var player1ScoreLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.app_largeSemiBold
        view.textColor = .app_textColourOnLight
        return view
    }()
    
    lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .app_buttonBackground
        return view
    }()
    
    lazy var player2NameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.app_normal
        view.textColor = .app_textColourOnLight
        return view
    }()
    
    lazy var player2ScoreLabel: UILabel = {
        let view = UILabel()
        view.textColor = .app_textColourOnLight
        view.font = UIFont.app_largeSemiBold
        return view
    }()
    
    // MARK: - UIViewController
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = .app_backgroundLight
        
        self.view.addSubview(player1NameLabel)
        self.view.addSubview(player1ScoreLabel)
        
        self.view.addSubview(divider)
        
        self.view.addSubview(player2NameLabel)
        self.view.addSubview(player2ScoreLabel)
        
        setConstraints()
    }
    
    private func setConstraints() {
        player1NameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: Layout.spacerLarge)
        player1NameLabel.autoPinEdge(toSuperviewEdge: .left, withInset: Layout.spacerNormal)
        player1NameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: Layout.spacerNormal)
        
        player1ScoreLabel.autoPinEdge(.top, to: .bottom, of: player1NameLabel, withOffset: Layout.spacerNormal)
        player1ScoreLabel.autoPinEdge(toSuperviewEdge: .left, withInset: Layout.spacerNormal)
        player1ScoreLabel.autoPinEdge(toSuperviewEdge: .right, withInset: Layout.spacerNormal)
        
        divider.autoSetDimension(.height, toSize: 1)
        divider.autoPinEdge(.top, to: .bottom, of: player1ScoreLabel, withOffset: Layout.spacerNormal)
        divider.autoPinEdge(toSuperviewEdge: .left, withInset: Layout.spacerNormal)
        divider.autoPinEdge(toSuperviewEdge: .right, withInset: Layout.spacerNormal)

        player2NameLabel.autoPinEdge(.top, to: .bottom, of: divider, withOffset: Layout.spacerNormal)
        player2NameLabel.autoPinEdge(toSuperviewEdge: .left, withInset: Layout.spacerNormal)
        player2NameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: Layout.spacerNormal)
        
        player2ScoreLabel.autoPinEdge(.top, to: .bottom, of: player2NameLabel, withOffset: Layout.spacerNormal)
        player2ScoreLabel.autoPinEdge(toSuperviewEdge: .left, withInset: Layout.spacerNormal)
        player2ScoreLabel.autoPinEdge(toSuperviewEdge: .right, withInset: Layout.spacerNormal)
        
        
    }
    
}

//MARK: - GameSideBarView API
extension GameSideBarView: GameSideBarViewApi {
    
    func setOrientation(orientation: SideBarOrientation) {
        let alignment = orientation == .left ? NSTextAlignment.right : NSTextAlignment.left
        player1NameLabel.textAlignment = alignment
        player1ScoreLabel.textAlignment = alignment
        player2NameLabel.textAlignment = alignment
        player2ScoreLabel.textAlignment = alignment
    }
    
    func displayScore(player: Player, score: Int) {
        if player == .local {
            player1ScoreLabel.text = String(score)
        } else if player == .opponent {
            player2ScoreLabel.text = String(score)
        }
    }
    
    func displayName(player: Player, name: String) {
        if player == .local {
            player1NameLabel.text = name
        } else if player == .opponent {
            player2NameLabel.text = name
        }
    }
    
}

// MARK: - GameSideBarView Viper Components API
private extension GameSideBarView {
    var presenter: GameSideBarPresenterApi {
        return _presenter as! GameSideBarPresenterApi
    }
    var displayData: GameSideBarDisplayData {
        return _displayData as! GameSideBarDisplayData
    }
}
