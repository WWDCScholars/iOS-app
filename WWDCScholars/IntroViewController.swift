//
//  IntroViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 05.05.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var getStartedLabel: UILabel!
    @IBOutlet private weak var leftArrowImageView: UIImageView!
    @IBOutlet private weak var rightArrowImageView: UIImageView!
    
    private let numberOfScreens: CGFloat = 6
    
    private var first = "The misfits. The rebels. The troublemakers. The round pegs in the square holes. The ones who see things differently. We're not fond of rules. And we have no respect for the status quo."
    private var second = "You can quote us, disagree with us, glorify or vilify us. About the only thing you can't do is ignore us. Because we change things. We push the human race forward."
    private var third = "And while some may see us as the crazy ones, we see genius. Because the people who are crazy enough to think they can change the world, are the ones who do."
    private var stopAnimation = false
    private var objects: [TutorialObject] = []
    private var firstQuoteLabel: TOMSMorphingLabel!
    private var lastContentOffset = CGPointZero
    private var textState = 0
    private var movingTimer: NSTimer?
    
    private var screenSize: CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    @IBOutlet private weak var contentViewWidthConstraint: NSLayoutConstraint! {
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
        self.leftArrowImageView.alpha = 0.0

        self.addObjects()
        self.pageControl.numberOfPages = Int(self.numberOfScreens - 1)
    }
    
    // MARK: - Private functions
    
    private func addObjects() {
        self.getStartedLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        
        self.addQuote()
        self.addParagraph(self.first, atIndex: 0)
        self.addParagraph(self.second, atIndex: 1)
        self.addParagraph(self.third, atIndex: 2)
        self.addSubQuote()
        
        self.objects.map() { $0.self.changeObjectToPosition(self.scrollView.contentOffset) }
    }
    
    private func addSubQuote() {
        let subQuoteLabel = UILabel(frame: CGRectMake(0, 0, self.screenSize.width - 32, 30))
        subQuoteLabel.center = CGPoint(x: self.screenSize.width / 2, y: self.screenSize.height / 1.8)
        subQuoteLabel.text = "- Steve Jobs"
        subQuoteLabel.font = UIFont(name: "HelveticaNeue", size: 18)
        subQuoteLabel.textColor = UIColor.whiteColor()
        subQuoteLabel.textAlignment = .Right
        
        self.contentView.addSubview(subQuoteLabel)
    }
    
    private func addQuote() {
        let font = UIFont(name: "HelveticaNeue-Medium", size: 24)!
        let firstPartAttributes = AZTextFrameAttributes(string: "Here's ", font: font)
        let secondPartAttributes = AZTextFrameAttributes(string: "   the Crazy Ones", font: font)
        let defaultPartAttributes = AZTextFrameAttributes(string: self.first + "\n\n", width: self.screenSize.width - 16, font: UIFont(name: "HelveticaNeue-Medium", size: 18)!)
        
        let firstWidth = AZTextFrame(attributes: firstPartAttributes).width
        let secondWidth = AZTextFrame(attributes: secondPartAttributes).width + 11
        let defaultPartHeight = AZTextFrame(attributes: defaultPartAttributes).height
        let sum = firstWidth + secondWidth
        
        let fullSpace = sum / self.screenSize.width
        let firstSpace: CGFloat = fullSpace / 2 - (firstWidth / self.screenSize.width) / 2
        let secondSpace: CGFloat = -fullSpace / 2 + (firstWidth / self.screenSize.width) + (secondWidth / self.screenSize.width) / 2
        
        let coefficent = 0.5 - (defaultPartHeight / self.screenSize.height) / 2
        
        self.firstQuoteLabel = TOMSMorphingLabel(frame: CGRectMake(0, 0, firstWidth + 22, 30))
        self.firstQuoteLabel.font = font
        self.firstQuoteLabel.textColor = UIColor.whiteColor()
        self.firstQuoteLabel.center =  CGPoint(x: self.screenSize.width / 2 - self.screenSize.width * firstSpace, y: 0)
        self.firstQuoteLabel.text = "Here's to "
        self.firstQuoteLabel.textAlignment = .Right
        self.contentView.addSubview(self.firstQuoteLabel)
        
        let firstQuoteObject = TutorialObject(object: self.firstQuoteLabel)
        firstQuoteObject.setPoints([CGPoint(x: 0.5 - firstSpace, y: 0.5), CGPoint(x: 1.5 - firstSpace, y: 0.5), CGPoint(x: 2.5 - firstSpace, y: coefficent), CGPoint(x: 3.5 - firstSpace, y: -0.1)])
        self.objects.append(firstQuoteObject)
        
        let secondQuoteLabel = UILabel(frame: CGRectMake(0, 0, secondWidth, 30))
        secondQuoteLabel.center =  CGPoint(x: self.screenSize.width / 2 + self.screenSize.width * secondSpace, y: 0)
        secondQuoteLabel.text = "   the Crazy Ones"
        secondQuoteLabel.font = font
        secondQuoteLabel.textColor = UIColor.whiteColor()
        secondQuoteLabel.textAlignment = .Left
        self.contentView.addSubview(secondQuoteLabel)
        
        let secondQuoteObject = TutorialObject(object: secondQuoteLabel)
        secondQuoteObject.setPoints([CGPoint(x: 0.5 + secondSpace, y: 0.5), CGPoint(x: 1.5 + secondSpace, y: 0.5), CGPoint(x: 2.5 + secondSpace, y: coefficent), CGPoint(x: 3.5 + secondSpace, y: -0.1)])
        self.objects.append(secondQuoteObject)
    }
    
    private func addParagraph(value: String, atIndex index: Int) {
        let paragraphLabel = UILabel(frame: CGRectMake(0, 0, self.screenSize.width - 16, self.screenSize.height))
        paragraphLabel.center =  CGPoint(x: self.screenSize.width * 0.5, y: 0)
        paragraphLabel.text = value
        paragraphLabel.numberOfLines = 0
        paragraphLabel.textColor = UIColor.whiteColor()
        paragraphLabel.font = UIFont(name: "HelveticaNeue", size: 18)
        paragraphLabel.textAlignment = .Center
        self.contentView.addSubview(paragraphLabel)
        
        let paragraphLabelObject = TutorialObject(object: paragraphLabel)
        
        var points = [CGPoint(x: 1.5 + CGFloat(index), y: 0.9), CGPoint(x: 2.5 + CGFloat(index), y: 0.5), CGPoint(x: 3.5 + CGFloat(index), y: 0.1)]
        if index == 0 {
            points.removeAtIndex(0)
        }
        paragraphLabelObject.setPoints(points)
        
        if index == 0 {
            paragraphLabelObject.addActionAtPosition(TutorialObjectAction.ChangeAlpha(value: 1.0), position: 0)
            paragraphLabelObject.addActionAtPosition(TutorialObjectAction.ChangeAlpha(value: 0.1), position: 1)
            paragraphLabelObject.tag = 1
        } else {
            paragraphLabelObject.addActionAtPosition(TutorialObjectAction.ChangeAlpha(value: 0.1), position: 0)
            paragraphLabelObject.addActionAtPosition(TutorialObjectAction.ChangeAlpha(value: 1.0), position: 1)
            paragraphLabelObject.addActionAtPosition(TutorialObjectAction.ChangeAlpha(value: index == 2 ? 0.0 : 0.1), position: 2)
        }
        
        self.objects.append(paragraphLabelObject)
    }
}

extension IntroViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if let timer = self.movingTimer {
            self.stopAnimation = true
            timer.invalidate()
            self.movingTimer = nil
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.scrollView.contentOffset.x >= (self.screenSize.width * (self.numberOfScreens - 2)) + self.screenSize.width / 2 {
            
            self.modalTransitionStyle = .CrossDissolve
            if UserDefaults.hasOpenedApp {
                self.dismissViewControllerAnimated(true, completion: nil)
            }else {
                self.performSegueWithIdentifier(String(ScholarsTabBarViewController), sender: self)
                UserDefaults.hasOpenedApp = true
            }
        }
        
        self.updatePageControl()
        
        self.backgroundImageView.frame.origin.x = -self.scrollView.contentOffset.x / self.numberOfScreens
        
        var firstLabel: UILabel?
        self.objects.map() {
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
            UIView.animateWithDuration(0.5, animations: {
                self.pageControl.alpha = 0.0
                self.getStartedLabel.alpha = 1.0
            })
        } else {
            UIView.animateWithDuration(0.5, animations: {
                self.pageControl.alpha = 1.0
                self.getStartedLabel.alpha = 0.0
                self.leftArrowImageView.alpha = pageNumber == 0 ? 0.0 : 1.0
            })
        }
    }
}

