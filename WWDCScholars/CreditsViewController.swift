//
//  CreditsViewController.swift
//  WWDCScholars
//
//  Created by Sam Eckert on 07.04.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

class CreditsViewController: UIViewController, SFSafariViewControllerDelegate, MFMailComposeViewControllerDelegate, QuickActionsDelegate {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.traitCollection.forceTouchCapability == .Available {
            self.registerForPreviewingWithDelegate(self, sourceView: self.view)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreditsViewController.showFullScreenImage))
        self.headerImageView.userInteractionEnabled = true
        self.headerImageView.addGestureRecognizer(tapGestureRecognizer)
        
        self.styleUI()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == String(ScholarDetailViewController) {
            if let indexPath = sender as? NSIndexPath {
                if let scholarId = CreditsManager.sharedInstance.getScholarId(indexPath) {
                    let destinationViewController = segue.destinationViewController as! ScholarDetailViewController
                    destinationViewController.setScholar(scholarId)
                }
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func moreInfoBarButtonItemPressed(sender: AnyObject) {
        let url = NSURL(string: "http://wwdcscholars.github.io")
        let viewController = SignUpSafariViewController(URL: url!)
        
        self.presentViewController(viewController, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Internal functions
    
    internal func showFullScreenImage() {
        ImageManager.sharedInstance.expandImage(self.headerImageView, viewController: self)
    }
    
    internal func openContactURL(url: String) {
        let viewController = SFSafariViewController(URL: NSURL(string: url)!)
        viewController.delegate = self
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    internal func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    internal func composeEmail(address: String) {
        if MFMailComposeViewController.canSendMail() {
            let viewController = MFMailComposeViewController()
            viewController.mailComposeDelegate = self
            viewController.setToRecipients([address])
            
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    internal func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.title = "Credits"
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

// MARK: - UIScrollViewDelegate

extension CreditsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let imageViewHeight: CGFloat = 200.0
        var imageViewFrame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: imageViewHeight)
        
        if scrollView.contentOffset.y < imageViewHeight {
            imageViewFrame.origin.y = scrollView.contentOffset.y
            imageViewFrame.size.height = -scrollView.contentOffset.y + imageViewHeight
        }
        
        self.headerImageView.frame = imageViewFrame
    }
}

// MARK: - TableViewDataSource

extension CreditsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CreditsManager.sharedInstance.credits.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let creditCell = self.tableView.dequeueReusableCellWithIdentifier("creditCell") as! CreditTableViewCell
        let currentCredit = CreditsManager.sharedInstance.credits[indexPath.item]
        let creditNameText = NSMutableAttributedString(string: currentCredit.name)
        let creditLocationText = NSMutableAttributedString(string: " (\(currentCredit.location))")
        
        creditNameText.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGrayColor(), range: NSRange(location: 0, length: creditNameText.length))
        creditLocationText.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSRange(location: 0, length: creditLocationText.length))
        creditNameText.appendAttributedString(creditLocationText)
        
        creditCell.scholarNameLabel.attributedText = creditNameText
        creditCell.scholarImageView.image = currentCredit.image
        
        creditCell.setIconVisibility(currentCredit.tasks)
        
        return creditCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 67.0
    }
}

// MARK: - TableViewDelegate

extension CreditsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(String(ScholarDetailViewController), sender: indexPath)
    }
}

// MARK: - UIViewControllerPreviewingDelegate

extension CreditsViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("scholarDetailViewController") as? ScholarDetailViewController
        let cellPosition = self.tableView.convertPoint(location, fromView: self.view)
        let cellIndex = self.tableView.indexPathForRowAtPoint(cellPosition)
        
        guard let previewViewController = viewController, indexPath = cellIndex, cell = self.tableView.cellForRowAtIndexPath(indexPath) else {
            return nil
        }
        
        if let scholarId = CreditsManager.sharedInstance.getScholarId(indexPath) {
            previewViewController.setScholar(scholarId)
        }
        previewViewController.delegate = self
        previewViewController.preferredContentSize = CGSize.zero
        previewingContext.sourceRect = self.view.convertRect(cell.frame, fromView: self.tableView)
        
        return previewViewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        self.showViewController(viewControllerToCommit, sender: self)
    }
}
