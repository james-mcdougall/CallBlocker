//
//  MainViewController.swift
//  CallBlocker
//
//  Created by James McDougall on 8/17/21.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: IBOutlets -
    @IBOutlet weak var getStartedButton: UIButton!
    
    //MARK: UI Properties -
    let customButtons = CustomButtons()
    
    //MARK: Functional Properties -
    

    //MARK: App Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: UI Configuration -
    func configureUI() {
        customButtons.solidPillButton(button: getStartedButton)
    }
}
