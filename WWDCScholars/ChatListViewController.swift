//
//  ChatListViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 03/06/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController, SignInDelegate {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var notLoggedInView: UIView!
    
    private var colors: [UIColor] = [.logoBlueColor(), .logoPinkColor(), .logoGreenColor(), .logoYellowColor(), .logoLightBlueColor(), .logoOrangeColor(), .logoPurpleColor()]
    
    private var chatItems = ChatRoom.getChatItems()
    private var currentIndex = NSIndexPath(forRow: 0, inSection: 0)
    private var registeredPeekView: UIViewControllerPreviewing?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        self.populateColors()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.notLoggedInView.hidden = UserKit.sharedInstance.isLoggedIn
        
        if self.traitCollection.forceTouchCapability == .Available && UserKit.sharedInstance.isLoggedIn {
            self.registeredPeekView = self.registerForPreviewingWithDelegate(self, sourceView: self.view)
        } else {
            if let peekView = self.registeredPeekView {
                self.unregisterForPreviewingWithContext(peekView)
            }
            
            self.registeredPeekView = nil
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == String(ChatViewController) {
            let destinationViewController = segue.destinationViewController as! ChatViewController
            
            if let indexPath = sender as? NSIndexPath {
                destinationViewController.chatItem = self.chatItems[indexPath.item]
            }
        }
    }
    
    // MARK: - Private functions
    
    private func styleUI() {
        self.title = "Chat"
    }
    
    private func populateColors() {
        if self.chatItems.count > self.colors.count {
            self.colors += self.colors
        }
    }
    
    private func showSignInModal() {
        let storyboard = UIStoryboard(name: "EditDetails", bundle: nil)
        let modalViewController = storyboard.instantiateViewControllerWithIdentifier("SignInVC") as! SignInViewController
        
        modalViewController.modalPresentationStyle = .OverCurrentContext
        modalViewController.delegate = self
        modalViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.view.window?.rootViewController?.view.window?.rootViewController!.presentViewController(modalViewController, animated: true, completion: nil)
    }
    
    // MARK: - Internal functions
    
    internal func userSignedIn() {
        self.notLoggedInView.hidden = UserKit.sharedInstance.isLoggedIn
        
        if self.traitCollection.forceTouchCapability == .Available && UserKit.sharedInstance.isLoggedIn {
            self.registeredPeekView = self.registerForPreviewingWithDelegate(self, sourceView: self.view)
        }
    }
    
    // MARK: IBActions
    
    @IBAction func logInButtonAction(sender: AnyObject) {
        self.showSignInModal()
    }
}

// MARK: - UITableViewDataSource

extension ChatListViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("chatTableViewCell", forIndexPath: indexPath) as! ChatTableViewCell
        cell.nameLabel.text = self.chatItems[indexPath.item].name
        cell.descriptionLabel.text = self.chatItems[indexPath.item].shortDescription
        cell.circleView.backgroundColor = self.colors[indexPath.item]
        
        cell.alpha = 0.0
        UIView.animateWithDuration(0.5) { 
            cell.alpha = 1.0
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88.0
    }
}

// MARK: - UITableViewDelegate

extension ChatListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.performSegueWithIdentifier(String(ChatViewController), sender: indexPath)
    }
}

// MARK: - UIViewControllerPreviewingDelegate

extension ChatListViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("chatViewController") as? ChatViewController
        let cellPosition = self.tableView.convertPoint(location, fromView: self.view)
        let cellIndex = self.tableView.indexPathForRowAtPoint(cellPosition)
        
        guard let previewViewController = viewController, indexPath = cellIndex, cell = self.tableView.cellForRowAtIndexPath(indexPath) else {
            return nil
        }
        
        let cellFrame = CGRect(origin: CGPoint(x: 0.0, y: cell.frame.origin.y + 8.0), size: CGSize(width: cell.frame.width, height: cell.frame.height - 8.0))
        
        previewViewController.chatItem = self.chatItems[indexPath.item]
        previewViewController.preferredContentSize = CGSize.zero
        previewingContext.sourceRect = self.view.convertRect(cellFrame, fromView: self.tableView)
        
        return previewViewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        self.showViewController(viewControllerToCommit, sender: self)
    }
}

