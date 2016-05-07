//
//  BlogViewController.swift
//  WWDCScholars
//
//  Created by Sam Eckert on 07.04.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class BlogViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [BlogPost]!
    
    let exampleImages = [UIImage(named: "example1"),
                         UIImage(named: "example2"),
                         UIImage(named: "example3")]
    
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
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

extension BlogViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("blogPostTableViewCell") as! BlogPostTableViewCell
        
        let post = self.posts[indexPath.row]
        
        if let imgUrl = NSURL(string: post.imageUrl) {
            cell.postImageView.af_setImageWithURL(imgUrl)
        }
        cell.postTitleLabel.text = post.title
        cell.postAuthorLabel.text = post.scholarName
        
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
