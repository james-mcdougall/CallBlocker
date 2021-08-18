//
//  CallsViewController.swift
//  CallBlocker
//
//  Created by James McDougall on 8/18/21.
//

import UIKit

class CallsViewController: UIViewController {

    //MARK: IBOutlets -
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    @IBOutlet weak var buttonFour: UIButton!
    @IBOutlet weak var buttonFive: UIButton!
    @IBOutlet weak var buttonSix: UIButton!
    @IBOutlet weak var buttonSeven: UIButton!
    @IBOutlet weak var buttonEight: UIButton!
    @IBOutlet weak var buttonNine: UIButton!
    @IBOutlet weak var buttonZero: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var poundButton: UIButton!
    
    
    
	@IBOutlet weak var blockButton: UIButton!
	@IBOutlet weak var callButton: UIButton!
    
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
        customButtons.dullRedCircleButton(button: buttonZero)
        customButtons.dullRedCircleButton(button: buttonOne)
        customButtons.dullRedCircleButton(button: buttonTwo)
        customButtons.dullRedCircleButton(button: buttonThree)
        customButtons.dullRedCircleButton(button: buttonFour)
        customButtons.dullRedCircleButton(button: buttonFive)
        customButtons.dullRedCircleButton(button: buttonSix)
        customButtons.dullRedCircleButton(button: buttonSeven)
        customButtons.dullRedCircleButton(button: buttonEight)
        customButtons.dullRedCircleButton(button: buttonNine)
        customButtons.dullRedCircleButton(button: starButton)
        customButtons.dullRedCircleButton(button: poundButton)
        
        customButtons.solidPillButton(button: callButton)
		customButtons.solidPillButton(button: blockButton)


        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Actions -
    @IBAction func dialButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("0 was tapped")
        case 1:
            print("1 was tapped")
        case 2:
            print("2 was tapped")
        case 3:
            print("3 was tapped")
        case 4:
            print("4 was tapped")
        case 5:
            print("5 was tapped")
        case 6:
            print("6 was tapped")
        case 7:
            print("7 was tapped")
        case 8:
            print("8 was tapped")
        case 9:
            print("9 was tapped")
        case 10:
            print("* was tapped")
        case 11:
            print("# was tapped")
        default:
            print("No buttons were tapped")
        }
    }
    
    @IBAction func callButtonTapped(_ sender: UIButton) {
        print("Call Button Tapped")
    }
    
}

//MARK: Extensions -
