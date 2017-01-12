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
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var headerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.traitCollection.forceTouchCapability == .available {
            self.registerForPreviewing(with: self, sourceView: self.view)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreditsViewController.showFullScreenImage))
        self.headerImageView.isUserInteractionEnabled = true
        self.headerImageView.addGestureRecognizer(tapGestureRecognizer)
        
        self.styleUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: ScholarDetailViewController()) {
            if let indexPath = sender as? IndexPath {
                if let scholarId = CreditsManager.sharedInstance.getScholarId(indexPath) {
                    let destinationViewController = segue.destination as! ScholarDetailViewController
                    destinationViewController.setScholar(scholarId)
                }
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func moreInfoBarButtonItemPressed(_ sender: AnyObject) {
        let url = Foundation.URL(string: "http://wwdcscholars.github.io")
        let viewController = SignUpSafariViewController(url: url!)
        
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Internal functions
    
    internal func showFullScreenImage() {
        ImageManager.sharedInstance.expandImage(self.headerImageView, viewController: self)
    }
    
    internal func openContactURL(_ url: String) {
        let viewController = SFSafariViewController(url: Foundation.URL(string: url)!)
        viewController.delegate = self
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    internal func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    internal func composeEmail(_ address: String) {
        if MFMailComposeViewController.canSendMail() {
            let viewController = MFMailComposeViewController()
            viewController.mailComposeDelegate = self
            viewController.setToRecipients([address])
            
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    internal func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UI
    
    fileprivate func styleUI() {
        self.title = "Credits"
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}

// MARK: - UIScrollViewDelegate

extension CreditsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CreditsManager.sharedInstance.credits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let creditCell = self.tableView.dequeueReusableCell(withIdentifier: "creditCell") as! CreditTableViewCell
        let currentCredit = CreditsManager.sharedInstance.credits[indexPath.item]
        let creditNameText = NSMutableAttributedString(string: currentCredit.name)
        let creditLocationText = NSMutableAttributedString(string: " (\(currentCredit.location))")
        
        creditNameText.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSRange(location: 0, length: creditNameText.length))
        creditLocationText.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range: NSRange(location: 0, length: creditLocationText.length))
        creditNameText.append(creditLocationText)
        
        creditCell.scholarNameLabel.attributedText = creditNameText
        creditCell.scholarImageView.image = currentCredit.image
        
        creditCell.setIconVisibility(currentCredit.tasks)
        
        return creditCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67.0
    }
}

// MARK: - TableViewDelegate

extension CreditsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: String(describing: "ScholarDetailViewController"), sender: indexPath)
    }
}

// MARK: - UIViewControllerPreviewingDelegate

extension CreditsViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "scholarDetailViewController") as? ScholarDetailViewController
        let cellPosition = self.tableView.convert(location, from: self.view)
        let cellIndex = self.tableView.indexPathForRow(at: cellPosition)
        
        guard let previewViewController = viewController, let indexPath = cellIndex, let cell = self.tableView.cellForRow(at: indexPath) else {
            return nil
        }
        
        if let scholarId = CreditsManager.sharedInstance.getScholarId(indexPath) {
            previewViewController.setScholar(scholarId)
        }
        previewViewController.delegate = self
        previewViewController.preferredContentSize = CGSize.zero
        previewingContext.sourceRect = self.view.convert(cell.frame, from: self.tableView)
        
        return previewViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.show(viewControllerToCommit, sender: self)
    }
}
