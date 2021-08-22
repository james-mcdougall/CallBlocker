//
//  CallsViewController.swift
//  CallBlocker
//
//  Created by James McDougall on 8/18/21.
//

import UIKit
import CoreData
import CallKit
import CallerData

class CallsViewController: UIViewController {
    
    @IBOutlet weak var callerType: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    //MARK: UI Properties -
    
    //MARK: Functional Properties -
    let callerCell = "CallerCell"
    
    private var showBlocked: Bool {
        return self.callerType.selectedSegmentIndex == 1
    }
    
    lazy private var callerData = CallerData()
    
    private var resultsController: NSFetchedResultsController<Caller>!
    //MARK: App Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        resultsController.delegate = self
        loadData()
    }
    
    private func loadData() {
        self.navigationItem.title = self.showBlocked ? "Blocked":"ID"
        
        let fetchRequest:NSFetchRequest<Caller> = self.callerData.fetchRequest(blocked: self.showBlocked)
        
        self.resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.callerData.context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try self.resultsController.performFetch()
            self.tableView.reloadData()
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
        }
    }
    
    //MARK: Actions -
    
    @IBAction func callerTypeChanged(_ sender: UISegmentedControl) {
        self.loadData()
    }
    
    
}
//MARK: Extensions -

extension CallsViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.resultsController.sections?.count ?? 0
    }
}

extension CallsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: callerCell, for: indexPath)
        let caller = resultsController.fetchedObjects![indexPath.row]
        
        cell.textLabel?.text = caller.isBlocked ? String(caller.number) : caller.name ?? ""
        cell.detailTextLabel?.text = caller.isBlocked ? "" : String(caller.number)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            if let caller = self.resultsController.fetchedObjects?[indexPath.row] {
                caller.isRemoved = true
                caller.updatedDate = Date()
                self.callerData.saveContext()
            }
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let blockedCallVC = segue.destination as? BlockedCallersViewController {
                blockedCallVC.isBlocked = showBlocked
                blockedCallVC.callerData = callerData
                if let callCell = sender as? UITableViewCell,
                    let indexPath = tableView.indexPath(for: callCell),
                    let caller = resultsController.fetchedObjects?[indexPath.row] {
                    blockedCallVC.caller = caller
                }
            }
        }
}

extension CallsViewController: NSFetchedResultsControllerDelegate {
    
    // 1. Changes are coming from the NSFetchedResultsController`
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    // 2. Process a change...
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        let newIndexPath: IndexPath? = newIndexPath != nil ? IndexPath(row: newIndexPath!.row, section: 0) : nil
        let currentIndexPath: IndexPath? = indexPath != nil ? IndexPath(row: indexPath!.row, section: 0) : nil
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
            
        case .delete:
            self.tableView.deleteRows(at: [currentIndexPath!], with: .fade)
            
        case .move:
            self.tableView.moveRow(at: currentIndexPath!, to: newIndexPath!)
            
        case .update:
            self.tableView.reloadRows(at: [currentIndexPath!], with: .automatic)
            
        @unknown default:
            fatalError()
        }
    }
    
    //3.  All changes have been delivered
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}
