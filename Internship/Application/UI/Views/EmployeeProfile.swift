//
//  EmployeeProfile.swift
//  inern
//
//  Created by Andrey Popazov on 2/11/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import CoreData

enum RoleType: String {
  case manager = "PM"
  case regular
}

class EmployeeProfile: UIView {
  var profileImage: UIImageView?
  
  var name: UITextField?
  var role: UITextField?
  var phone: UITextField?
  var email: UITextField?
  var department: UITextField?
  var location: UITextField?
  
  var departments: [Department]? {
    didSet {
      var names = ""
      
      for element in departments! {
        names += " \(element.name ?? "");"
      }
      
      department?.text = names
    }
  }
  
  var locationData: [String: Any]? {
    didSet {
      location?.text = (locationData!["name"] as! String)
    }
  }
  
  var canPickDepartment: Bool! {
    didSet {
      department!.isUserInteractionEnabled = canPickDepartment
    }
  }
  
  var roleId: NSManagedObjectID?
  var roleType: RoleType!
  
  var infoStack: UIStackView?

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    laidOutViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupFields(from employee: Employee?) {
    name?.text = employee?.name
    role?.text = employee?.role?.name
    phone?.text = employee?.phone
    email?.text = employee?.email
    location?.text = employee?.location?.name

    departments = (employee?.department?.allObjects as! [Department])
    
    profileImage?.image = UIImage(data: employee?.photo ?? Data())
    
    roleId = employee?.role?.objectID
    
    canPickDepartment = roleId != nil
    roleType = role?.text != RoleType.manager.rawValue ? .regular : .manager
  }
  
  func clearDepartments() {
    departments = []
    department?.text = ""
  }
  
  func getFieldsDataAsDict() -> [String: Any]? {    
    guard let userName = name?.text,
      let phoneValue = phone?.text,
      let emailValue = email?.text,
      let roleValue = roleId,
      let depIds = departments,
      let photoValue = profileImage?.image?.pngData(),
      let employeeLocationData = locationData else {
      return nil
    }
    
    var ids: [Any] = []
    for element in depIds {
      ids.append(element.objectID)
    }
    
    return [
      "name": userName as Any,
      "phone": phoneValue as Any,
      "email": emailValue as Any,
      "roleId": roleValue as Any,
      "departmentsIds": ids,
      "location": employeeLocationData,
      "photo": photoValue as Any
    ]
  }
  
  private func laidOutViews() {
    laidOutImage()
    laidOutInfoStack()
    laidOutTextFields()
  }
  
  private func laidOutInfoStack() {
    let stackSize = CGSize(width: self.frame.width * 0.65, height: self.frame.height * 0.4)
    let orign = CGPoint(x: self.frame.width / 2 - stackSize.width / 2, y: self.frame.height * 0.4)
    
    infoStack = UIStackView(frame: CGRect(origin: orign, size: stackSize))
    infoStack?.alignment = .fill
    infoStack?.distribution = .fillEqually
    infoStack?.axis = .vertical
    addSubview(infoStack!)
  }
  
  private func laidOutTextFields() {
    name = UITextField()
    role = UITextField()
    phone = UITextField()
    email = UITextField()
    department = UITextField()
    location = UITextField()

    name!.textColor = .black
    name!.font = UIFont.boldSystemFont(ofSize: 17)
    name!.clearButtonMode = .whileEditing
    name!.textAlignment = .left
    name!.placeholder = "Name"
    
    role!.textColor = .black
    role!.font = UIFont.boldSystemFont(ofSize: 17)
    role!.clearButtonMode = .whileEditing
    role!.textAlignment = .left
    role!.placeholder = "Position"
    
    phone!.textColor = .black
    phone!.font = UIFont.boldSystemFont(ofSize: 17)
    phone!.clearButtonMode = .whileEditing
    phone!.textAlignment = .left
    phone!.placeholder = "Phone"
    
    email!.textColor = .black
    email!.font = UIFont.boldSystemFont(ofSize: 17)
    email!.clearButtonMode = .whileEditing
    email!.textAlignment = .left
    email!.placeholder = "E-mail"
    
    department!.textColor = .black
    department!.font = UIFont.boldSystemFont(ofSize: 17)
    department!.clearButtonMode = .whileEditing
    department!.textAlignment = .left
    department!.placeholder = "Department"

    location!.textColor = .black
    location!.font = UIFont.boldSystemFont(ofSize: 17)
    location!.clearButtonMode = .whileEditing
    location!.textAlignment = .left
    location!.placeholder = "Location"

    infoStack!.addArrangedSubview(name!)
    infoStack!.addArrangedSubview(role!)
    infoStack!.addArrangedSubview(phone!)
    infoStack!.addArrangedSubview(email!)
    infoStack!.addArrangedSubview(department!)
    infoStack!.addArrangedSubview(location!)
  }
  
  private func laidOutImage() {
    let size = self.frame.width * 0.4
    let imageSize = CGSize(width: size, height: size)
    let orign = CGPoint(x: self.frame.width / 2 - size / 2, y: size / 2)
    
    profileImage = UIImageView(frame: CGRect(origin: orign, size: imageSize))
    profileImage?.backgroundColor = .lightGray
    
    addSubview(profileImage!)
  }
}
