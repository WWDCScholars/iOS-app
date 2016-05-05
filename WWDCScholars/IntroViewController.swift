//
//  IntroViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 05.05.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var contentView: UIView!
    
    private let numberOfScreens: CGFloat = 6
    
    private var swipeLeftImageView: UIImageView!
    private var stopAnimation = false
    private var objects: [TutorialObject] = []
    private var quoteLabel: TOMSMorphingLabel!
    private var first = "The misfits. The rebels. The troublemakers. The round pegs in the square holes. The ones who see things differently. We're not fond of rules. And we have no respect for the status quo."
    private var second = "You can quote us, disagree with us, glorify or vilify us. About the only thing you can't do is ignore us. Because we change things. We push the human race forward."
    private var third = "And while some may see us as the crazy ones, we see genius. Because the people who are crazy enough to think they can change the world, are the ones who do."
    
    private var screenSize: CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint! {
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
        
        self.addObjects()
        
        self.pageControl.numberOfPages = Int(self.numberOfScreens)
        self.movingTimer = NSTimer(timeInterval: 6.0, target: self, selector: #selector(IntroViewController.timerStep), userInfo: nil, repeats: true)
        
        NSRunLoop.currentRunLoop().addTimer(self.movingTimer!, forMode: NSRunLoopCommonModes)
    }
    
    func addObjects() {
        self.addQuote()
        self.addParagraph(self.first, atIndex: 0)
        self.addParagraph(self.second, atIndex: 1)
        self.addParagraph(self.third, atIndex: 2)
        self.addLogoObject()
        self.addOthersElemts()
        
        self.objects.map() { $0.self.changeObjectToPosition(self.scrollView.contentOffset) }
    }
    
    func addLogoObject() {
        let imageView = UIImageView(image: UIImage(named: "wwdcScholarsIcon"))
        imageView.center = CGPoint(x: self.screenSize.width / 2, y: self.screenSize.height / 2)
        self.contentView.addSubview(imageView)
        
        let logoObject = TutorialObject(object: imageView)
        logoObject.setPoints([CGPoint(x: 4.5, y: 0.85), CGPoint(x: 5.5, y: 0.35)])
        
        let bigLogoSize = self.screenSize.width - 100
        let smallLogoSize = self.screenSize.width / 3
        logoObject.addActionAtPosition(TutorialObjectAction.Resize(size: CGSize(width: smallLogoSize, height: smallLogoSize)), position: 0)
        logoObject.addActionAtPosition(TutorialObjectAction.Resize(size: CGSize(width: bigLogoSize, height: bigLogoSize)), position: 1)
        
        self.objects.append(logoObject)
    }
    
    func addOthersElemts() {
        let imageView = UIImageView(image: UIImage(named: "wwdcTextImage"))
        imageView.center = CGPoint(x: self.screenSize.width * 5.5, y: self.screenSize.height / 1.4)
        self.contentView.addSubview(imageView)
        
        let anotheQuoteLabel = UILabel(frame: CGRectMake(0, 0, self.screenSize.width - 32, 30))
        anotheQuoteLabel.center = CGPoint(x: self.screenSize.width / 2, y: self.screenSize.height / 1.8)
        anotheQuoteLabel.text = "- Steve Jobs"
        anotheQuoteLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 18)
        anotheQuoteLabel.textAlignment = .Right
        self.contentView.addSubview(anotheQuoteLabel)
        
        let startButton = DesignableButton(frame: CGRectMake(0, 0, imageView.frame.width, imageView.frame.height))
        startButton.cornerRadius = 3
        startButton.center = CGPoint(x: self.screenSize.width * 5.5, y: self.screenSize.height / 1.2)
        startButton.backgroundColor = UIColorFromRGB(0x6C4FA0)
        startButton.setTitle("Welcome", forState: .Normal)
        startButton.addTarget(self, action: #selector(IntroViewController.buttonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        startButton.layer.cornerRadius = 3
        self.contentView.addSubview(startButton)
        
        self.swipeLeftImageView = UIImageView(frame: CGRectMake(self.screenSize.width - 60, self.screenSize.height - 120, 50, 100))
        self.swipeLeftImageView.image = UIImage(named: "swipeLeft")
        self.swipeLeftImageView.contentMode = .ScaleAspectFit
        self.swipeLeftImageView.alpha = 0.50
        UIView.animateWithDuration(2.0, delay: 2.0, options: .CurveEaseInOut, animations: {
            self.swipeLeftImageView.frame.origin.x = 10
            self.swipeLeftImageView.alpha = 0.0
            }, completion: { _ in
                if self.movingTimer != nil && !self.stopAnimation {
                    self.animateSwipeImage()
                }
        })
        self.view.addSubview(swipeLeftImageView)
    }
    
    func animateSwipeImage(){
        self.swipeLeftImageView.frame.origin.x = self.screenSize.width - 60
        self.swipeLeftImageView.alpha = 0.5
        
        UIView.animateWithDuration(2.0, delay: 2.0, options: .CurveEaseInOut, animations: {
            self.swipeLeftImageView.frame.origin.x = 10
            self.swipeLeftImageView.alpha = 0.0
            }, completion: { _ in
                if self.movingTimer != nil && !self.stopAnimation {
                    self.animateSwipeImage()
                }
        })
    }
    
    func buttonAction(sender:UIButton!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    func addQuote() {
        let font = UIFont(name: "HelveticaNeue-Thin", size: 24)!
        let firstPartAttributes = AZTextFrameAttributes(string: "Here's ", font: font)
        let secondPartAttributes = AZTextFrameAttributes(string: "   the Crazy Ones", font: font)
        let defaultPartAttributes = AZTextFrameAttributes(string: self.first + "\n\n", width: self.screenSize.width - 16, font: UIFont(name: "HelveticaNeue-Thin", size: 18)!)
        
        let firstWidth = AZTextFrame(attributes: firstPartAttributes).width
        let secondWidth = AZTextFrame(attributes: secondPartAttributes).width + 11
        let defaultPartHeight = AZTextFrame(attributes: defaultPartAttributes).height
        let sum = firstWidth + secondWidth
        
        let fullSpace = sum / self.screenSize.width
        let firstSpace: CGFloat = fullSpace / 2 - (firstWidth / self.screenSize.width) / 2
        let secondSpace: CGFloat = -fullSpace / 2 + (firstWidth / self.screenSize.width) + (secondWidth / self.screenSize.width) / 2
        
        let coefficent = 0.5 - (defaultPartHeight / self.screenSize.height) / 2
        
        self.quoteLabel = TOMSMorphingLabel(frame: CGRectMake(0, 0, firstWidth + 22, 30))
        self.quoteLabel.font = font
        self.quoteLabel.center =  CGPoint(x: self.screenSize.width / 2 - self.screenSize.width * firstSpace, y: 0)
        self.quoteLabel.text = "Here's to "
        self.quoteLabel.textAlignment = .Right
        self.contentView.addSubview(self.quoteLabel)
        
        let quoteObject = TutorialObject(object: self.quoteLabel)
        quoteObject.setPoints([CGPoint(x: 0.5 - firstSpace, y: 0.5), CGPoint(x: 1.5 - firstSpace, y: 0.5), CGPoint(x: 2.5 - firstSpace, y: coefficent), CGPoint(x: 3.5 - firstSpace, y: -0.1)])
        self.objects.append(quoteObject)
        
        let anotheQuoteLabel = UILabel(frame: CGRectMake(0, 0, secondWidth, 30))
        anotheQuoteLabel.center =  CGPoint(x: self.screenSize.width / 2 + self.screenSize.width * secondSpace, y: 0)
        anotheQuoteLabel.text = "   the Crazy Ones"
        anotheQuoteLabel.font = font
        anotheQuoteLabel.textAlignment = .Left
        self.contentView.addSubview(anotheQuoteLabel)
        
        let anotherQuoteObject = TutorialObject(object: anotheQuoteLabel)
        anotherQuoteObject.setPoints([CGPoint(x: 0.5 + secondSpace, y: 0.5), CGPoint(x: 1.5 + secondSpace, y: 0.5), CGPoint(x: 2.5 + secondSpace, y: coefficent), CGPoint(x: 3.5 + secondSpace, y: -0.1)])
        self.objects.append(anotherQuoteObject)
    }
    
    func addParagraph(value: String, atIndex index: Int) {
        let label = UILabel(frame: CGRectMake(0, 0, self.screenSize.width - 16, self.screenSize.height))
        label.center =  CGPoint(x: self.screenSize.width * 0.5, y: 0)
        label.text = value
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 18)
        label.textAlignment = .Center
        self.contentView.addSubview(label)
        
        let labelObject = TutorialObject(object: label)
        
        var points = [CGPoint(x: 1.5 + CGFloat(index), y: 0.9), CGPoint(x: 2.5 + CGFloat(index), y: 0.5), CGPoint(x: 3.5 + CGFloat(index), y: 0.1)]
        if index == 0 {
            points.removeAtIndex(0)
        }
        labelObject.setPoints(points)
        
        if index == 0 {
            labelObject.addActionAtPosition(TutorialObjectAction.ChangeAlpha(value: 1.0), position: 0)
            labelObject.addActionAtPosition(TutorialObjectAction.ChangeAlpha(value: 0.1), position: 1)
            labelObject.tag = 1
        } else {
            labelObject.addActionAtPosition(TutorialObjectAction.ChangeAlpha(value: 0.1), position: 0)
            labelObject.addActionAtPosition(TutorialObjectAction.ChangeAlpha(value: 1.0), position: 1)
            labelObject.addActionAtPosition(TutorialObjectAction.ChangeAlpha(value: index == 2 ? 0.0 : 0.1), position: 2)
        }
        
        self.objects.append(labelObject)
    }
    
    var lastContentOffset: CGPoint = CGPointZero
    var textState = 0
    var movingTimer: NSTimer?
    
    @objc
    func timerStep() {
        if self.scrollView.contentOffset.x <= self.screenSize.width * (self.numberOfScreens - 2) {
            self.scrollView.panGestureRecognizer.enabled = false
            self.scrollView.panGestureRecognizer.enabled = true
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.scrollView.contentOffset = CGPoint(x: self.scrollView.contentOffset.x + self.screenSize.width, y: self.scrollView.contentOffset.y)
            })
            
            if self.scrollView.contentOffset.x > self.screenSize.width * 1.0 {
                print(0.5 - (self.scrollView.contentOffset.x - self.screenSize.width) / self.screenSize.width)
                self.swipeLeftImageView.alpha = 0.5 - (self.scrollView.contentOffset.x - self.screenSize.width) / self.screenSize.width
            }
        }
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
        self.updatePageControl()
        
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
                self.swipeLeftImageView.alpha = 0.5 - (scrollView.contentOffset.x - self.screenSize.width) / self.screenSize.width
            }
        }
        
        if scrollView.contentOffset.x > self.lastContentOffset.x && scrollView.contentOffset.x > self.screenSize.width * 0.5 {
            if self.quoteLabel.text != "We are " {
                self.quoteLabel.setText("We are ", withCompletionBlock: nil)
                self.stopAnimation = true
            }
        } else if scrollView.contentOffset.x < self.lastContentOffset.x && scrollView.contentOffset.x < self.screenSize.width * 0.5 {
            if self.quoteLabel.text != "Here's to " {
                self.quoteLabel.setText("Here's to ", withCompletionBlock: nil)
            }
        }
        
        self.lastContentOffset = scrollView.contentOffset
    }
    
    func updatePageControl() {
        var pageNumber = Int(round((self.scrollView.contentOffset.x / self.screenSize.width)))
        pageNumber = min(max(0, pageNumber), Int(self.numberOfScreens - 1))
        self.pageControl.currentPage = pageNumber
    }
}

