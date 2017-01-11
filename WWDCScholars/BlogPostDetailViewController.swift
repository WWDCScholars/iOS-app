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
import Alamofire
import AlamofireImage

enum AuthorButtonType {
    case image
    case text
}

class BlogPostDetailViewController: UIViewController, SFSafariViewControllerDelegate, MFMailComposeViewControllerDelegate, QuickActionsDelegate {
    @IBOutlet fileprivate weak var headerImageView: UIImageView!
    @IBOutlet fileprivate weak var authorProfileImageButton: UIButton!
    @IBOutlet fileprivate weak var authorProfileImageViewBackground: UIView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var tagsLabel: UILabel!
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    @IBOutlet fileprivate weak var webView: UIWebView!
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var authorButton: UIButton!
    
    fileprivate var titleView = UIScrollView()
    fileprivate var titleViewLabel = UILabel()
    fileprivate var titleViewOverlayLabel = UILabel()
    fileprivate var buttonTypeTapped: AuthorButtonType = .image
    fileprivate var currentPostAuthor: Scholar? {
        if let scholarId = self.currentPost.scholarId {
            return DatabaseManager.sharedInstance.scholarForId(scholarId)
        }else {
            return nil
        }
    }
    
    var currentPost: BlogPost!
    
    override func viewDidLoad() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.styleUI()
        self.configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeTitleView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addTitleView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let body = NSString(format:"<html> \n" +
            "<head>\n" +
            "<meta name = \"viewport\" content = \"initial-scale = 1.0\" />" +
            "<style type=\"text/css\">\n" +
            "body {font-family: \"%@\"; font-size: %f; margin-bottom=150px;}\n" +
            "img {max-width: \(self.view.frame.width - 32.0)px; padding: 16px 0px 16px 0px;}\n" +
            "h1, h2, h3, h4, h5, h6 {font-weight: normal;}\n" +
            "</style>\n" +
            "</head>\n" +
            "<body>%@</body>\n" +
            "</html>", UIFont.preferredFont(forTextStyle: UIFontTextStyle.body).fontName, UIFont.preferredFont(forTextStyle: UIFontTextStyle.body).pointSize - 2.0, self.currentPost.content)
        
        self.webView.loadHTMLString(body as String, baseURL: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: ScholarDetailViewController()) {
            let destinationViewController = segue.destination as! ScholarDetailViewController
            destinationViewController.delegate = self
            destinationViewController.setScholar(self.currentPostAuthor!.id)
        }
    }
    
    // MARK: - Internal functions
    
    internal func openContactURL(_ url: String) {
        let viewController = SFSafariViewController(url: Foundation.URL(string: url)!)
        viewController.delegate = self
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    internal func composeEmail(_ address: String) {
        if MFMailComposeViewController.canSendMail() {
            let viewController = MFMailComposeViewController()
            viewController.mailComposeDelegate = self
            viewController.setToRecipients([address])
            
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    internal func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    internal func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    internal func showFullScreenHeader() {
        ImageManager.sharedInstance.expandImage(self.headerImageView, viewController: self)
    }
    
    // MARK: - Private functions
    
    fileprivate func removeTitleView() {
        self.titleViewOverlayLabel.removeFromSuperview()
        
        if self.titleView.contentOffset.y != 44.0 {
            let contentOffset = CGPoint(x: 0.0, y: 44.0)
            
            self.titleView.contentOffset.y = contentOffset.y
            self.titleViewLabel.text = "Blog Post"
        }
    }
    
    fileprivate func addTitleView() {
        guard let navigationBar = self.navigationController?.navigationBar else {
            return
        }
        
        let labelHeight: CGFloat = 44.0
        
        self.titleViewOverlayLabel.text = "Blog Post"
        self.titleViewOverlayLabel.textAlignment = .center
        self.titleViewOverlayLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        self.titleViewOverlayLabel.textColor = UIColor.white
        self.titleViewOverlayLabel.frame = CGRect(x: 75.0, y: 0.0, width: navigationBar.frame.width - 150.0, height: labelHeight)
        self.navigationController?.navigationBar.addSubview(self.titleViewOverlayLabel)
        
        self.titleView = UIScrollView(frame: CGRect(x: 0.0, y: labelHeight, width: navigationBar.frame.width - 200.0, height: labelHeight))
        self.titleView.contentSize = CGSize(width: 0.0, height: labelHeight * 2.0)
        self.titleView.isUserInteractionEnabled = false
        
        self.titleViewLabel.frame = CGRect(x: 0, y: labelHeight, width: self.titleView.frame.width, height: labelHeight)
        self.titleViewLabel.textAlignment = .center
        self.titleViewLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        self.titleViewLabel.textColor = UIColor.white
        self.titleView.addSubview(self.titleViewLabel)
        self.navigationItem.titleView = self.titleView
        self.titleViewLabel.text = self.currentPost.title
        
        self.scrollViewDidScroll(self.scrollView)
    }
    
    fileprivate func configureUI() {
        if self.traitCollection.forceTouchCapability == .available {
            self.registerForPreviewing(with: self, sourceView: self.authorButton)
            self.registerForPreviewing(with: self, sourceView: self.authorProfileImageButton)
        }
    
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BlogPostDetailViewController.showFullScreenHeader))
        self.headerImageView.isUserInteractionEnabled = true
        self.headerImageView.addGestureRecognizer(tapGestureRecognizer)
        
        self.titleLabel.text = self.currentPost.title
        self.dateLabel.text = DateManager.shortDateStringFromDate(self.currentPost.createdAt)
        self.headerImageView.af_setImage(withURL: Foundation.URL(string: self.currentPost.headerImage)!, placeholderImage: UIImage(named: "placeholder"), imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: false, completion: nil)
        
        self.authorButton.setTitle(self.currentPost.scholarName, for: UIControlState())

        if self.currentPostAuthor != nil{
            
            
            self.authorProfileImageButton.af_setBackgroundImage(for: .normal, url: Foundation.URL(string: self.currentPostAuthor!.latestBatch.profilePic)!, placeholderImage: UIImage(named: "placeholder"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, completion: nil)
            
            
          //  self.authorProfileImageButton.af_setBackgroundImage(for: .normal, URL: Foundation.URL(string: self.currentPostAuthor!.latestBatch.profilePic)!, placeHolderImage: UIImage(named: "placeholder"), progress: nil, progressQueue: DispatchQueue.main, completion: nil)
        } else {
            
            self.authorProfileImageButton.af_setBackgroundImage(for: .normal, url: Foundation.URL(string: "https://wwdcscholars.s3.amazonaws.com/scholarImages/2016_s_C_profilePic2015_1465646958901.png")!, placeholderImage: UIImage(named: "placeholder"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, completion: nil)
            
            
            // self.authorProfileImageButton.af_setBackgroundImage(for: .normal, URL: Foundation.URL(string: "https://wwdcscholars.s3.amazonaws.com/scholarImages/2016_s_C_profilePic2015_1465646958901.png")!, placeHolderImage: UIImage(named: "placeholder"), progress: nil, progressQueue: DispatchQueue.main, completion: nil)
//            self.authorProfileImageButton.enabled = false
//            self.authorButton.enabled = false
        }

    }
    
    fileprivate func styleUI() {
        self.webView.scrollView.isScrollEnabled = false
        self.webView.scrollView.bounces = false
        
        self.authorButton.contentHorizontalAlignment = .left
        self.authorButton.setTitleColor(UIColor.scholarsPurpleColor(), for: UIControlState())
        
        self.authorProfileImageButton.applyRoundedCorners()
        self.authorProfileImageViewBackground.applyRoundedCorners()
        
        self.titleLabel.adjustsFontSizeToFitWidth = true
    }

    // MARK: - IBActions
    
    @IBAction func authorNameButtonTapped(_ sender: AnyObject) {
     
        if (self.currentPost.scholarId == nil) {
            let guestURL = Foundation.URL(string: self.currentPost.guestLink!)
            let safariVC = SFSafariViewController(url: guestURL!)
//            safariVC.delegate = self
            present(safariVC, animated: true, completion: nil)
            
        } else {
            self.performSegue(withIdentifier: String(describing: ScholarDetailViewController()), sender: nil)
        }
    }
    
    @IBAction func authorNameButtonTouched(_ sender: AnyObject) {
        self.buttonTypeTapped = sender.tag == 0 ? .text : .image
    }
}

// MARK: - UIWebViewDelegate

extension BlogPostDetailViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        var frame = webView.frame
        frame.size.height = 1.0
        webView.frame = frame
        
        let fittingSize = webView.sizeThatFits(.zero)
        frame.size = fittingSize
        webView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height)
        
        self.scrollView.contentSize.height = self.webView.frame.origin.y + self.webView.frame.height + 10
        self.webView.backgroundColor = UIColor.white
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.linkClicked {
            let viewController = SFSafariViewController(url: request.url!)
            viewController.delegate = self
            
            self.present(viewController, animated: true, completion: nil)
            return false
        }
        return true
    }
}

// MARK: - UIScrollViewDelegate

extension BlogPostDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // HeaderImageView
        
        let imageViewHeight: CGFloat = 156.0
        var imageViewFrame = CGRect(x: 0.0, y: 0.0, width: scrollView.bounds.width, height: imageViewHeight)
        
        if scrollView.contentOffset.y < imageViewHeight {
            imageViewFrame.origin.y = scrollView.contentOffset.y
            imageViewFrame.size.height = -scrollView.contentOffset.y + imageViewHeight
        }
        
        // TitleView
        
        self.headerImageView.frame = imageViewFrame
        
        let contentOffset: CGPoint = CGPoint(x: 0.0, y: min(scrollView.contentOffset.y - imageViewHeight - (self.titleLabel.frame.height / 2.0) + 22.0, 44.0))
        self.titleView.contentOffset.y = contentOffset.y
        self.titleViewOverlayLabel.alpha = -((self.titleView.contentOffset.y) / 25.0)
    }
}

// MARK: - UIViewControllerPreviewingDelegate

extension BlogPostDetailViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if (self.currentPost.scholarId == nil) {
            let guestURL = Foundation.URL(string: self.currentPost.guestLink!)
            let safariVC = SFSafariViewController(url: guestURL!)
            
            return safariVC
        } else {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "scholarDetailViewController") as? ScholarDetailViewController
            
            guard let previewViewController = viewController else {
                return nil
            }
            
            previewViewController.setScholar(self.currentPostAuthor!.id)
            previewViewController.delegate = self
            previewViewController.preferredContentSize = CGSize.zero
            previewingContext.sourceRect = self.buttonTypeTapped == .text ? self.authorButton.frame : self.authorProfileImageButton.bounds
            
            return previewViewController
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.show(viewControllerToCommit, sender: self)
    }
}
