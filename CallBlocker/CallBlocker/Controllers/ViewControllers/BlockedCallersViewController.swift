//
//  BlockedCallersViewController.swift
//  CallBlocker
//
//  Created by James McDougall on 8/18/21.
//

import UIKit
import CallKit
import CallerData

class BlockedCallersViewController: UIViewController {
    
    //MARK: IBOutlets -
    @IBOutlet weak var callerName: UITextField!
    @IBOutlet weak var callerNumber: UITextField!
    @IBOutlet weak var amountOfNumbers: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //MARK: UI Properties -
    
    //MARK: Functional Properties -
    
    var caller: Caller? {
        didSet {
            updateUI()
        }
    }
    
    var callerData: CallerData!
    
    var isBlocked = false
    
    //MARK: App Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        callerName.delegate = self
        callerNumber.delegate = self
        title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUI()
    }
    
    //MARK: UI Configuration -
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK: Helper Methods -
    private func updateUI() {
        
        guard let caller = caller,
              let callerName = callerName,
              let callerNumber = callerNumber else {
            return
        }
        
        callerName.text = caller.name
        callerNumber.text = caller.number != 0 ? String(caller.number):""
        navigationItem.title = caller.name
        
        updateSaveButton()
        
    }
    
    private func updateSaveButton() {
        self.saveButton.isEnabled = false
        guard let name = callerName.text,
              let number = callerNumber.text else {
            return
        }
        saveButton.isEnabled = !(name.isEmpty || number.isEmpty)
    }
    
    //MARK: Actions -
    @IBAction func textChanged(_ sender: UITextField) {
        updateSaveButton()
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        if let numberText = callerNumber.text,
           let number = Int64(numberText)  {
            let caller = self.caller ?? Caller(context: self.callerData.context)
            caller.name = callerName.text
            caller.number  = number
            caller.isBlocked = isBlocked
            caller.isRemoved = false
            caller.updatedDate = Date()
            self.callerData.saveContext()
        }
        dismiss(animated: true, completion: nil)
    }
}

//MARK: Extensions -

extension BlockedCallersViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
              let textRange = Range(range, in: text) else {
            return false
        }
        let updatedText = text.replacingCharacters(in: textRange,
                                                   with: string)
        if textField == self.callerNumber {
            if updatedText.isEmpty {
                return true
            }
            if Int64(updatedText) == nil {
                return false
            }
        } else if textField == callerName {
            self.navigationItem.title = updatedText
        }
        return true
    }
}
