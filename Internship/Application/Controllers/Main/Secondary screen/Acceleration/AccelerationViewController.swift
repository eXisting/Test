//
//  AccelerationViewController.swift
//  Internship
//
//  Created by sys-246 on 3/5/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

class AccelerationViewController: UIViewController {
  private let titleName = "Acceleration"
  
  private let mainView = AccelerationView()
  private let model = AccelerationModel()
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainView.setup()
    model.startObserving(accelerationCallback: mainView.onAccelerationChange, gyroscopeCallback: mainView.onGyroscopeChange)
    subscribeOnGyroChanges()
  }
  
  private func subscribeOnGyroChanges() {
    NotificationCenter.default.addObserver(self, selector: #selector(onDidOrientationChanged), name: .DidReceiveGyro, object: nil)
  }
  
  @objc private func onDidOrientationChanged(_ notification: Notification) {
    mainView.setValue(notification.object as! String, forKeyPath: "oriantationLabel.kvcText")
  }
}

extension AccelerationViewController: SetupableTabBarController {
  func setup() {
    tabBarItem.title = titleName
    
    tabBarItem.selectedImage = UIImage(named: "orientation")
    tabBarItem.image = UIImage(named: "orientation")
  }
}
