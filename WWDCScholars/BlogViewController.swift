//
//  BlogViewController.swift
//  WWDCScholars
//
//  Created by Sam Eckert on 07.04.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit
import SafariServices

class BlogViewController: UIViewController {
    @IBOutlet private weak var tableView: NoJumpRefreshTableView!
    @IBOutlet private weak var loadingContainerView: UIView!
    
    private var blogPosts: [BlogPost] = []
    
    private var refreshControl: UIRefreshControl!
    private var loadingViewController: LoadingViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        self.configureUI()
        self.addRefreshControl()
        self.loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.refreshControl.superview?.sendSubviewToBack(self.refreshControl)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == String(BlogPostDetailViewController) {
            let destinationViewController = segue.destinationViewController as! BlogPostDetailViewController
            
            if let indexPath = sender as? NSIndexPath {
                destinationViewController.currentPost = self.blogPosts[indexPath.item]
            }
        } else if segue.identifier == String(LoadingViewController) {
            self.loadingViewController = segue.destinationViewController as! LoadingViewController
        }
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.title = "Blog"
    }
    
    private func configureUI() {
        self.loadingViewController.loadingMessage = "Loading Blog Posts..."
        self.loadingViewController.startAnimating()
        
        if self.traitCollection.forceTouchCapability == .Available {
            self.registerForPreviewingWithDelegate(self, sourceView: self.view)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - Private functions
    
    private func addRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(BlogViewController.loadData), forControlEvents: .ValueChanged)
        self.tableView.addSubview(self.refreshControl)
    }
    
    // MARK: - Internal functions
    
    internal func loadData() {
        BlogKit.sharedInstance.loadPosts() {
            self.blogPosts = DatabaseManager.sharedInstance.getAllBlogPosts()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            
            if self.loadingViewController.isAnimating() {
                self.loadingContainerView.hidden = true
                self.loadingViewController.stopAnimating()
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func addPostAction(sender: AnyObject) {
        let url = NSURL(string: "https://wwdcscholars.herokuapp.com/submitpost")
        let viewController = BlogPostSafariViewController(URL: url!)
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
}

extension BlogViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blogPosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("blogPostTableViewCell") as! BlogPostTableViewCell
        let post = self.blogPosts[indexPath.row]
        
        let authorString = "written by \(post.scholarName)" as NSString
        let attributedAuthorString = NSMutableAttributedString(string: authorString as String)
        
        let firstAttribute = [NSForegroundColorAttributeName: UIColor.mediumWhiteTextColor()]
        attributedAuthorString.addAttributes(firstAttribute, range: authorString.rangeOfString("written by"))
        
        let secondAttribute = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        attributedAuthorString.addAttributes(secondAttribute, range: authorString.rangeOfString("\(post.scholarName)"))
        
        cell.postAuthorLabel.attributedText = attributedAuthorString
        cell.postDateLabel.text = DateManager.shortDateStringFromDate(post.createdAt)
        cell.postTitleLabel.text = post.title
        
        if let imgUrl = NSURL(string: post.headerImage) {
            cell.postImageView.af_setImageWithURL(imgUrl, placeholderImage: UIImage(named: "placeholder"), imageTransition: .CrossDissolve(0.2), runImageTransitionIfCached: false)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.bounds.width / 16.0 * 9.0
    }
}

extension BlogViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(String(BlogPostDetailViewController), sender: indexPath)
    }
}

// MARK: - UIScrollViewDelegate

extension BlogViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let visibleCells = self.tableView.visibleCells as! [BlogPostTableViewCell]
        
        for cell in visibleCells {
            cell.cellOnTableView(self.tableView, view: self.view)
        }
    }
}

// MARK: - UIViewControllerPreviewingDelegate

extension BlogViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("blogPostDetailViewController") as? BlogPostDetailViewController
        let cellPosition = self.tableView.convertPoint(location, fromView: self.view)
        let cellIndex = self.tableView.indexPathForRowAtPoint(cellPosition)
        
        guard let previewViewController = viewController, indexPath = cellIndex, cell = self.tableView.cellForRowAtIndexPath(indexPath) as? BlogPostTableViewCell else {
            return nil
        }
        
        let post = self.blogPosts[indexPath.item]
        let bounds = CGRect(origin: cell.postImageView.bounds.origin, size: CGSize(width: cell.postImageView.bounds.width, height: cell.postImageView.bounds.height - 50.0))
        
        previewViewController.currentPost = post
        previewViewController.preferredContentSize = CGSize.zero
        previewingContext.sourceRect = self.view.convertRect(bounds, fromView: cell)
        
        return previewViewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        self.view.endEditing(true)
        
        self.showViewController(viewControllerToCommit, sender: self)
    }
}
