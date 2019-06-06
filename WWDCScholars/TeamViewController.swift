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
import Agrume

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
    
    // MARK: Michie
    @IBOutlet private weak var michieImageContentView: UIView?
    @IBOutlet private weak var michieImageView: UIImageView?
    @IBOutlet private weak var michieNameLabel: UILabel?
    @IBOutlet private weak var michieDescriptionLabel: UILabel?
    
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
        
        let barBtn = UIBarButtonItem.init(title: "Intro", style: .plain, target: self, action: #selector(self.showIntro))
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

        
        self.michieImageContentView?.roundCorners()
        self.michieImageContentView?.applyRelativeCircularBorder()
        self.michieImageView?.roundCorners()
        
        
        self.matthijsImageContentView?.roundCorners()
        self.matthijsImageContentView?.applyRelativeCircularBorder()
        self.matthijsImageView?.roundCorners()

    }
    
    private func configureUI() {
        self.title = "Team"
    }
    
    // MARK: - Private Functions
    @IBAction func tappedTeamImage(_ sender: Any) {
        let agrume = Agrume(image: (wwdcscholarsTeamBannerImageView?.image!)!)
        agrume.show(from: self)
    }
    
    private func populateContent() {
        self.andrewImageView?.image = UIImage(named: "profile")
        self.andrewNameLabel?.text = "Andrew Walker"
        self.andrewDescriptionLabel?.text = "“Andrew has been working on iOS applications for 4 1/2 years. He recently interned at Apple after attending WWDC as a scholarship winner for three consecutive years.”"
        
        self.samImageView?.image = UIImage(named: "samProfile")
        self.samNameLabel?.text = "Sam Eckert"
        self.samDescriptionLabel?.text = "“Sam started developing iOS apps when he turned 14. He received two WWDC scholarships and is now connecting companies with the young generation at agenZy.”"
        
        self.moritzImageView?.image = UIImage(named: "moritzProfile")
        self.moritzNameLabel?.text = "Moritz Sternemann"
        self.moritzDescriptionLabel?.text = "“Moritz is the most recent addition to our team and mostly worked on the website and the signup form. He attended WWDC as a scholarship winner for two consecutive years.”"
        
        self.michieImageView?.image = UIImage(named: "michieProfile")
        self.michieNameLabel?.text = "Michie Ang"
        self.michieDescriptionLabel?.text = "“Michie was a nurse when she first got into iOS development. She won a scholarship three times, builds tech communities and travels around to inspire others to learn programming.”"
        

        self.matthijsImageView?.image = UIImage(named: "matthijsProfile")
        self.matthijsNameLabel?.text = "Matthijs Logemann"
        self.matthijsDescriptionLabel?.text = "“Matthijs has been developping for iOS for around 8 years, has received two WWDC scholarships and now studies Computer Science at the Eindhoven University of Technology.”"
        
    }
}

extension TeamViewController: UIScrollViewDelegate, DeckTransitionScrollAssist, HeaderParallaxAssist {
    
    // MARK: - Internal Functions
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateDeckTransition(for: scrollView)
        self.updateHeaderParallax(for: scrollView, on: self.wwdcscholarsTeamBannerImageView, baseHeight: self.wwdcscholarsTeamBannerImageViewHeight)
    }
}
