//
//  BlogPostDetailViewController.swift
//  WWDCScholars
//
//  Created by Sam Eckert on 19.05.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

enum AuthorButtonType {
    case Image
    case Text
}

class BlogPostDetailViewController: UIViewController, SFSafariViewControllerDelegate, MFMailComposeViewControllerDelegate, QuickActionsDelegate {
    @IBOutlet private weak var headerImageView: UIImageView!
    @IBOutlet private weak var authorProfileImageButton: UIButton!
    @IBOutlet private weak var authorProfileImageViewBackground: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tagsLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var webView: UIWebView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet weak var authorButton: UIButton!
    
    private var titleView = UIScrollView()
    private var titleViewLabel = UILabel()
    private var titleViewOverlayLabel = UILabel()
    private var buttonTypeTapped: AuthorButtonType = .Image
    private var currentPostAuthor: Scholar? {
        return DatabaseManager.sharedInstance.scholarForId(self.currentPost.scholarId)
    }
    
    var currentPost: BlogPost!
    
    override func viewDidLoad() {
        self.styleUI()
        self.configureUI()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeTitleView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addTitleView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let body = NSString(format:"<html> \n" +
            "<head>\n" +
            "<style type=\"text/css\">\n" +
            "body {font-family: \"%@\"; font-size: %f;}\n" +
            "img {max-width: \(self.view.frame.width - 32.0)px; padding: 16px 0px 16px 0px;}\n" +
            "h1, h2, h3, h4, h5, h6 {font-weight: normal;}\n" +
            "</style>\n" +
            "</head>\n" +
            "<body>%@</body>\n" +
            "</html>", UIFont.preferredFontForTextStyle(UIFontTextStyleBody).fontName, UIFont.preferredFontForTextStyle(UIFontTextStyleBody).pointSize - 2.0, self.currentPost.content)
        
        self.webView.loadHTMLString(body as String, baseURL: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == String(ScholarDetailViewController) {
            let destinationViewController = segue.destinationViewController as! ScholarDetailViewController
            destinationViewController.delegate = self
            destinationViewController.setScholar(self.currentPost.scholarId)
        }
    }
    
    // MARK: - Internal functions
    
    internal func openContactURL(url: String) {
        let viewController = SFSafariViewController(URL: NSURL(string: url)!)
        viewController.delegate = self
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    internal func composeEmail(address: String) {
        if MFMailComposeViewController.canSendMail() {
            let viewController = MFMailComposeViewController()
            viewController.mailComposeDelegate = self
            viewController.setToRecipients([address])
            
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    internal func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    internal func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    internal func showFullScreenHeader() {
        ImageManager.sharedInstance.expandImage(self.headerImageView, viewController: self)
    }
    
    // MARK: - Private functions
    
    private func removeTitleView() {
        self.titleViewOverlayLabel.removeFromSuperview()
        
        if self.titleView.contentOffset.y != 44.0 {
            let contentOffset = CGPointMake(0.0, 44.0)
            
            self.titleView.contentOffset.y = contentOffset.y
            self.titleViewLabel.text = "Blog Post"
        }
    }
    
    private func addTitleView() {
        guard let navigationBar = self.navigationController?.navigationBar else {
            return
        }
        
        let labelHeight: CGFloat = 44.0
        
        self.titleViewOverlayLabel.text = "Blog Post"
        self.titleViewOverlayLabel.textAlignment = .Center
        self.titleViewOverlayLabel.font = UIFont.boldSystemFontOfSize(17.0)
        self.titleViewOverlayLabel.textColor = UIColor.whiteColor()
        self.titleViewOverlayLabel.frame = CGRectMake(75.0, 0.0, navigationBar.frame.width - 150.0, labelHeight)
        self.navigationController?.navigationBar.addSubview(self.titleViewOverlayLabel)
        
        self.titleView = UIScrollView(frame: CGRectMake(0.0, labelHeight, navigationBar.frame.width - 200.0, labelHeight))
        self.titleView.contentSize = CGSizeMake(0.0, labelHeight * 2.0)
        self.titleView.userInteractionEnabled = false
        
        self.titleViewLabel.frame = CGRectMake(0, labelHeight, self.titleView.frame.width, labelHeight)
        self.titleViewLabel.textAlignment = .Center
        self.titleViewLabel.font = UIFont.boldSystemFontOfSize(17.0)
        self.titleViewLabel.textColor = UIColor.whiteColor()
        self.titleView.addSubview(self.titleViewLabel)
        self.navigationItem.titleView = self.titleView
        self.titleViewLabel.text = self.currentPost.title
        
        self.scrollViewDidScroll(self.scrollView)
    }
    
    private func configureUI() {
        if self.traitCollection.forceTouchCapability == .Available {
            self.registerForPreviewingWithDelegate(self, sourceView: self.authorButton)
            self.registerForPreviewingWithDelegate(self, sourceView: self.authorProfileImageButton)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BlogPostDetailViewController.showFullScreenHeader))
        self.headerImageView.userInteractionEnabled = true
        self.headerImageView.addGestureRecognizer(tapGestureRecognizer)
        
        self.titleLabel.text = self.currentPost.title
        self.authorButton.setTitle(self.currentPost.scholarName, forState: .Normal)
        
        //        var tagsString = ""
        //        for (index, tag) in self.currentPost!.tags.enumerate() {
        //            tagsString.appendContentsOf(index != self.currentPost!.tags.count - 1 ? "\(tag), " : tag)
        //        }
        //        self.tagsLabel.text = tagsString
        self.dateLabel.text = DateManager.shortDateStringFromDate(self.currentPost.createdAt)
        
        self.headerImageView.af_setImageWithURL(NSURL(string: self.currentPost.headerImage)!, placeholderImage: UIImage(named: "placeholder"), imageTransition: .CrossDissolve(0.2), runImageTransitionIfCached: false)
        self.authorProfileImageButton.af_setBackgroundImageForState(.Normal, URL: NSURL(string: self.currentPostAuthor!.profilePicURL)!, placeHolderImage: UIImage(named: "placeholder"), progress: nil, progressQueue: dispatch_get_main_queue(), completion: nil)
    }
    
    private func styleUI() {
        self.webView.scrollView.scrollEnabled = false
        self.webView.scrollView.bounces = false
        
        self.authorButton.contentHorizontalAlignment = .Left
        self.authorButton.setTitleColor(UIColor.scholarsPurpleColor(), forState: .Normal)
        
        self.authorProfileImageButton.applyRoundedCorners()
        self.authorProfileImageViewBackground.applyRoundedCorners()
    }
    
    // MARK: - IBActions
    
    @IBAction func authorNameButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier(String(ScholarDetailViewController), sender: nil)
    }
    
    @IBAction func authorNameButtonTouched(sender: AnyObject) {
        self.buttonTypeTapped = sender.tag == 0 ? .Text : .Image
    }
}

// MARK: - UIWebViewDelegate

extension BlogPostDetailViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        var frame = webView.frame
        frame.size.height = 1.0
        webView.frame = frame
        
        let fittingSize = webView.sizeThatFits(.zero)
        frame.size = fittingSize
        webView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height - 1.0)
        
        self.scrollView.contentSize.height = self.webView.frame.origin.y + self.webView.frame.height - 40.0
    }
}

// MARK: - UIScrollViewDelegate

extension BlogPostDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // HeaderImageView
        
        let imageViewHeight: CGFloat = 156.0
        var imageViewFrame = CGRect(x: 0.0, y: 0.0, width: scrollView.bounds.width, height: imageViewHeight)
        
        if scrollView.contentOffset.y < imageViewHeight {
            imageViewFrame.origin.y = scrollView.contentOffset.y
            imageViewFrame.size.height = -scrollView.contentOffset.y + imageViewHeight
        }
        
        // TitleView
        
        self.headerImageView.frame = imageViewFrame
        
        let contentOffset: CGPoint = CGPointMake(0.0, min(scrollView.contentOffset.y - imageViewHeight - (self.titleLabel.frame.height / 2.0) + 22.0, 44.0))
        self.titleView.contentOffset.y = contentOffset.y
        self.titleViewOverlayLabel.alpha = -((self.titleView.contentOffset.y) / 25.0)
    }
}

// MARK: - UIViewControllerPreviewingDelegate

extension BlogPostDetailViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("scholarDetailViewController") as? ScholarDetailViewController
        
        guard let previewViewController = viewController else {
            return nil
        }
        
        previewViewController.setScholar(self.currentPost.scholarId)
        previewViewController.delegate = self
        previewViewController.preferredContentSize = CGSize.zero
        previewingContext.sourceRect = self.buttonTypeTapped == .Text ? self.authorButton.frame : self.authorProfileImageButton.bounds
        
        return previewViewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        self.showViewController(viewControllerToCommit, sender: self)
    }
}