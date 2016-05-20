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
    
    private var posts: [BlogPost] = []
    private var refreshControl: UIRefreshControl!
    private let exampleImages = [UIImage(named: "example1"), UIImage(named: "example2"), UIImage(named: "example3")]
    private let exampleTitles = ["Planning Your Week at WWDC", "Things You Must Visit in San Francisco", "Tips for Preparing for WWDC 2016"]
    private let exampleAuthors = ["Andrew Walker", "Oliver Binns", "Sam Eckert"]
    private let exampleDates = ["2d ago", "3d ago", "5d ago"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        self.addRefreshControl()
        
        BlogKit.sharedInstance.loadPosts() {
            self.posts = DatabaseManager.sharedInstance.getAllBlogPosts()
            
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollViewDidScroll(self.tableView)
        self.refreshControl.superview?.sendSubviewToBack(self.refreshControl)
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.title = "Blog"
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
        self.refreshControl.endRefreshing()
    }
    
    // MARK: - IBActions
    
    @IBAction func addPostAction(sender: AnyObject) {
        let url = NSURL(string: "http://wwdcscholarsform.herokuapp.com/addpost")
        let viewController = BlogPostSafariViewController(URL: url!)
            
        self.presentViewController(viewController, animated: true, completion: nil)
    }
}

extension BlogViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("blogPostTableViewCell") as! BlogPostTableViewCell
        let post = self.posts[indexPath.row]
        
        let authorString = "written by \(post.scholarName)" as NSString
        let attributedAuthorString = NSMutableAttributedString(string: authorString as String)
        
        let firstAttribute = [NSForegroundColorAttributeName: UIColor.mediumWhiteTextColor()]
        attributedAuthorString.addAttributes(firstAttribute, range: authorString.rangeOfString("written by"))
        
        let secondAttribute = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        attributedAuthorString.addAttributes(secondAttribute, range: authorString.rangeOfString("\(post.scholarName)"))
        
        cell.postAuthorLabel.attributedText = attributedAuthorString
        cell.postDateLabel.text = String(post.updatedAt)
        cell.postTitleLabel.text = post.title
        
        if let imgUrl = NSURL(string: post.imageUrl) {
            cell.postImageView.af_setImageWithURL(imgUrl)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.bounds.width / 16.0 * 9.0
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
