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
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [BlogPost]!
    
    let exampleImages = [UIImage(named: "example1"),
                         UIImage(named: "example2"),
                         UIImage(named: "example3")]
    let exampleTitles = ["Planning Your Week at WWDC", "Things You Must Visit in San Francisco", "Tips for Preparing for WWDC 2016"]
    let exampleAuthors = ["Andrew Walker", "Oliver Binns", "Sam Eckert"]
    let exampleDates = ["23/02/2015", "10/04/2016", "08/12/2015"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        
        posts = DatabaseManager.sharedInstance.getAllBlogPosts()

        
        BlogKit.sharedInstance.loadPosts() {
            self.posts = DatabaseManager.sharedInstance.getAllBlogPosts()
            print ("HI! \(self.posts)")

            self.tableView.reloadData()
//            if self.loadingView.isAnimating() {
//                self.loadingView.stopAnimating()
//            }
            
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollViewDidScroll(self.tableView)
    }
    
    // MARK: - UI
    
    func styleUI() {
        self.title = "Blog"
    }
    
    @IBAction func addPostAction(sender: AnyObject) {
            print("Pressed Sign Up")
            
            let url = NSURL(string: "http://wwdcscholarsform.herokuapp.com/addpost")
            
            let signUpVC = BlogPostSafariViewController(URL: url!)
            
            self.presentViewController(signUpVC, animated: true, completion: nil)
            //  UIApplication.sharedApplication().statusBarStyle = .Default
            

    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

extension BlogViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exampleImages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("blogPostTableViewCell") as! BlogPostTableViewCell
        
//        let post = self.posts[indexPath.row]
//        
//        if let imgUrl = NSURL(string: post.imageUrl) {
//            cell.postImageView.af_setImageWithURL(imgUrl)
//        }
//        cell.postTitleLabel.text = post.title
//        cell.postAuthorLabel.text = post.scholarName
        
        cell.postImageView.image = self.exampleImages[indexPath.item]
        cell.postDateLabel.text = self.exampleDates[indexPath.item]
        cell.postTitleLabel.text = self.exampleTitles[indexPath.item]
        cell.postAuthorLabel.text = self.exampleAuthors[indexPath.item]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.bounds.width/16*9
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
