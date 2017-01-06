//
//  ChatListViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 03/06/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController, SignInDelegate {
    @IBOutlet  weak var tableView: UITableView!
    @IBOutlet  weak var notLoggedInView: UIView!
    
     var colors: [UIColor] = [.logoBlueColor(), .logoPinkColor(), .logoGreenColor(), .logoYellowColor(), .logoLightBlueColor(), .logoOrangeColor(), .logoPurpleColor()]
    
     var chatItems = ChatRoom.getChatItems()
     var currentIndex = IndexPath(row: 0, section: 0)
     var registeredPeekView: UIViewControllerPreviewing?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        self.populateColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.notLoggedInView.isHidden = UserKit.sharedInstance.isLoggedIn
        
        if self.traitCollection.forceTouchCapability == .available && UserKit.sharedInstance.isLoggedIn {
            self.registeredPeekView = self.registerForPreviewing(with: self, sourceView: self.view)
        } else {
            if let peekView = self.registeredPeekView {
                self.unregisterForPreviewing(withContext: peekView)
            }
            
            self.registeredPeekView = nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: ChatViewController()) {
            let destinationViewController = segue.destination as! ChatViewController
            
            if let indexPath = sender as? IndexPath {
                destinationViewController.chatItem = self.chatItems[indexPath.item]
            }
        }
    }
    
    // MARK: - Private functions
    
     func styleUI() {
        self.title = "Chat"
    }
    
     func populateColors() {
        if self.chatItems.count > self.colors.count {
            self.colors += self.colors
        }
    }
    
     func showSignInModal() {
        let storyboard = UIStoryboard(name: "EditDetails", bundle: nil)
        let modalViewController = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
        
        modalViewController.modalPresentationStyle = .overCurrentContext
        modalViewController.delegate = self
        modalViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.view.window?.rootViewController?.view.window?.rootViewController!.present(modalViewController, animated: true, completion: nil)
    }
    
    // MARK: - Internal functions
    
    internal func userSignedIn() {
        self.notLoggedInView.isHidden = UserKit.sharedInstance.isLoggedIn
        
        if self.traitCollection.forceTouchCapability == .available && UserKit.sharedInstance.isLoggedIn {
            self.registeredPeekView = self.registerForPreviewing(with: self, sourceView: self.view)
        }
    }
    
    // MARK: IBActions
    
    @IBAction func logInButtonAction(_ sender: AnyObject) {
        self.showSignInModal()
    }
}

// MARK: - UITableViewDataSource

extension ChatListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "chatTableViewCell", for: indexPath) as! ChatTableViewCell
        cell.nameLabel.text = self.chatItems[indexPath.item].name
        cell.descriptionLabel.text = self.chatItems[indexPath.item].shortDescription
        cell.circleView.backgroundColor = self.colors[indexPath.item]
        
        cell.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: { 
            cell.alpha = 1.0
        }) 
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
}

// MARK: - UITableViewDelegate

extension ChatListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: String(describing: ChatViewController()), sender: indexPath)
    }
}

// MARK: - UIViewControllerPreviewingDelegate

extension ChatListViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "chatViewController") as? ChatViewController
        let cellPosition = self.tableView.convert(location, from: self.view)
        let cellIndex = self.tableView.indexPathForRow(at: cellPosition)
        
        guard let previewViewController = viewController, let indexPath = cellIndex, let cell = self.tableView.cellForRow(at: indexPath) else {
            return nil
        }
        
        let cellFrame = CGRect(origin: CGPoint(x: 0.0, y: cell.frame.origin.y + 8.0), size: CGSize(width: cell.frame.width, height: cell.frame.height - 8.0))
        
        previewViewController.chatItem = self.chatItems[indexPath.item]
        previewViewController.preferredContentSize = CGSize.zero
        previewingContext.sourceRect = self.view.convert(cellFrame, from: self.tableView)
        
        return previewViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.show(viewControllerToCommit, sender: self)
    }
}

