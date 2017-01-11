//
//  AlumniViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 13.04.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit
import AdSupport
import Alamofire
import AlamofireImage

class ChatViewController: JSQMessagesViewController {
    @IBOutlet fileprivate weak var loadingContainerView: UIView!
    
    fileprivate var messageReference: FIRDatabaseReference!
    fileprivate var messages = [JSQMessage]()
    fileprivate var outgoingBubbleImageView: JSQMessagesBubbleImage!
    fileprivate var incomingBubbleImageView: JSQMessagesBubbleImage!
    fileprivate var outgoingGroupBubbleImageView: JSQMessagesBubbleImage!
    fileprivate var incomingGroupBubbleImageView: JSQMessagesBubbleImage!
    fileprivate var usersTypingQuery: FIRDatabaseQuery!
    fileprivate var userIsTypingRef: FIRDatabaseReference!
    fileprivate var localTyping = false
    fileprivate var loadingViewController: LoadingViewController!
    fileprivate var messageObserverHandle: UInt?
//    private var isTyping: Bool {
//        get {
//            return self.localTyping
//        }
//        set {
//            self.localTyping = newValue
//            self.userIsTypingRef.setValue(newValue)
//        }
//    }
    
    var chatItem: ChatRoom!
    var initialLoad = true
    
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
        self.loadOldMessages()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.observeTyping()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !UserKit.sharedInstance.isLoggedIn {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: ScholarDetailViewController()) {
            let destinationViewController = segue.destination as! ScholarDetailViewController
            destinationViewController.setScholar(sender as! String)
        } else if segue.identifier == String(describing: LoadingViewController()) {
            self.loadingViewController = segue.destination as! LoadingViewController
        }
    }
    
    // MARK: - UI
    
    fileprivate func styleUI() {
        self.title = self.chatItem.name
        
        self.loadingContainerView.isHidden = false
        self.loadingViewController.startAnimating()
        
        self.automaticallyScrollsToMostRecentMessage = true
        self.collectionView.collectionViewLayout.springinessEnabled = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.collectionViewLayout.springResistanceFactor = 3000
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        self.inputToolbar.contentView.leftBarButtonItem = nil
        
        let factory = JSQMessagesBubbleImageFactory()
        let taillessFactory = JSQMessagesBubbleImageFactory.init(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: UIEdgeInsets.zero)
        
        self.incomingGroupBubbleImageView = taillessFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        self.outgoingGroupBubbleImageView = taillessFactory?.outgoingMessagesBubbleImage(with: UIColor.scholarsPurpleColor())
        
        self.outgoingBubbleImageView = factory?.outgoingMessagesBubbleImage(with: UIColor.scholarsPurpleColor())
        self.incomingBubbleImageView = factory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        
        self.inputToolbar.contentView.rightBarButtonItem.setTitleColor(UIColor.scholarsPurpleColor(), for: UIControlState())
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: - Private functions
    
    fileprivate func observeTyping() {
//        let typingIndicatorRef = self.messageReference.child("typingIndicator")
//        self.userIsTypingRef = typingIndicatorRef.child(self.senderId)
//        self.userIsTypingRef.onDisconnectRemoveValue()
//        
//        usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqualToValue(true)
//        usersTypingQuery.observeEventType(.Value) { (data: FIRDataSnapshot!) in
//            if data.childrenCount == 1 && self.isTyping {
//                return
//            }
//            
//            self.showTypingIndicator = data.childrenCount > 0
//            self.scrollToBottomAnimated(true)
//        }
    }
    
    fileprivate func addMessage(_ id: String, text: String, date: Date) {
        if let scholar = DatabaseManager.sharedInstance.scholarForId(id){
            let message = JSQMessage(senderId: id, senderDisplayName: scholar.fullName, date: date, text: text)
            self.messages.append(message!)
        } else {
            //todo: reload scholars if scholar is missing in db
            print ("addMessage -- Uhoh! no scholar found in db with id \(id)")
        }
    }
    
    fileprivate func loadOldMessages() {
        self.messages = []
        self.collectionView.collectionViewLayout.springinessEnabled = false

        let messagesQuery = self.messageReference.queryOrdered(byChild: "dateSent").queryLimited(toLast: 50)//.queryStartingAtValue(self.messages[self.messages.count-1].date.timeIntervalSince1970, childKey: "dateSent")
        messagesQuery.observeSingleEvent(of: .value, with: { snapshot in
            for snapshot in snapshot.children {
            if let id = (snapshot as AnyObject).value!["senderId"] as? String, let text = (snapshot as AnyObject).value!["text"] as? String, let dateInt = (snapshot as AnyObject).value!["dateSent"] as? TimeInterval  {
                self.addMessage(id, text: text, date: Date(timeIntervalSince1970: dateInt))
            }
            }
            self.observeMessages()
            
            self.finishReceivingMessage(animated: false)
            self.collectionView.collectionViewLayout.springinessEnabled = true
        })
    }
    
    fileprivate func observeMessages() {
        let messagesQuery = self.messageReference.queryOrdered(byChild: "dateSent").queryLimited(toLast: 1)//.queryStartingAtValue(self.messages[self.messages.count-1].date.timeIntervalSince1970, childKey: "dateSent")
        self.messageObserverHandle = messagesQuery.observe(.childAdded, with: { snapshot in
            if self.initialLoad {
                self.initialLoad = false
                return
            }
            if let id = snapshot.value!["senderId"] as? String, let text = snapshot.value!["text"] as? String, let dateInt = snapshot.value!["dateSent"] as? TimeInterval  {
                self.addMessage(id, text: text, date: Date(timeIntervalSince1970: dateInt))
                
                if id != self.senderId {
                    JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
                }
                
                self.finishReceivingMessage()
            }
        })
    }
    
    // MARK: - JSQMessagesViewController
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return self.messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
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
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = self.messages[indexPath.row]
        
        if indexPath.item - 1 > 0 {
            let prevMessage = self.messages[indexPath.item - 1]
            if prevMessage.senderId == message.senderId {
                return nil
            }
        }
        
        if let scholar = DatabaseManager.sharedInstance.scholarForId(message.senderId) {
            return JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: scholar.initials, backgroundColor: UIColor.transparentScholarsPurpleColor(), textColor: UIColor.white, font: UIFont.systemFont(ofSize: 15), diameter: 50)
        } else {
            return JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: "UK", backgroundColor: UIColor.transparentScholarsPurpleColor(), textColor: UIColor.white, font: UIFont.systemFont(ofSize: 15), diameter: 50)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
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
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        
        if indexPath.item - 1 > 0 {
            let prevMessage = self.messages[indexPath.item - 1]
            if prevMessage.senderId == message.senderId {
                return 0
            }
        }
        
        return (message.senderId == self.senderId) ? 0 : kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0, 45, 0, 0)
        
        let message = self.messages[indexPath.item]
        
        if message.senderId != self.senderId {
            if indexPath.item + 1 < messages.count {
                let nextMessage = self.messages[indexPath.item + 1]
                if nextMessage.senderId == message.senderId {
                    cell.avatarImageView!.image = nil
                } else {
                    if let scholar = DatabaseManager.sharedInstance.scholarForId(message.senderId){
                        if let imageUrl = Foundation.URL(string: scholar.latestBatch.profilePic) {
                            let imageFilter = RoundedCornersFilter(radius: 50)
                            
                            cell.avatarImageView!.af_setImage(withURL: imageUrl, filter: imageFilter, imageTransition: .crossDissolve(0.25))
                        }
                    }
                }
            } else {
                if let scholar = DatabaseManager.sharedInstance.scholarForId(message.senderId){
                    if let imageUrl = Foundation.URL(string: scholar.latestBatch.profilePic) {
                        let imageFilter = RoundedCornersFilter(radius: 50)
                        
                        cell.avatarImageView!.af_setImage(withURL: imageUrl, filter: imageFilter, imageTransition: .crossDissolve(0.25))
                    }
                }
            }
        }
        
        cell.textView!.textColor = message.senderId == self.senderId ? UIColor.white : UIColor.black
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, at indexPath: IndexPath!) {
        let message = messages[indexPath.item]
        self.performSegue(withIdentifier: String(describing: ScholarDetailViewController()), sender: message.senderId)
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let itemRef = self.messageReference.childByAutoId()
        let messageItem = ["text": text, "senderId": senderId, "dateSent": Date().timeIntervalSince1970 ] as [String : Any]
        itemRef.setValue(messageItem)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        self.finishSendingMessage()
//        self.isTyping = false
    }
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        
//        self.isTyping = textView.text != ""
    }
}
