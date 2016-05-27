//
//  AlumniViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 13.04.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ChatViewController: JSQMessagesViewController {
    private var messageReference: FIRDatabaseReference!
    private var messages = [JSQMessage]()
    private var outgoingBubbleImageView: JSQMessagesBubbleImage!
    private var incomingBubbleImageView: JSQMessagesBubbleImage!
    private var usersTypingQuery: FIRDatabaseQuery!
    private var userIsTypingRef: FIRDatabaseReference!
    private var localTyping = false
    private var isTyping: Bool {
        get {
            return self.localTyping
        }
        set {
            self.localTyping = newValue
            self.userIsTypingRef.setValue(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageReference = FIRDatabase.database().reference().child("messages")
        self.senderId = FIRAuth.auth()?.currentUser?.uid ?? "unknown"
        self.senderDisplayName = "Andrew Walker"
        
        self.styleUI()
        self.finishReceivingMessage()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.observeMessages()
        self.observeTyping()
    }
    
    // MARK: - UI
    
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
    
    // MARK: - Private functions
    
    private func observeTyping() {
        let typingIndicatorRef = self.messageReference.child("typingIndicator")
        self.userIsTypingRef = typingIndicatorRef.child(self.senderId)
        self.userIsTypingRef.onDisconnectRemoveValue()
        
        usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqualToValue(true)
        usersTypingQuery.observeEventType(.Value) { (data: FIRDataSnapshot!) in
            if data.childrenCount == 1 && self.isTyping {
                return
            }
            
            self.showTypingIndicator = data.childrenCount > 0
            self.scrollToBottomAnimated(true)
        }
    }
    
    private func addMessage(id: String, text: String) {
        let message = JSQMessage(senderId: id, displayName: "Andrew Walker", text: text)
        self.messages.append(message)
    }
    
    private func observeMessages() {
        let messagesQuery = self.messageReference.queryLimitedToLast(25)
        messagesQuery.observeEventType(.ChildAdded, withBlock: { snapshot in
            let id = snapshot.value!["senderId"] as! String
            let text = snapshot.value!["text"] as! String
            
            self.addMessage(id, text: text)
            self.finishReceivingMessage()
        })
    }
    
    // MARK: - JSQMessagesViewController
    
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
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        let message = self.messages[indexPath.item]
        
        if message.senderId == self.senderId {
            cell.textView!.textColor = UIColor.whiteColor()
        } else {
            cell.textView!.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let itemRef = self.messageReference.childByAutoId()
        let messageItem = ["text": text, "senderId": senderId]
        itemRef.setValue(messageItem)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        self.finishSendingMessage()
        self.isTyping = false
    }
    
    override func textViewDidChange(textView: UITextView) {
        super.textViewDidChange(textView)
        
        self.isTyping = textView.text != ""
    }
}