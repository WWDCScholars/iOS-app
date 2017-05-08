//
//  IntroFirstViewController.swift
//  WWDCScholars
//
//  Created by Sam Eckert on 08.05.17.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import UIKit

class IntroFirstViewController: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var getStartedButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
        // Label text and spacing
        headerLabel.text = "We are the Crazy Ones."
        headerLabel.addTextSpacing(spacing: 0.8)
        
        // Button text and adaption
        getStartedButton.setTitle("Get Started", for: .normal)
        getStartedButton.layer.cornerRadius = 10
    }

    
    @IBAction func getStartedButtonAction(_ sender: Any) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
