//
//  ChatListViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 03/06/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var chatItems = ChatRoom.getChatItems()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == String(ChatViewController) {
            let destinationViewController = segue.destinationViewController as! ChatViewController
            
            if let indexPath = sender as? NSIndexPath {
                destinationViewController.chatIdentifier = self.chatItems[indexPath.item].identifier
            }
        }
    }
}

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

extension ChatListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(String(ChatViewController), sender: indexPath)
    }
}
