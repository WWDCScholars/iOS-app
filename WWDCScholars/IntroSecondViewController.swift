//
//  IntroSecondViewController.swift
//  WWDCScholars
//
//  Created by Sam Eckert on 08.05.17.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import UIKit

class IntroSecondViewController: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    
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
        
        bodyLabel.text = "The misfits. The rebels. The troublemakers. The round pegs in the square holes. The ones who see things differently. We’re not fond of rules. And we have no respect for the status quo."
        bodyLabel.addTextSpacing(spacing: 0.4)
        
        // Button text and adaption
        backButton.setTitle("Back", for: .normal)
        nextButton.setTitle("Next", for: .normal)
        
        backButton.layer.cornerRadius = 10
        nextButton.layer.cornerRadius = 10
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
    }

    @IBAction func nextButtonAction(_ sender: Any) {
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
