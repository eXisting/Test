//
//  CoreDataStack.swift
//  inern
//
//  Created by Andrey Popazov on 2/11/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import Foundation
import CoreData

class DataBaseManager: NSObject {

  let modelName = "DepartmentsBook"
  let entityName = "Employee"
  
  // MARK: Fields
  
  static let shared = DataBaseManager()
  
  private var persistentStoreCoordinator: NSPersistentStoreCoordinator?
  
  private var mainManagedObjectContext: NSManagedObjectContext?
  private var storeManagedObjectContext: NSManagedObjectContext?
  
  private var fetchedResultsController: NSFetchedResultsController<Employee>?
  
  weak var frcDelegate: NSFetchedResultsControllerDelegate?
  
  // MARK: Initialization

  private override init() {
    super.init()
    setupContext()
    setupPersistentStore()
  }
  
  private func setupContext() {
    var storeUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    storeUrl.appendPathComponent("DepartmentBook.sqlite")
    
    let modelUrl = Bundle.main.url(forResource: "DepartmentBook", withExtension: "momd")
    
    let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl!)
    
    persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel!)
    
    let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                  NSInferMappingModelAutomaticallyOption: true]
    
    do {
      let _ = try persistentStoreCoordinator!.addPersistentStore(
        ofType: "SQLite",
        configurationName: nil,
        at: storeUrl,
        options: options)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  private func setupPersistentStore() {
    mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    mainManagedObjectContext!.undoManager = nil
    mainManagedObjectContext!.mergePolicy = NSOverwriteMergePolicy
    mainManagedObjectContext!.persistentStoreCoordinator = self.persistentStoreCoordinator
    
    storeManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    storeManagedObjectContext!.undoManager = nil
    storeManagedObjectContext!.mergePolicy = NSOverwriteMergePolicy
    storeManagedObjectContext!.persistentStoreCoordinator = self.persistentStoreCoordinator
  }
  
  // MARK: Fetch result controller
  
  func getFetchController() ->  NSFetchedResultsController<Employee> {
    if let controller = fetchedResultsController {
      return controller
    }
    
    let fetchRequest = NSFetchRequest<Employee>()
    fetchRequest.entity = NSEntityDescription.entity(forEntityName: entityName, in: mainManagedObjectContext!)
    
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    fetchRequest.returnsObjectsAsFaults = false
    fetchRequest.fetchBatchSize = 20
    
    fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: mainManagedObjectContext!,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    do {
      let _ = try fetchedResultsController?.performFetch()
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
    
    return fetchedResultsController!
  }
  
  // MARK: Actions
  
  func create(from dict: [String: Any]) {
    let object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: storeManagedObjectContext!)
    
    setFields(of: object, with: dict)
    
    save(context: storeManagedObjectContext)
  }
  
  func update(with dict: [String: Any]) {
    let object = storeManagedObjectContext!.object(with: dict["objectId"] as! NSManagedObjectID)
    
    setFields(of: object, with: dict)
    
    save(context: storeManagedObjectContext)
  }
  
  func delete(object: NSManagedObject) {
    let managedObjectId = object.objectID
    
    storeManagedObjectContext!.delete(storeManagedObjectContext!.object(with: managedObjectId))
    save(context: storeManagedObjectContext)
  }
  
  // MARK: Helpers
  
  private func save(context: NSManagedObjectContext?) {
    saveDatabase(with: context)
  }
  
  
  private func saveDatabase(with context: NSManagedObjectContext?) {
    if persistentStoreCoordinator == nil {
      return
    }
    
    let strongContext = context
    strongContext?.performAndWait {
      do {
        try strongContext?.save()
      } catch {
        print(error.localizedDescription)
      }
      
      let parentContext = strongContext?.parent
      parentContext?.performAndWait {
        saveDatabase(with: parentContext)
      }
    }
  }
  
  private func setFields(of object: NSManagedObject, with dict: [String: Any]) {
    object.setValue(dict["name"], forKey: "name")
    object.setValue(dict["phone"], forKey: "phone")
    object.setValue(dict["email"], forKey: "email")
    object.setValue(dict["photo"], forKey: "photo")
    
    //    object.setValue(dict["roleId"], forKey: "roleId")
    //    object.setValue(dict["departmentId"], forKey: "departmentId")
  }
}
