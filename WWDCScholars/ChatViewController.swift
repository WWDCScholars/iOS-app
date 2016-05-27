//
//  AlumniViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 13.04.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: JSQMessagesViewController {
    private var ref: FIRDatabaseReference!
    private var messages = [JSQMessage]()
    private var outgoingBubbleImageView: JSQMessagesBubbleImage!
    private var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderId = FIRAuth.auth()?.currentUser?.uid
        self.senderDisplayName = "Andrew Walker"
        
        self.styleUI()
        
        self.addMessage("foo", text: "Hey!")
        // messages sent from local sender
        self.addMessage(senderId, text: "Yo!")
        self.addMessage(senderId, text: "Test Message")
        // animates the receiving of a new message on the view
        self.finishReceivingMessage()
    }
    
    // MARK: - UI
    
    private func addMessage(id: String, text: String) {
        let message = JSQMessage(senderId: id, displayName: "Andrew Walker", text: text)
        self.messages.append(message)
    }
    
    private func styleUI() {
        self.title = "Chat"
        
        self.collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        let factory = JSQMessagesBubbleImageFactory()
        self.outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(UIColor.scholarsPurpleColor())
        self.incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.messages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = self.messages[indexPath.item]
        
        if message.senderId == self.senderId {
            return self.outgoingBubbleImageView
        } else {
            return self.incomingBubbleImageView
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
}