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
    
    private var testPosts: [BlogPost] = []
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testPost = BlogPost()
        testPost.id = "123"
        testPost.scholarName = "Andrew Walker"
        testPost.email = "me@andrewnwalker.com"
        testPost.title = "Preparing for WWDC"
        testPost.createdAt = NSDate()
        testPost.updatedAt = NSDate()
        testPost.imageUrl = "http://www.blogcdn.com/www.engadget.com/media/2013/06/wwdc2013-floor.jpg"
        testPost.scholarLink = ""
        testPost.tags = ["Travel", "Events", "Tips"]
        testPost.videoLink = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
        testPost.content = "Here is some content!"
        
        self.testPosts.append(testPost)
        
        self.styleUI()
        self.addRefreshControl()
        
        BlogKit.sharedInstance.loadPosts() {
            self.testPosts = DatabaseManager.sharedInstance.getAllBlogPosts()
            
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollViewDidScroll(self.tableView)
        self.refreshControl.superview?.sendSubviewToBack(self.refreshControl)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == String(BlogPostDetailViewController) {
            let destinationViewController = segue.destinationViewController as! BlogPostDetailViewController
            
            if let indexPath = sender as? NSIndexPath {
                destinationViewController.currentPost = self.testPosts[indexPath.item]
            }
        }
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
        return self.testPosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("blogPostTableViewCell") as! BlogPostTableViewCell
        let post = self.testPosts[indexPath.row]
        
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
