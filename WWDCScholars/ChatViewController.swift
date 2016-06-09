//
//  AlumniViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 13.04.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit
import AdSupport

class ChatViewController: JSQMessagesViewController {
    @IBOutlet private weak var loadingContainerView: UIView!
    
    private var messageReference: FIRDatabaseReference!
    private var messages = [JSQMessage]()
    private var outgoingBubbleImageView: JSQMessagesBubbleImage!
    private var incomingBubbleImageView: JSQMessagesBubbleImage!
    private var outgoingGroupBubbleImageView: JSQMessagesBubbleImage!
    private var incomingGroupBubbleImageView: JSQMessagesBubbleImage!
    private var usersTypingQuery: FIRDatabaseQuery!
    private var userIsTypingRef: FIRDatabaseReference!
    private var localTyping = false
    private var loadingViewController: LoadingViewController!
    private var messageObserverHandle: UInt?
    private var isTyping: Bool {
        get {
            return self.localTyping
        }
        set {
            self.localTyping = newValue
            self.userIsTypingRef.setValue(newValue)
        }
    }
    
    var chatItem: ChatRoom!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UserKit.sharedInstance.isLoggedIn {
            return
        }
        
        self.messageReference = FIRDatabase.database().reference().child("messages").child(self.chatItem.identifier)
        
        self.senderId = "UNKNOWN"
        self.senderDisplayName = "*Not logged in*"
        
        if let ourScholar = UserKit.sharedInstance.loggedInScholar {
            self.senderId = UserKit.sharedInstance.scholarId ?? "unknown"
            self.senderDisplayName = ourScholar.fullName
        }
        
        self.styleUI()
        self.loadOldMessages(true)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.observeTyping()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !UserKit.sharedInstance.isLoggedIn {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == String(ScholarDetailViewController) {
            let destinationViewController = segue.destinationViewController as! ScholarDetailViewController
            destinationViewController.setScholar(sender as! String)
        } else if segue.identifier == String(LoadingViewController) {
            self.loadingViewController = segue.destinationViewController as! LoadingViewController
        }
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.title = self.chatItem.name
        
        self.loadingContainerView.hidden = false
        self.loadingViewController.startAnimating()
        
        self.automaticallyScrollsToMostRecentMessage = true
        self.collectionView.collectionViewLayout.springinessEnabled = true
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.collectionViewLayout.springResistanceFactor = 3000
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        self.inputToolbar.contentView.leftBarButtonItem = nil
        
        let factory = JSQMessagesBubbleImageFactory()
        let taillessFactory = JSQMessagesBubbleImageFactory.init(bubbleImage: UIImage.jsq_bubbleCompactTaillessImage(), capInsets: UIEdgeInsetsZero)
        
        self.incomingGroupBubbleImageView = taillessFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        self.outgoingGroupBubbleImageView = taillessFactory.outgoingMessagesBubbleImageWithColor(UIColor.scholarsPurpleColor())
        
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
    
    private func addMessage(id: String, text: String, date: NSDate) {
        if let scholar = DatabaseManager.sharedInstance.scholarForId(id){
            let message = JSQMessage(senderId: id, senderDisplayName: scholar.fullName, date: date, text: text)
            self.messages.append(message)
        } else {
            //todo: reload scholars if scholar is missing in db
            print ("addMessage -- Uhoh! no scholar found in db with id \(id)")
        }
    }
    
    private func loadOldMessages(startObserving: Bool = false) {
        self.messages = []
        
        self.observeMessages()
    }
    
    private func observeMessages() {
        let messagesQuery = self.messageReference.queryOrderedByChild("dateSent").queryLimitedToLast(50)//.queryStartingAtValue(self.messages[self.messages.count-1].date.timeIntervalSince1970, childKey: "dateSent")
        self.messageObserverHandle = messagesQuery.observeEventType(.ChildAdded, withBlock: { snapshot in
            if let id = snapshot.value!["senderId"] as? String, let text = snapshot.value!["text"] as? String, let dateInt = snapshot.value!["dateSent"] as? NSTimeInterval  {
                self.addMessage(id, text: text, date: NSDate(timeIntervalSince1970: dateInt))
                
                if id != self.senderId {
                    JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
                }
                
                self.finishReceivingMessage()
            }
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
        
        if indexPath.item + 1 < self.messages.count {
            let nextMessage = self.messages[indexPath.item + 1]
            if nextMessage.senderId == message.senderId {
                if message.senderId == self.senderId {
                    return self.outgoingGroupBubbleImageView
                } else {
                    return self.incomingGroupBubbleImageView
                }
            }
        }
        
        if message.senderId == self.senderId {
            return self.outgoingBubbleImageView
        } else {
            return self.incomingBubbleImageView
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = self.messages[indexPath.row]
        
        if indexPath.item - 1 > 0 {
            let prevMessage = self.messages[indexPath.item - 1]
            if prevMessage.senderId == message.senderId {
                return nil
            }
        }
        
        if let scholar = DatabaseManager.sharedInstance.scholarForId(message.senderId) {
            return JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(scholar.initials, backgroundColor: UIColor.transparentScholarsPurpleColor(), textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(15), diameter: 50)
        } else {
            return JSQMessagesAvatarImageFactory.avatarImageWithUserInitials("UK", backgroundColor: UIColor.transparentScholarsPurpleColor(), textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(15), diameter: 50)
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        
        if indexPath.item - 1 > 0 {
            let prevMessage = self.messages[indexPath.item - 1]
            if prevMessage.senderId == message.senderId {
                return nil
            }
        }
        
        if let scholar = DatabaseManager.sharedInstance.scholarForId(message.senderId){
            return NSAttributedString(string: scholar.fullName)
        }
        
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        
        if indexPath.item - 1 > 0 {
            let prevMessage = self.messages[indexPath.item - 1]
            if prevMessage.senderId == message.senderId {
                return 0
            }
        }
        
        return (message.senderId == self.senderId) ? 0 : kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0, 45, 0, 0)
        
        let message = self.messages[indexPath.item]
        
        if message.senderId != self.senderId {
            if indexPath.item + 1 < messages.count {
                let nextMessage = self.messages[indexPath.item + 1]
                if nextMessage.senderId == message.senderId {
                    cell.avatarImageView!.image = nil
                } else {
                    if let scholar = DatabaseManager.sharedInstance.scholarForId(message.senderId){
                        if let imageUrl = NSURL(string: scholar.latestBatch.profilePic) {
                            let imageFilter = RoundedCornersFilter(radius: 50)
                            
                            cell.avatarImageView!.af_setImageWithURL(imageUrl, filter: imageFilter, imageTransition: .CrossDissolve(0.25))
                        }
                    }
                }
            } else {
                if let scholar = DatabaseManager.sharedInstance.scholarForId(message.senderId){
                    if let imageUrl = NSURL(string: scholar.latestBatch.profilePic) {
                        let imageFilter = RoundedCornersFilter(radius: 50)
                        
                        cell.avatarImageView!.af_setImageWithURL(imageUrl, filter: imageFilter, imageTransition: .CrossDissolve(0.25))
                    }
                }
            }
        }
        
        cell.textView!.textColor = message.senderId == self.senderId ? UIColor.whiteColor() : UIColor.blackColor()
        
        return cell
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, atIndexPath indexPath: NSIndexPath!) {
        let message = messages[indexPath.item]
        self.performSegueWithIdentifier(String(ScholarDetailViewController), sender: message.senderId)
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let itemRef = self.messageReference.childByAutoId()
        let messageItem = ["text": text, "senderId": senderId, "dateSent": NSDate().timeIntervalSince1970 ]
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
