//
//  RoleTableViewController.swift
//  Internship
//
//  Created by sys-246 on 2/18/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import CoreData

class RoleTableViewController: UITableViewController {
  var onCellSelect: ((NSManagedObject) -> Void)?
  
  private var titleName = "Roles"
  private var cellId = "Role"
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationItem.title = titleName
    tableView.register(GeneralCell.self, forCellReuseIdentifier: cellId)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let fetched = DataBaseManager.shared.getRoles().count
    
    return fetched
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GeneralCell
    
    let role = DataBaseManager.shared.getRoles()[indexPath.row]//fetchController.object(at: indexPath)
    cell.name?.text = role.name
    cell.content = role
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let chosenCell = tableView.cellForRow(at: indexPath) as? GeneralCell else {
      return
    }
    
    onCellSelect?(chosenCell.content)
    self.navigationController?.popViewController(animated: true)
  }
}
