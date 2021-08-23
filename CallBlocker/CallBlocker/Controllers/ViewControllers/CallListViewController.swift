//
//  CallListViewController.swift
//  CallBlocker
//
//  Created by James McDougall on 8/23/21.
//

import UIKit

class CallListViewController: UIViewController {

	@IBOutlet weak var callerType: UISegmentedControl!
		  @IBOutlet weak var tableView: UITableView!
		
		  override func viewDidLoad() {
			super.viewDidLoad()
			self.tableView.dataSource = self
			self.tableView.delegate = self
			self.loadData()
		  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
