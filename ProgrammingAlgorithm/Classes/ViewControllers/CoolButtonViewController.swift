//
//  CoolButtonViewController.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 21/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import UIKit

class CoolButtonViewController: UIViewController {

    
    @IBOutlet weak var coolButton: CoolButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func hueValueChanged(_ sender: Any) {
        guard let slider = sender as? UISlider else { return }
        coolButton.hue = CGFloat(slider.value)
    }
    
    @IBAction func saturationValueChanged(_ sender: Any) {
        guard let slider = sender as? UISlider else { return }
        coolButton.saturation = CGFloat(slider.value)
    }
    
    @IBAction func brightnessValueChanged(_ sender: Any) {
        guard let slider = sender as? UISlider else { return }
        coolButton.brightness = CGFloat(slider.value)
    }
    
}
