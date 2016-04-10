//
//  ScholarsTabBarViewController.swift
//  WWDCScholars
//
//  Created by Sam Eckert on 09.04.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit
import AVFoundation

class ScholarsTabBarViewController: UITabBarController {

    var tapSoundEffect: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBar.tintColor = UIColor.scholarsPurpleColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        let path = NSBundle.mainBundle().pathForResource("tabBarDidSelectItem.m4a", ofType: nil)!
        let url = NSURL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOfURL: url)
            tapSoundEffect = sound
            tapSoundEffect.volume = 0.1
            sound.play()
        } catch {
            // Couldn't load file :(
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
