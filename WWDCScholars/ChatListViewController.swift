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
    @IBAction func logInButtonAction(sender: AnyObject) {
        showSignInModal()
    }
    
    private var chatItems = ChatRoom.getChatItems()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.traitCollection.forceTouchCapability == .Available {
            self.registerForPreviewingWithDelegate(self, sourceView: self.view)
        }
        
        self.styleUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.notLoggedInView.hidden = UserKit.sharedInstance.isLoggedIn
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
        
        return cell
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
        
        previewViewController.chatItem = self.chatItems[indexPath.item]
        previewViewController.preferredContentSize = CGSize.zero
        previewingContext.sourceRect = self.view.convertRect(cell.frame, fromView: self.tableView)
        
        return previewViewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        self.showViewController(viewControllerToCommit, sender: self)
    }
}

