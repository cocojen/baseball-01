//
//  MatchCell.swift
//  BaseballGameApp
//
//  Created by Cory Kim on 2020/05/04.
//  Copyright © 2020 corykim0829. All rights reserved.
//

import UIKit

class MatchCell: UICollectionViewCell {
    
    static let reuseIdentifier = "MatchCell"
    static let heightRatio: CGFloat = 0.38
    
    private let awayLogoImageView = LogoImageView()
    private let homeLogoImageView = LogoImageView()
    private let awayLabel = PlainLabel(text: "AWAY", color: UIColor(named: "away.home.label"), fontSize: 13, weight: .semibold, alignment: .center)
    private let homeLabel = PlainLabel(text: "HOME", color: UIColor(named: "away.home.label"), fontSize: 13, weight: .semibold, alignment: .center)
    private let versusLabel = PlainLabel(text: "VS", color: .white, fontSize: 23, weight: .heavy, alignment: .center)
    private let awayNameLabel = PlainLabel(text: "AWAY", color: .white, fontSize: 15, weight: .bold, alignment: .center)
    private let homeNameLabel = PlainLabel(text: "HOME", color: .white, fontSize: 15, weight: .bold, alignment: .center)
    
    private let containerView = UIView()
    private let containerEffectView = UIView()
    private let cornerRadius: CGFloat = 16
    private(set) var identifier: Int!
    private(set) var isPlaying: Bool = false {
        didSet {
            if isPlaying {
                showBlockView()
            } else {
                hideBlockView()
            }
        }
    }
    
    private var blockView: UIView!
    private var unavailableMessageLabel: UIView!
    
    private var away: Team! {
        didSet {
            awayNameLabel.text = away.name
        }
    }
    private var home: Team! {
        didSet {
            homeNameLabel.text = home.name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        configureUI()
        configureLayout()
    }
    
    func updateIdentifier(_ identifier: Int) {
        self.identifier = identifier
    }
    
    func updateLogoImage(_ image: UIImage?, isAway: Bool) {
        if isAway {
            self.awayLogoImageView.image = image
        } else {
            self.homeLogoImageView.image = image
        }
    }
    
    func updateTeam(away: Team, home: Team) {
        self.away = away
        self.home = home
        isPlaying = away.isOccupied && home.isOccupied
    }
    
    private func showBlockView() {
        guard blockView != nil, unavailableMessageLabel != nil else { return }
        blockView.isHidden = false
        unavailableMessageLabel.isHidden = false
    }
    
    private func hideBlockView() {
        guard blockView != nil, unavailableMessageLabel != nil else { return }
        blockView.isHidden = true
        unavailableMessageLabel.isHidden = true
    }
    
    func pass(handler: (_ identifier: Int, _ awayTeam: Team, _ awayTeamLogoImage: UIImage?, _ homeTeam: Team, _ homeTeamLogoImage: UIImage?) -> Void) {
        handler(identifier, away, awayLogoImageView.image, home, homeLogoImageView.image)
    }
    
    private func configureUI() {
        addSubview(containerView)
        containerView.addSubview(containerEffectView)
        containerView.addSubview(versusLabel)
        containerView.addSubview(awayLabel)
        containerView.addSubview(homeLabel)
        containerView.addSubview(awayLogoImageView)
        containerView.addSubview(homeLogoImageView)
        containerView.addSubview(awayNameLabel)
        containerView.addSubview(homeNameLabel)
        
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 2
        containerView.backgroundColor = UIColor(named: "board.view")
        containerView.alpha = 0.9
        containerView.clipsToBounds = true
        
        containerEffectView.backgroundColor = .black
        containerEffectView.alpha = 0.25
        
        addBlockView()
    }
    
    private func addBlockView() {
        blockView = UIView()
        containerView.addSubview(blockView)
        unavailableMessageLabel = PlainLabel(text: "경기 중인 매치입니다.", color: .white, fontSize: 16, weight: .semibold, alignment: .center)
        unavailableMessageLabel.backgroundColor = .black
        containerView.addSubview(unavailableMessageLabel)
        unavailableMessageLabel.centerInSuperView()
        blockView.backgroundColor = .black
        blockView.alpha = 0.8
        blockView.fillSuperView()
    }
    
    private func configureLayout() {
        containerEffectView.constraints(topAnchor: containerView.centerYAnchor, leadingAnchor: containerView.leadingAnchor, bottomAnchor: containerView.bottomAnchor, trailingAnchor: containerView.trailingAnchor)
        containerView.constraints(topAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: trailingAnchor)
        versusLabel.centerInSuperView()
        
        // Home-Away Labels
        let verticalSpacingFromTeamLabelToContainer: CGFloat = 12.0
        awayLabel.constraints(topAnchor: containerView.topAnchor, leadingAnchor: containerView.leadingAnchor, bottomAnchor: nil, trailingAnchor: containerView.centerXAnchor, padding: .init(top: verticalSpacingFromTeamLabelToContainer, left: 0, bottom: 0, right: 0))
        awayLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 900), for: .vertical)
        homeLabel.constraints(topAnchor: containerView.topAnchor, leadingAnchor: containerView.centerXAnchor, bottomAnchor: nil, trailingAnchor: containerView.trailingAnchor, padding: .init(top: verticalSpacingFromTeamLabelToContainer, left: 0, bottom: 0, right: 0))
        homeLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 900), for: .vertical)
        
        // LogoImageViews
        let verticalSpacingFromLogoImageToTeamLabel: CGFloat = 0.0
        awayLogoImageView.centerXAnchor.constraint(equalTo: awayLabel.centerXAnchor).isActive = true
        awayLogoImageView.constraints(topAnchor: awayLabel.bottomAnchor, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: nil, padding: .init(top: verticalSpacingFromLogoImageToTeamLabel, left: 0, bottom: 0, right: 0))
        homeLogoImageView.centerXAnchor.constraint(equalTo: homeLabel.centerXAnchor).isActive = true
        homeLogoImageView.constraints(topAnchor: homeLabel.bottomAnchor, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: nil, padding: .init(top: verticalSpacingFromLogoImageToTeamLabel, left: 0, bottom: 0, right: 0))
        
        // TeamNameLabels
        let verticalSpacingFromNameLabelToLogoImage: CGFloat = 0.0
        let verticalSpacingFromContainerToNameLabel: CGFloat = 12.0
        awayNameLabel.constraints(topAnchor: awayLogoImageView.bottomAnchor, leadingAnchor: containerView.leadingAnchor, bottomAnchor: containerView.bottomAnchor, trailingAnchor: containerView.centerXAnchor, padding: .init(top: verticalSpacingFromNameLabelToLogoImage, left: 0, bottom: -verticalSpacingFromContainerToNameLabel, right: 0))
        awayNameLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 900), for: .vertical)
        homeNameLabel.constraints(topAnchor: homeLogoImageView.bottomAnchor, leadingAnchor: containerView.centerXAnchor, bottomAnchor: containerView.bottomAnchor, trailingAnchor: containerView.trailingAnchor, padding: .init(top: verticalSpacingFromNameLabelToLogoImage, left: 0, bottom: -verticalSpacingFromContainerToNameLabel, right: 0))
        homeNameLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 900), for: .vertical)
        
        layoutIfNeeded()
        awayLogoImageView.layer.cornerRadius = awayLogoImageView.frame.height / 2
        homeLogoImageView.layer.cornerRadius = homeLogoImageView.frame.height / 2
    }
}
