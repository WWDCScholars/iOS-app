//
//  TeamViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import DeckTransition

internal final class TeamViewController: UIViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var scrollView: UIScrollView?
    @IBOutlet private weak var wwdcscholarsLogoImageView: UIImageView?
    @IBOutlet private weak var wwdcscholarsLogoContainerView: UIView?

    // MARK: Andrew
    @IBOutlet private weak var andrewImageContentView: UIView!
    @IBOutlet private weak var andrewImageView: UIImageView?
    @IBOutlet private weak var andrewNameLabel: UILabel?
    @IBOutlet private weak var andrewDescriptionLabel: UILabel?
    
    // MARK: Sam
    @IBOutlet private weak var samImageContentView: UIView?
    @IBOutlet private weak var samImageView: UIImageView?
    @IBOutlet private weak var samNameLabel: UILabel?
    @IBOutlet private weak var samDescriptionLabel: UILabel?
    
    // MARK: Moritz
    @IBOutlet private weak var moritzImageContentView: UIView?
    @IBOutlet private weak var moritzImageView: UIImageView?
    @IBOutlet private weak var moritzNameLabel: UILabel?
    @IBOutlet private weak var moritzDescriptionLabel: UILabel?
    
    // MARK: Matthijs
    @IBOutlet private weak var matthijsImageContentView: UIView?
    @IBOutlet private weak var matthijsImageView: UIImageView?
    @IBOutlet private weak var matthijsNameLabel: UILabel?
    @IBOutlet private weak var matthijsDescriptionLabel: UILabel?

    
    // MARK: - File Private Properties
      @IBOutlet fileprivate weak var wwdcscholarsTeamBannerImageView: UIImageView!
    
    fileprivate var wwdcscholarsTeamBannerImageViewHeight: CGFloat = 0.0
    
    // MARK: - Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView?.contentSize.width = self.view.frame.size.width
        self.scrollView?.showsHorizontalScrollIndicator = false
        
        self.styleUI()
        self.configureUI()
        self.populateContent()
        
        let barBtn = UIBarButtonItem.init(barButtonSystemItem: .compose, target: self, action: #selector(self.showIntro))
        self.navigationItem.rightBarButtonItem = barBtn
    }
    
    @objc func showIntro() {
        let storyboard = UIStoryboard.init(name: "Intro", bundle: nil)
        let intro = storyboard.instantiateInitialViewController()!
        self.present(intro, animated: true, completion: nil)
    }
    
    internal override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.wwdcscholarsTeamBannerImageViewHeight = self.wwdcscholarsTeamBannerImageView?.frame.height ?? 0.0

    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.view.applyBackgroundStyle()
        
//        self.nameLabel?.applyDetailHeaderTitleStyle()
//        self.descriptionLabel?.applyDetailContentStyle()
        
        self.wwdcscholarsLogoContainerView?.roundCorners()
        self.wwdcscholarsLogoContainerView?.applyRelativeCircularBorder()
        self.wwdcscholarsLogoImageView?.roundCorners()
        
        self.andrewImageContentView?.roundCorners()
        self.andrewImageContentView?.applyRelativeCircularBorder()
        self.andrewImageView?.roundCorners()
        
        self.samImageContentView?.roundCorners()
        self.samImageContentView?.applyRelativeCircularBorder()
        self.samImageView?.roundCorners()

        
        self.moritzImageContentView?.roundCorners()
        self.moritzImageContentView?.applyRelativeCircularBorder()
        self.moritzImageView?.roundCorners()

        
        self.matthijsImageContentView?.roundCorners()
        self.matthijsImageContentView?.applyRelativeCircularBorder()
        self.matthijsImageView?.roundCorners()

    }
    
    private func configureUI() {
        self.title = "Team"
    }
    
    // MARK: - Private Functions
    
    private func populateContent() {
        self.andrewImageView?.image = UIImage(named: "profile")
        self.andrewNameLabel?.text = "Andrew Walker"
        self.andrewDescriptionLabel?.text = "“This year I worked on the design of our updated website and rewrote our app codebase from scratch. I also helped out with merchandise and social media.”"
        
        self.samImageView?.image = UIImage(named: "profile")
        self.samNameLabel?.text = "Sam Eckert"
        self.samDescriptionLabel?.text = "“This year I worked on design and creation within the iOS App. I'm also responsible for donations, marketing, public relations and project management.”"
        
        self.moritzImageView?.image = UIImage(named: "profile")
        self.moritzNameLabel?.text = "Moritz Sternemann"
        self.moritzDescriptionLabel?.text = "“This year I worked on the all-new WWDCScholars.com website and recoded it. I also created the form through which all scholars submitted their details.”"
        
        self.matthijsImageView?.image = UIImage(named: "profile")
        self.matthijsNameLabel?.text = "Matthijs Logemann"
        self.matthijsDescriptionLabel?.text = "“This year I worked on the migration of our old backend to our new CloudKit-powered one. I also implemented everything CloudKit-related into the app.”"
    }
}

extension TeamViewController: UIScrollViewDelegate, DeckTransitionScrollAssist, HeaderParallaxAssist {
    
    // MARK: - Internal Functions
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateDeckTransition(for: scrollView)
        self.updateHeaderParallax(for: scrollView, on: self.wwdcscholarsTeamBannerImageView, baseHeight: self.wwdcscholarsTeamBannerImageViewHeight)
    }
}
