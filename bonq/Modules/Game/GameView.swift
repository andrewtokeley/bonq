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
    
    var gameSurfaceWidth: CGFloat {
        return gameSurfaceView.frame.width
    }
    
    //MARK: - Subviews
    
    var scene: GameScene? {
        return (gameSurfaceView.scene as? GameScene)
    }
    
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

    lazy var leftBatMovePressZone: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        
        let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(moveLeft))
        holdGesture.minimumPressDuration = 0
        view.addGestureRecognizer(holdGesture)
        
        return view
    }()
    
    lazy var rightBatMovePressZone: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        
        let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(moveRight))
        holdGesture.minimumPressDuration = 0
        view.addGestureRecognizer(holdGesture)
        
        return view
    }()
    
    // MARK: - Events
    
    @objc func angleSwipeHandler(sender: AngleSwipeGestureRecognizer) {
        if sender.state == .ended {
            presenter.didSelectToServe(vector: sender.vector.normalized())
        }
    }
    
    @objc func moveLeft(sender: UILongPressGestureRecognizer) {
        if let bat = scene?.bat {
            if sender.state == .began {
                bat.move(.left)
            } else if sender.state == .ended && bat.moveDirection == .left {
                bat.move(.brake)
            }
        }
    }
    
    @objc func moveRight(sender: UILongPressGestureRecognizer) {
        if let bat = scene?.bat {
            if sender.state == .began {
                bat.move(.right)
            } else if sender.state == .ended && bat.moveDirection == .right {
                bat.move(.brake)
            }
        }
    }
    
    // MARK: - UIViewController
    
    // TEMP
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if gameSurfaceView.scene == nil {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            gameSurfaceView.presentScene(scene)
            
            scene.gameSceneDelegate = self
            
            presenter.viewHasCreatedScene()
        }
    }
    
    override func loadView() {
        super.loadView()
     
        // serve gesture
        let serveGesture = AngleSwipeGestureRecognizer(target: self, action: #selector(angleSwipeHandler))
        serveGesture.delegate = self
        serveGesture.angleSwipeDelegate = self
        self.view.addGestureRecognizer(serveGesture)
        
        
        self.view.backgroundColor = .app_backgroundLight
        self.view.addSubview(gameSurfaceView)
        self.view.addSubview(sideBarContainer)
        self.view.addSubview(leftBatMovePressZone)
        self.view.addSubview(rightBatMovePressZone)
        
        self.setConstraints()
    }
    
    private func setConstraints() {
        
        if sideBarOrientation == .bottom {
            sideBarContainer.autoPinEdge(toSuperviewEdge: .left)
            sideBarContainer.autoPinEdge(toSuperviewEdge: .right)
            sideBarContainer.autoPinEdge(toSuperviewEdge: .bottom)
            sideBarContainer.autoSetDimension(.height, toSize: 60)
            gameSurfaceView.autoPinEdge(toSuperviewEdge: .top)
            gameSurfaceView.autoPinEdge(toSuperviewEdge: .left)
            gameSurfaceView.autoPinEdge(toSuperviewEdge: .right)
            gameSurfaceView.autoPinEdge(.bottom, to: .top, of: sideBarContainer, withOffset: 0)
        } else {
            sideBarContainer.autoPinEdge(toSuperviewEdge: .top)
            sideBarContainer.autoPinEdge(toSuperviewEdge: .bottom)
            sideBarContainer.autoSetDimension(.width, toSize: 160)
            sideBarContainer.autoPinEdge(toSuperviewEdge: sideBarOrientation == .left ? .left : .right)
            if sideBarOrientation == .left {
                gameSurfaceView.autoPinEdge(.left, to: .right, of: sideBarContainer, withOffset: 0)
                gameSurfaceView.autoPinEdge(toSuperviewEdge: .right)
            } else if sideBarOrientation == .right {
                gameSurfaceView.autoPinEdge(toSuperviewEdge: .left)
                gameSurfaceView.autoPinEdge(.right, to: .left, of: sideBarContainer, withOffset: 0)
            }
        }
        
        // regardless of layout the botton left and right corners are for moving the bat.
        leftBatMovePressZone.autoPinEdge(toSuperviewEdge: .left)
        leftBatMovePressZone.autoPinEdge(toSuperviewEdge: .bottom)
        leftBatMovePressZone.autoSetDimension(.width, toSize: 150)
        leftBatMovePressZone.autoSetDimension(.height, toSize: 150)
        
        rightBatMovePressZone.autoPinEdge(toSuperviewEdge: .right)
        rightBatMovePressZone.autoPinEdge(toSuperviewEdge: .bottom)
        rightBatMovePressZone.autoSetDimension(.width, toSize: 150)
        rightBatMovePressZone.autoSetDimension(.height, toSize: 150)
    }
    
    // MARK: - Key Presses
    
    override var keyCommands: [UIKeyCommand]? {
        
        let up = UIKeyCommand(input: UIKeyCommand.inputUpArrow, modifierFlags: [], action: #selector(keyPress))
        
        let left = UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: [], action: #selector(keyPress))
        
        let right = UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: [], action: #selector(keyPress))
        
        let escape = UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: [], action: #selector(keyPress))
        
        let down = UIKeyCommand(input: UIKeyCommand.inputDownArrow, modifierFlags: [], action: #selector(keyPress))
        
        return [left, right, up, escape, down]
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
            case UIKeyCommand.inputEscape:
                presenter.didSelectToServe(vector: CGVector(dx: 0, dy: 0))
                return
            case UIKeyCommand.inputDownArrow:
                if let scene = scene {
                    scene.isPaused = !scene.isPaused
                }
                return
            default: return
            }
        }
    }
}

//MARK: - AngleSwipeGestureRecognizerDelegate

extension GameView: AngleSwipeGestureRecognizerDelegate {
    func angleSwipeGesture(_ gesture: AngleSwipeGestureRecognizer, shouldAngleTriggerAction angle: CGFloat) -> Bool {
        return angle > 300 || angle < 60
    }
    
    func angleSwipeGestureDistance(_ gesture: AngleSwipeGestureRecognizer) -> CGFloat {
        return 40
    }
}

// MARK: - UIGestureRecognizerDelegate

extension GameView: UIGestureRecognizerDelegate {
        
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


//MARK: - GameView API
extension GameView: GameViewApi {
    
    func prepareForQuit() {
        gameSurfaceView.presentScene(nil)
    }
    
    func receiveBallFromOpponent(opponentXLocationAsAProportionOfWidth widthProportion: CGFloat, opponentVector: CGVector) {
        
        if let scene = scene {
            
            // translated the opponent's widthProportion and vector to be received into the scene
            let xLocation = scene.frame.width * (1 - widthProportion)
            let vector = opponentVector * -1
            
            scene.moveBallIntoScene(xLocation: xLocation, vector: vector)
        }
    }
    
    func setSideBarOrientation(orientation: SideBarOrientation) {
        sideBarOrientation = orientation
    }
    
    func moveBat(direction: BatMovement) {
        scene?.bat.move(direction)
    }
        
    func prepareBallForServe() {
        scene?.prepareBallForServe()
    }
    
    func serveBall(vector: CGVector) {
        scene?.serve(vector: vector)
    }
}

//MARK: - GameSceneDelegate
extension GameView: GameSceneDelegate {
    
    func gameScene(_ gameScene: SKScene, didServiceBallInDirection vector: CGVector) {
        presenter.didSelectToServe(vector: vector)
    }
    
    func gameScene(_ gameScene: SKScene, ballHitBatAt location: CGFloat) {
        presenter.ballHitBat(location: location)
    }
    
    func gameScene(_ gameScene: SKScene, ballHitGroundAt location: CGFloat) {
        presenter.ballHitGround(location: location)
    }
    
    func gameScene(_ gameScene: SKScene, ballLeftScreenAtLocation location: CGFloat, vector: CGVector) {
        if let scene = gameScene as? GameScene {
            scene.ball.removeFromParent()
            
            // work out what proportion of the total width the location is
            let widthProportion = location / scene.frame.width
            
            presenter.ballHasLeftScreen(xLocationAsAProportionOfWidth: widthProportion, vector: vector)
        }
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
