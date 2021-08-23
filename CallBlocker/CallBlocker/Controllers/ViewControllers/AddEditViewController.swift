//
//  AddEditViewController.swift
//  CallBlocker
//
//  Created by James McDougall on 8/23/21.
//

import UIKit
import CoreData
import CallKit
import CallerData
import OSLog

class AddEditViewController: UIViewController {
	
	@IBOutlet weak var callerName: UITextField!
	@IBOutlet weak var callerNumber: UITextField!
	@IBOutlet weak var amountOfNumberstoBlock: UITextField!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	
	var caller: Caller? {
		didSet {
			updateUI()
		}
	}
	
	var callerData: CallerData!
	
	var isBlocked = false
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		updateUI()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		callerName.delegate = self
		callerNumber.delegate = self
		title = ""
	}
	
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
		saveButton.isEnabled = false
		guard let name = callerName.text,
			  let number = callerNumber.text else {
			return
		}
		saveButton.isEnabled = !(name.isEmpty || number.isEmpty)
	}
	
	@IBAction func textChanged(_ sender: UITextField) {
		updateSaveButton()
	}
	
	@IBAction func generateNumbersButtonTapped(_ sender: UIButton) {
		
	}
	
	@IBAction func saveTapped(_ sender: UIBarButtonItem) {
			if let numberText = callerNumber.text,
				let number = Int64(numberText)  {
				let caller = self.caller ?? Caller(context: callerData.context)
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

extension AddEditViewController: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		guard let text = textField.text,
			  let textRange = Range(range, in: text) else {
			return false
		}
		let updatedText = text.replacingCharacters(in: textRange,
												   with: string)
		if textField == callerNumber {
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
