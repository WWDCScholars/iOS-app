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
    @IBOutlet fileprivate weak var tableView: NoJumpRefreshTableView!
    @IBOutlet fileprivate weak var loadingContainerView: UIView!
    
    fileprivate var blogPosts: [BlogPost] = []
    
    fileprivate var refreshControl: UIRefreshControl!
    fileprivate var loadingViewController: LoadingViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        self.configureUI()
        self.addRefreshControl()
        self.loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.refreshControl.superview?.sendSubview(toBack: self.refreshControl)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: BlogPostDetailViewController()) {
            let destinationViewController = segue.destination as! BlogPostDetailViewController
            
            if let indexPath = sender as? IndexPath {
                destinationViewController.currentPost = self.blogPosts[indexPath.item]
            }
        } else if segue.identifier == String(describing: LoadingViewController()) {
            self.loadingViewController = segue.destination as! LoadingViewController
        }
    }
    
    // MARK: - UI
    
    fileprivate func styleUI() {
        self.title = "Blog"
    }
    
    fileprivate func configureUI() {
        self.loadingViewController.loadingMessage = "Loading Blog Posts..."
        self.loadingViewController.startAnimating()
        
        if self.traitCollection.forceTouchCapability == .available {
            self.registerForPreviewing(with: self, sourceView: self.view)
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private functions
    
    fileprivate func addRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(BlogViewController.loadData), for: .valueChanged)
        self.tableView.addSubview(self.refreshControl)
    }
    
    // MARK: - Internal functions
    
    internal func loadData() {
        BlogKit.sharedInstance.loadPosts() {
            self.blogPosts = DatabaseManager.sharedInstance.getAllBlogPosts()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            
            if self.loadingViewController.isAnimating() {
                self.loadingContainerView.isHidden = true
                self.loadingViewController.stopAnimating()
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func addPostAction(_ sender: AnyObject) {
        let url = Foundation.URL(string: "https://wwdcscholars.herokuapp.com/submitpost")
        let viewController = BlogPostSafariViewController(url: url!)
        
        self.present(viewController, animated: true, completion: nil)
    }
}

extension BlogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blogPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "blogPostTableViewCell") as! BlogPostTableViewCell
        let post = self.blogPosts[indexPath.row]
        
        var authorString = "" as NSString
        
        if (post.scholarId == nil) {
            authorString = "written by \(post.scholarName) (Guest post)" as NSString

        } else {
            authorString = "written by \(post.scholarName)" as NSString
        }
        
        let attributedAuthorString = NSMutableAttributedString(string: authorString as String)
        
        let firstAttribute = [NSForegroundColorAttributeName: UIColor.mediumWhiteTextColor()]
        attributedAuthorString.addAttributes(firstAttribute, range: authorString.range(of: "written by"))
        
        let secondAttribute = [NSForegroundColorAttributeName: UIColor.white]
        attributedAuthorString.addAttributes(secondAttribute, range: authorString.range(of: "\(post.scholarName)"))
        
        cell.postAuthorLabel.attributedText = attributedAuthorString
        cell.postDateLabel.text = DateManager.shortDateStringFromDate(post.createdAt)
        cell.postTitleLabel.text = post.title
        
        if let imgUrl = Foundation.URL(string: post.headerImage) {
            cell.postImageView.af_setImage(withURL: imgUrl, placeholderImage: UIImage(named: "placeholder"), imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.width / 16.0 * 9.0
    }
}

extension BlogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: String(describing: BlogPostDetailViewController()), sender: indexPath)
    }
}

// MARK: - UIScrollViewDelegate

extension BlogViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleCells = self.tableView.visibleCells as! [BlogPostTableViewCell]
        
        for cell in visibleCells {
            cell.cellOnTableView(self.tableView, view: self.view)
        }
    }
}

// MARK: - UIViewControllerPreviewingDelegate

extension BlogViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "blogPostDetailViewController") as? BlogPostDetailViewController
        let cellPosition = self.tableView.convert(location, from: self.view)
        let cellIndex = self.tableView.indexPathForRow(at: cellPosition)
        
        guard let previewViewController = viewController, let indexPath = cellIndex, let cell = self.tableView.cellForRow(at: indexPath) as? BlogPostTableViewCell else {
            return nil
        }
        
        let post = self.blogPosts[indexPath.item]
        let bounds = CGRect(origin: cell.postImageView.bounds.origin, size: CGSize(width: cell.postImageView.bounds.width, height: cell.postImageView.bounds.height - 50.0))
        
        previewViewController.currentPost = post
        previewViewController.preferredContentSize = CGSize.zero
        previewingContext.sourceRect = self.view.convert(bounds, from: cell)
        
        return previewViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.view.endEditing(true)
        
        self.show(viewControllerToCommit, sender: self)
    }
}
