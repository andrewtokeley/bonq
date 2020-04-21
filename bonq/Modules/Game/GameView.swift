//
//  GameView.swift
//  bonq
//
//  Created by Andrew Tokeley on 8/04/20.
//Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import UIKit
import Viperit
import SpriteKit

//MARK: GameView Class
final class GameView: UserInterface {
    
    private var sideBarOrientation: SideBarOrientation = .left
    
    //MARK: - Subviews
    
    lazy var sideBarContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    lazy var gameSurfaceView: SKView = {
        let view = SKView()
        view.allowsTransparency = true
        view.ignoresSiblingOrder = true
        
        view.showsFPS = true
        view.showsNodeCount = true

        return view
    }()
    
    // MARK: - UIViewController
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if gameSurfaceView.scene == nil {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            gameSurfaceView.presentScene(scene)
            
            scene.gameSceneDelegate = self
        }
    }
    
    override func loadView() {
        super.loadView()
     
        self.view.backgroundColor = .app_backgroundLight
        self.view.addSubview(gameSurfaceView)
        self.view.addSubview(sideBarContainer)
        self.setConstraints()
    }
    
    private func setConstraints() {
        
        sideBarContainer.autoPinEdge(toSuperviewEdge: .top)
        sideBarContainer.autoPinEdge(toSuperviewEdge: .bottom)
        sideBarContainer.autoSetDimension(.width, toSize: 200)
        sideBarContainer.autoPinEdge(toSuperviewEdge: sideBarOrientation == .left ? .left : .right)
        
        gameSurfaceView.autoPinEdge(toSuperviewEdge: .top)
        gameSurfaceView.autoPinEdge(toSuperviewEdge: .bottom)
        if sideBarOrientation == .left {
            gameSurfaceView.autoPinEdge(.left, to: .right, of: sideBarContainer, withOffset: 0)
            gameSurfaceView.autoPinEdge(toSuperviewEdge: .right)
        } else if sideBarOrientation == .right {
            gameSurfaceView.autoPinEdge(toSuperviewEdge: .left)
            gameSurfaceView.autoPinEdge(.right, to: .left, of: sideBarContainer, withOffset: 0)
        }

    }
    
    // MARK: - Key Presses
    
    override var keyCommands: [UIKeyCommand]? {
        
        let up = UIKeyCommand(input: UIKeyCommand.inputUpArrow, modifierFlags: [], action: #selector(keyPress))
        
        let left = UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: [], action: #selector(keyPress))
        
        let right = UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: [], action: #selector(keyPress))
        
        return [left, right, up]
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc private func keyPress(sender: UIKeyCommand) {
        if let input = sender.input {
            switch input {
            case UIKeyCommand.inputLeftArrow:
                presenter.didSelectToMoveBat(direction: .left)
                return
            case UIKeyCommand.inputRightArrow:
                presenter.didSelectToMoveBat(direction: .right)
                return
            case UIKeyCommand.inputUpArrow:
                presenter.didSelectToMoveBat(direction: .stop)
                return
            default: return
            }
        }
    }
}

//MARK: - GameView API
extension GameView: GameViewApi {
    
    func setSideBarOrientation(orientation: SideBarOrientation) {
        sideBarOrientation = orientation
    }
    
    func moveBat(direction: BatDirection) {
        (gameSurfaceView.scene as? GameScene)?.bat.move(direction)
    }
}

extension GameView: GameSceneDelegate {
    func gameScene(_ grameScene: SKScene, ballHitBatAt location: CGFloat) {
        presenter.ballHitBat(location: location)
    }
    
    func gameScene(_ grameScene: SKScene, ballHitGroundAt location: CGFloat) {
        presenter.ballHitGround(location: location)
    }
}


// MARK: - GameView Viper Components API
private extension GameView {
    var presenter: GamePresenterApi {
        return _presenter as! GamePresenterApi
    }
    var displayData: GameDisplayData {
        return _displayData as! GameDisplayData
    }
}
