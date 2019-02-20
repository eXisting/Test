//
//  MainTableViewController.swift
//  inern
//
//  Created by Andrey Popazov on 2/11/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
  
  static let defaultRowHeight = UIScreen.main.bounds.height * 0.08
  static let defaultSectionHeight = UIScreen.main.bounds.height * 0.1

  private var titleName = "Home"
  
  private var source: HomeTableViewDelegates!
  
  override func loadView() {
    super.loadView()
    
    let tableView = HomeTableView(frame: self.view.frame, style: .plain)
    source = HomeTableViewDelegates(master: self, tableView: tableView)
    
    self.view = tableView
    
    self.navigationItem.title = titleName
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddMoreButtonClick))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    source.tableView.register(cell: (source.cellId, EmployeeCell.self), header: (source.headerId, ReusableHeader.self))
    
    reloadData()
  }
  
  func reloadData() {
    do {
      let _ = try source.fetchController.performFetch()
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
    
    source.data.removeAll()
    
    if let departments = source.fetchController.fetchedObjects {
      for department in departments {
        source.data.append(.init(department))
      }
    }
    
    source.tableView.reloadData()
  }
  
  @objc func onAddMoreButtonClick() {
    let controller = AddMoreViewController()
    controller.view.backgroundColor = .white
    controller.callback = reloadData
    self.navigationController?.pushViewController(controller, animated: true)
  }
}