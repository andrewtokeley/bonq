//
//  ProfileView.swift
//  bonq
//
//  Created by Andrew Tokeley on 20/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import UIKit

class ProfileView: UIView {
    
    // MARK: - Intialisers
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupView()
    }
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        self.addSubview(circleBackground)
        circleBackground.addSubview(profileImage)
        self.addSubview(profileName)
        
        setConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleBackground.layer.cornerRadius = self.frame.width / 2
    }
    
    private func setConstraints() {
        
        // for now assume the view's width is less than their height
        circleBackground.autoPinEdge(toSuperviewEdge: .top, withInset: Layout.spacerSmall)
        circleBackground.autoAlignAxis(toSuperviewAxis: .vertical)
        circleBackground.autoPinEdge(toSuperviewEdge: .left)
        circleBackground.autoPinEdge(toSuperviewEdge: .right)
        circleBackground.autoMatch(.height, to: .width, of: circleBackground, withOffset: 0)
        
        profileImage.autoCenterInSuperview()
        profileImage.autoMatch(.width, to: .width, of: circleBackground, withMultiplier: 0.60)
        
        profileName.autoAlignAxis(toSuperviewAxis: .vertical)
        profileName.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
    // MARK: - Subviews
    
    lazy var circleBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .app_textColourOnDark
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.app_buttonBackground.cgColor
        view.layer.borderWidth = 5
        return view
    }()
    
    lazy var profileImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "Person"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var profileName: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .app_normal
        view.textColor = .app_textColourOnDark
        return view
    }()

    // MARK: - UIViewController
      
    /**
     Custom views should override this to return true if they cannot layout correctly using autoresizing. From apple docs, https://developer.apple.com/documentation/uikit/uiview/1622549-requiresconstraintbasedlayout
     */
    override class var requiresConstraintBasedLayout: Bool {
      return true
    }
    
    // MARK: - Functions
    
    func setSelectedState(isSelected: Bool) {
        //highlightView.backgroundColor = isSelected ? UIColor.app_buttonBackground : .white
    }
    
    
}
