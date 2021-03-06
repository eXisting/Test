//
//  AddMoreTextDelegate.swift
//  Internship
//
//  Created by sys-246 on 2/14/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

extension AddMoreViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return textField != self.mainView.departmentManager &&
      textField != self.mainView.employeeProfileView?.department &&
      textField != self.mainView.employeeProfileView?.role &&
      textField != self.mainView.employeeProfileView?.location
  }
}

extension AddMoreViewController: ImagePickerDelegate {
  func populateImageView(with image: UIImage?) {
    mainView.employeeProfileView?.profileImage?.image = image
  }
  
  func presentPicker() {
    self.present(self.imagePicker.picker, animated: true, completion: nil)
  }
}
