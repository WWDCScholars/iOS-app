//
//  IntroViewController.swift
//  WWDCScholars
//
//  Created by Sam Eckert on 08.05.17.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var pageControl: UIPageControl!
    @IBOutlet fileprivate weak var contentView: UIView!
    @IBOutlet fileprivate weak var backgroundImageView: UIImageView!
    @IBOutlet fileprivate weak var getStartedLabel: UILabel!
    @IBOutlet fileprivate weak var leftArrowImageView: UIImageView!
    @IBOutlet fileprivate weak var rightArrowImageView: UIImageView!
    @IBOutlet fileprivate weak var leftArrowButton: UIButton!
    @IBOutlet fileprivate weak var rightArrowButton: UIButton!
    
    fileprivate let numberOfScreens: CGFloat = 6
    
    fileprivate var first = "The misfits. The rebels. The troublemakers. The round pegs in the square holes. The ones who see things differently. We're not fond of rules. And we have no respect for the status quo."
    fileprivate var second = "You can quote us, disagree with us, glorify or vilify us. About the only thing you can't do is ignore us. Because we change things. We push the human race forward."
    fileprivate var third = "And while some may see us as the crazy ones, we see genius. Because the people who are crazy enough to think they can change the world, are the ones who do."
    fileprivate var stopAnimation = false
    fileprivate var objects: [TutorialObject] = []
 //   fileprivate var firstQuoteLabel: TOMSMorphingLabel!
    fileprivate var lastContentOffset = CGPoint.zero
    fileprivate var textState = 0
    fileprivate var didDoMyThing = false
    fileprivate var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }
    
    @IBOutlet fileprivate weak var contentViewWidthConstraint: NSLayoutConstraint! {
        didSet {
            self.contentViewWidthConstraint.constant = self.screenSize.width * self.numberOfScreens
        }
    }
    
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            self.contentViewHeightConstraint.constant = self.screenSize.height
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.accessibilityIdentifier = "introScroll"
        self.leftArrowButton.alpha = 0.0
        
        self.leftArrowButton.imageEdgeInsets = UIEdgeInsets(top: 18.0, left: 0.0, bottom: 18.0, right: 0.0)
        self.leftArrowButton.imageView?.contentMode = .scaleAspectFill
        
        self.rightArrowButton.imageEdgeInsets = UIEdgeInsets(top: 18.0, left: 0.0, bottom: 18.0, right: 0.0)
        self.rightArrowButton.imageView?.contentMode = .scaleAspectFill
        
        self.addObjects()
        self.pageControl.numberOfPages = Int(self.numberOfScreens - 1)
    }
    
    // MARK: - Private functions
    
    fileprivate func addBlurArea(_ area: CGRect, style: UIBlurEffectStyle) {
        let effect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: effect)
        
        let container = UIView(frame: area)
        blurView.frame = CGRect(x: 0, y: 0, width: area.width, height: area.height)
        container.addSubview(blurView)
        container.alpha = 0.5
        self.view.insertSubview(container, aboveSubview: self.backgroundImageView)
    }
    
    fileprivate func addObjects() {
        self.getStartedLabel.font = UIFont.systemFont(ofSize: 14.0)
        let attributedString = NSMutableAttributedString(string: self.getStartedLabel.text!)
        attributedString.addAttribute(NSKernAttributeName, value: 1.13, range: NSMakeRange(0, attributedString.string.length))
        self.getStartedLabel.attributedText = attributedString
        
        self.addQuote()
        self.addParagraph(self.first, atIndex: 0)
        self.addParagraph(self.second, atIndex: 1)
        self.addParagraph(self.third, atIndex: 2)
        self.addSubQuote()
        
        _ = self.objects.map() { $0.self.changeObjectToPosition(self.scrollView.contentOffset) }
        
        let shadowView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        shadowView.backgroundColor = UIColor(white: 0, alpha: 0.15)
        shadowView.center = self.view.center
        
        self.view.insertSubview(shadowView, aboveSubview: self.backgroundImageView)
        
        self.addBlurArea(self.view.frame, style: UIBlurEffectStyle.light)
        self.addBlurArea(CGRect(x: 0, y: self.view!.frame.size.height - 58.0, width: self.view!.frame.size.width, height: 58.0), style: .light)
    }
    
    fileprivate func addSubQuote() {
        let subQuoteLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.screenSize.width - 32, height: 30))
        subQuoteLabel.center = CGPoint(x: self.screenSize.width / 2, y: self.screenSize.height / 1.8)
        subQuoteLabel.text = "- Steve Jobs"
        subQuoteLabel.font = UIFont.systemFont(ofSize: 18)
        subQuoteLabel.textColor = UIColor.white
        subQuoteLabel.textAlignment = .right
        self.contentView.addSubview(subQuoteLabel)
    }
    
    fileprivate func addQuote() {
        let font = UIFont.systemFont(ofSize: 24, weight: UIFontWeightMedium)
        let firstPartAttributes = AZTextFrameAttributes(string: "Here's ", font: font)
        let secondPartAttributes = AZTextFrameAttributes(string: "   the Crazy Ones", font: font)
        let defaultPartAttributes = AZTextFrameAttributes(string: self.first + "\n\n", width: self.screenSize.width - 16, font: UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium))
        
        let firstWidth = AZTextFrame(attributes: firstPartAttributes).width
        let secondWidth = AZTextFrame(attributes: secondPartAttributes).width + 11
        let defaultPartHeight = AZTextFrame(attributes: defaultPartAttributes).height
        let sum = firstWidth + secondWidth
        
        let fullSpace = sum / self.screenSize.width
        let firstSpace: CGFloat = fullSpace / 2 - (firstWidth / self.screenSize.width) / 2
        let secondSpace: CGFloat = -fullSpace / 2 + (firstWidth / self.screenSize.width) + (secondWidth / self.screenSize.width) / 2
        
        let coefficent = 0.5 - (defaultPartHeight / self.screenSize.height) / 2 + 0.027
        
    //    self.firstQuoteLabel = TOMSMorphingLabel(frame: CGRect(x: 0, y: 0, width: firstWidth + 22, height: 30))
//        self.firstQuoteLabel.font = font
//        self.firstQuoteLabel.textColor = UIColor.white
//        self.firstQuoteLabel.center =  CGPoint(x: self.screenSize.width / 2 - self.screenSize.width * firstSpace, y: 0)
//        self.firstQuoteLabel.text = "Here's to "
//        self.firstQuoteLabel.textAlignment = .right
//        self.contentView.addSubview(self.firstQuoteLabel)
//        
//        let firstQuoteObject = TutorialObject(object: self.firstQuoteLabel)
//        firstQuoteObject.setPoints([CGPoint(x: 0.5 - firstSpace, y: 0.5), CGPoint(x: 1.5 - firstSpace, y: 0.5), CGPoint(x: 2.5 - firstSpace, y: coefficent), CGPoint(x: 2.5 - firstSpace, y: coefficent)])
//        self.objects.append(firstQuoteObject)
        
        let secondQuoteLabel = UILabel(frame: CGRect(x: 0, y: 0, width: secondWidth, height: 30))
        secondQuoteLabel.center =  CGPoint(x: self.screenSize.width / 2 + self.screenSize.width * secondSpace, y: 0)
        secondQuoteLabel.text = "   the Crazy Ones"
        secondQuoteLabel.font = font
        secondQuoteLabel.textColor = UIColor.white
        secondQuoteLabel.textAlignment = .left
        self.contentView.addSubview(secondQuoteLabel)
        
        let secondQuoteObject = TutorialObject(object: secondQuoteLabel)
        secondQuoteObject.setPoints([CGPoint(x: 0.5 + secondSpace, y: 0.5), CGPoint(x: 1.5 + secondSpace, y: 0.5), CGPoint(x: 2.5 + secondSpace, y: coefficent), CGPoint(x: 2.5 + secondSpace, y: coefficent)])
        self.objects.append(secondQuoteObject)
    }
    
    fileprivate func addParagraph(_ value: String, atIndex index: Int) {
        let paragraphLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.screenSize.width - 40, height: self.screenSize.height))
        paragraphLabel.center =  CGPoint(x: self.screenSize.width * 0.5, y: 0)
        paragraphLabel.text = value
        paragraphLabel.numberOfLines = 0
        paragraphLabel.textColor = UIColor.white
        paragraphLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)
        paragraphLabel.textAlignment = .center
        let attributedString = NSMutableAttributedString(string: value)
        attributedString.addAttribute(NSKernAttributeName, value: 0.95, range: NSMakeRange(0, attributedString.string.length))
        paragraphLabel.attributedText = attributedString
        
        self.contentView.addSubview(paragraphLabel)
        
        let paragraphLabelObject = TutorialObject(object: paragraphLabel)
        
        var points = [CGPoint]()
        if index == 0 {
            points = [CGPoint(x: 1.5, y: 0.535), CGPoint(x: 2.5, y: 0.535), CGPoint(x: 2.5, y: 0.535)]
        } else if index == 1 {
            points = [CGPoint(x: 3.5, y: 0.5), CGPoint(x: 3.5, y: 0.5), CGPoint(x: 3.5, y: 0.5)]
        } else if index == 2 {
            points = [CGPoint(x: 4.5, y: 0.5), CGPoint(x: 5.5, y: 0.5), CGPoint(x: 5.5, y: 0.5)]
        }
        
        if index == 0 {
            points.remove(at: 0)
        }
        paragraphLabelObject.setPoints(points)
        self.objects.append(paragraphLabelObject)
    }
    
    @IBAction func leftArrowTapped(_ sender: AnyObject) {
        var pageNumber = Int(round((self.scrollView.contentOffset.x / self.screenSize.width)))
        pageNumber = min(max(0, pageNumber), Int(self.numberOfScreens - 1))-1
        
        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width*CGFloat(pageNumber), y: 0), animated: true)
    }
    
    @IBAction func rightArrowTapped(_ sender: AnyObject) {
        var pageNumber = Int(round((self.scrollView.contentOffset.x / self.screenSize.width)))
        pageNumber = min(max(0, pageNumber), Int(self.numberOfScreens - 1))+1
        
        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width*CGFloat(pageNumber), y: 0), animated: true)
    }
}

extension IntroViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView.contentOffset.x >= (self.screenSize.width * (self.numberOfScreens - 2)) + self.screenSize.width / 2 {
            
            self.modalTransitionStyle = .crossDissolve
            
            if !self.didDoMyThing {
                self.didDoMyThing = true
                
                if UserDefaults.hasOpenedApp {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.performSegue(withIdentifier: String(describing: ScholarsTabBarViewController.self), sender: self)
                    UserDefaults.hasOpenedApp = true
                }
            }
        }
        
        self.updatePageControl()
        
        self.backgroundImageView.frame.origin.x = -self.scrollView.contentOffset.x / self.numberOfScreens
        
        var firstLabel: UILabel?
        _ = self.objects.map() {
            tutorialObject -> () in
            if tutorialObject.tag == 1 {
                firstLabel = tutorialObject.object as? UILabel
            }
            tutorialObject.changeObjectToPosition(scrollView.contentOffset)
        }
        
        if let label = firstLabel {
            if self.scrollView.contentOffset.x > self.screenSize.width * 1.0 && self.scrollView.contentOffset.x < self.screenSize.width * 2.0 {
                label.alpha = (scrollView.contentOffset.x - self.screenSize.width) / self.screenSize.width
            }
        }
        
        if scrollView.contentOffset.x > self.lastContentOffset.x && scrollView.contentOffset.x > self.screenSize.width * 0.5 {
            if self.firstQuoteLabel.text != "We are " {
                self.firstQuoteLabel.setText("We are ", withCompletionBlock: nil)
                self.stopAnimation = true
            }
        } else if scrollView.contentOffset.x < self.lastContentOffset.x && scrollView.contentOffset.x < self.screenSize.width * 0.5 {
            if self.firstQuoteLabel.text != "Here's to " {
                self.firstQuoteLabel.setText("Here's to ", withCompletionBlock: nil)
            }
        }
        
        self.lastContentOffset = scrollView.contentOffset
    }
    
    func updatePageControl() {
        var pageNumber = Int(round((self.scrollView.contentOffset.x / self.screenSize.width)))
        pageNumber = min(max(0, pageNumber), Int(self.numberOfScreens - 1))
        
        self.pageControl.currentPage = pageNumber
        
        if pageNumber >= 4 {
            UIView.animate(withDuration: 0.2, animations: {
                self.pageControl.alpha = 0.0
                self.getStartedLabel.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.pageControl.alpha = 1.0
                self.getStartedLabel.alpha = 0.0
                self.leftArrowButton.alpha = pageNumber == 0 ? 0.0 : 1.0
            }, completion: { (value: Bool) in
                self.leftArrowButton.isHidden = !value
            })
        }
    }

}
