//
//  CallListViewController.swift
//  CallBlocker
//
//  Created by James McDougall on 8/23/21.
//

import UIKit
import CoreData
import CallKit
import CallerData
import OSLog

class CallListViewController: UIViewController {
	
	@IBOutlet weak var callerType: UISegmentedControl!
	@IBOutlet weak var tableView: UITableView!
	
	private var showBlocked: Bool {
		return callerType.selectedSegmentIndex == 1
	}
	
	let callerCell = "CallerCell"
	
	lazy private var callerData = CallerData()
	
	private var resultsController: NSFetchedResultsController<Caller>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource = self
		tableView.delegate = self
		resultsController.delegate = self
		loadData()
	}
	
	private func loadData() {
		navigationItem.title = showBlocked ? "Blocked":"ID"
		
		let fetchRequest:NSFetchRequest<Caller> = callerData.fetchRequest(blocked: showBlocked)
		
		resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: callerData.context, sectionNameKeyPath: nil, cacheName: nil)
		do {
			try resultsController.performFetch()
			tableView.reloadData()
		} catch {
			print("Failed to fetch data: \(error.localizedDescription)")
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let addEditVC = segue.destination as? AddEditViewController {
			addEditVC.isBlocked = showBlocked
			addEditVC.callerData = callerData
			if let cell = sender as? UITableViewCell,
			   let indexPath = tableView.indexPath(for: cell),
			   let caller = resultsController.fetchedObjects?[indexPath.row] {
				addEditVC.caller = caller
			}
		}
	}
	
	@IBAction func callerTypeChanged(_ sender: UISegmentedControl) {
		loadData()
	}
	
	@IBAction func reloadTapped(_ sender: UIButton) {
			CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: "me.wilko.CallKitTutorial.CallKitTutorialExtension", completionHandler: { (error) in
				if let error = error {
					print("Error reloading extension: \(error.localizedDescription)")
				}
			})
		}
}

extension CallListViewController: UITableViewDelegate {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.resultsController.sections?.count ?? 0
	}
}

extension CallListViewController: UITableViewDataSource {
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return resultsController.fetchedObjects?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let callCell = tableView.dequeueReusableCell(withIdentifier: callerCell, for: indexPath)
		let caller = resultsController.fetchedObjects![indexPath.row]
		
		callCell.textLabel?.text = caller.isBlocked ? String(caller.number) : caller.name ?? ""
		callCell.detailTextLabel?.text = caller.isBlocked ? "" : String(caller.number)
		
		return callCell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		switch editingStyle {
			case .delete:
				if let caller = resultsController.fetchedObjects?[indexPath.row] {
					caller.isRemoved = true
					caller.updatedDate = Date()
					self.callerData.saveContext()
				}
			default:
				break
		}
	}
}

extension ViewController: NSFetchedResultsControllerDelegate {
	
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		
		let newIndexPath: IndexPath? = newIndexPath != nil ? IndexPath(row: newIndexPath!.row, section: 0) : nil
		let currentIndexPath: IndexPath? = indexPath != nil ? IndexPath(row: indexPath!.row, section: 0) : nil
		
		switch type {
			case .insert:
				tableView.insertRows(at: [newIndexPath!], with: .automatic)
				
			case .delete:
				tableView.deleteRows(at: [currentIndexPath!], with: .fade)
				
			case .move:
				tableView.moveRow(at: currentIndexPath!, to: newIndexPath!)
				
			case .update:
				tableView.reloadRows(at: [currentIndexPath!], with: .automatic)
				
			@unknown default:
				fatalError()
		}
	}
	
	//3.  All changes have been delivered
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}
}
