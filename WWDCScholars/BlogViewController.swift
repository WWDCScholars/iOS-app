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
        
        let testPost1 = BlogPost()
        testPost1.id = "56fc25ee5840978d849822b3"
        testPost1.scholarName = "Andrew Walker"
        testPost1.email = "me@andrewnwalker.com"
        testPost1.title = "Preparing for WWDC"
        testPost1.createdAt = NSDate()
        testPost1.updatedAt = NSDate()
        testPost1.imageUrl = "http://www.blogcdn.com/www.engadget.com/media/2013/06/wwdc2013-floor.jpg"
        testPost1.scholarLink = ""
        testPost1.tags = ["Travel", "Events"]
        testPost1.videoLink = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
        testPost1.content = "<html><head><title>Preparing for WWDC</title><h1>How to View the Source of This Page</h1><p>If you go to your web browser's View menu, you will see an option that allows you to see the source code behind a web page.</p><p>When the web was first taking off this was a very popular way for people to learn how web pages had been built.</p><img src='http://www.blogcdn.com/www.engadget.com/media/2013/06/wwdc2013-floor.jpg'/><p>Today, people still often view the source of pages to learn how a web page has been built.</p><h1>How to View the Source of This Page</h1><p>If you go to your web browser's View menu, you will see an option that allows you to see the source code behind a web page.</p><p>When the web was first taking off this was a very popular way for people to learn how web pages had been built.</p><img src='http://www.blogcdn.com/www.engadget.com/media/2013/06/wwdc2013-floor.jpg'/><p>Today, people still often view the source of pages to learn how a web page has been built.</p></body></html>"
        
        let testPost2 = BlogPost()
        testPost2.id = "56fc24dc5840978d849822b2"
        testPost2.scholarName = "Oliver Binns"
        testPost2.email = "me@andrewnwalker.com"
        testPost2.title = "Tips for Making the Most of Your Trip"
        testPost2.createdAt = NSDate()
        testPost2.updatedAt = NSDate()
        testPost2.imageUrl = "http://www.sanfrancisco.travel/sites/sftraveldev.prod.acquia-sites.com/files/SanFrancisco_0.jpg"
        testPost2.scholarLink = ""
        testPost2.tags = ["Travel", "Events", "Tips"]
        testPost2.videoLink = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
        testPost2.content = "<html><head><title>Text</title></head><body><h1>The Story in the Book</h1><h2>Chapter 1</h2><img src=\"https://www.fragomen.com/sites/default/files/styles/xl_image/public/portal/photos/San-Francisco_Hero.jpg?itok=CY70ppTH\"<p>Molly had been staring out of her window for about an hour now. On her desk, lying between the copies of <i>Nature</i>, <i>New Scientist</i>, and all the other scientific journals her work had appeared in, was a well thumbed copy of <cite>On The Road</cite>. It had been Molly's favourite book since college, and the longer she spent in these four walls the more she felt she needed to be free.</p><img src='https://pbs.twimg.com/profile_images/616542814319415296/McCTpH_E.jpg'/><p>She had spent the last ten years in this room, sitting under a poster with an Oscar Wilde quote proclaiming that <q>Work is the refuge of people who have nothing better to do</q>. Although many considered her pioneering work, unraveling the secrets of the llama <abbr title=\"Deoxyribonucleic acid\">DNA</abbr>, to be an outstanding achievement, Molly <em>did</em> think she had something better to do.</p></body></html>"
        
        let testPost3 = BlogPost()
        testPost3.id = "56fc3b1ba5ac14970921ad78"
        testPost3.scholarName = "Sam Eckert"
        testPost3.email = "me@andrewnwalker.com"
        testPost3.title = "The Labs and Sessions You Should Be Attending"
        testPost3.createdAt = NSDate()
        testPost3.updatedAt = NSDate()
        testPost3.imageUrl = "https://devimages.apple.com.edgekey.net/wwdc/images/wwdc16-schedule-sessions.jpg"
        testPost3.scholarLink = ""
        testPost3.tags = ["Events", "Tips"]
        testPost3.videoLink = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
        testPost3.content = "<html><head><title>Lists</title></head><body><h1>Scrambled Eggs</h1><p>Eggs are one of my favorite foods. Here is a recipe for deliciously rich scrambled eggs.</p><h2>Ingredients</h2><ul><li>2 eggs</li><li>1tbs butter</li><li>2tbs cream</li></ul><h2>Method</h2><ol><li>Melt butter in a frying pan over a medium heat</li><li>Gently mix the eggs and cream in a bowl</li><li>Once butter has melted add cream and eggs</li><li>Using a spatula fold the eggs from the edge of the pan to the center every 20 seconds (as if you are making an omelette)</li><li>When the eggs are still moist remove from the heat (it will continue to cook on the plate until served)</li></ol></body></html>"
        
        let testPost4 = BlogPost()
        testPost4.id = "56fc3d96a5ac14970921ad7a"
        testPost4.scholarName = "Michie Ang"
        testPost4.email = "veryhappymichie@gmail.com"
        testPost4.title = "Caturday"
        testPost4.createdAt = NSDate()
        testPost4.updatedAt = NSDate()
        testPost4.imageUrl = "http://m-static.flikie.com/ImageData/WallPapers/bf74e98693fa423e8dc6c3c48b113e89.jpg"
        testPost4.scholarLink = ""
        testPost4.tags = ["Cats", "Saturday"]
        testPost4.videoLink = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
        testPost4.content = "<html><head><title>Caturday!</title></head><body><h1>This Cat Looks Grumpy</h1><img src='https://pbs.twimg.com/profile_images/616542814319415296/McCTpH_E.jpg'/><p>Yup, you are right. It looks grumpy enough. But that cat of yours looks even grumpier. </p></p><img src='http://cdn.grumpycats.com/wp-content/uploads/2016/02/12654647_974282002607537_7798179861389974677_n-758x758.jpg'/><p>Yup, my cat is the grummpiest of them all. Look a it's ferocious eyes.</p><h1>This cat Looks Cute</h1><img src='http://m-static.flikie.com/ImageData/WallPapers/bf74e98693fa423e8dc6c3c48b113e89.jpg'/><p>Yup! It looks like it will pass the cuteness meter.</p><p>Today, people still love cats whether grumpy or not. They just love them. Happy Caturday!</p></body></html>"

        
        self.testPosts.append(testPost1)
        self.testPosts.append(testPost2)
        self.testPosts.append(testPost3)
        self.testPosts.append(testPost4)
        
        self.styleUI()
        self.configureUI()
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
    
    private func configureUI() {
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
        cell.postDateLabel.text = DateManager.shortDateStringFromDate(post.createdAt)
        cell.postTitleLabel.text = post.title
        
        if let imgUrl = NSURL(string: post.imageUrl) {
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
        
        let post = self.testPosts[indexPath.item]
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
