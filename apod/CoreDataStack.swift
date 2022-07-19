//
//  CoreDataStack.swift
//  apod
//
//  Created by vivek on 17/07/22.
//

import Foundation
import CoreData


class CoreDataStack: NSObject {
    
    static let sharedInstance = CoreDataStack()
    private override init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "FavApodModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    

    func savetoFav( model : PhotoListCellViewModel){
        model.isFav = !model.isFav
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let pred = NSPredicate(format: "hdurl = %@", model.imageUrl)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ApodEntity")
        request.predicate = pred
        do {
            let result = try context.fetch(request) as? [NSManagedObject]
            if(result?.count == 1){
                    let m = result?.first
                m?.setValue(model.isFav, forKey: "isFavourite")
                    try? context.save()
                }
            else{
                //create a new and save to coreData
                let entity:  ApodEntity = ApodEntity(context: context)
                    entity.title = model.titleText
                    entity.explanation = model.descriptionText
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let dateObj = dateFormatter.date(from: model.dateText)
                    print("Dateobj: \(String(describing: dateObj))")
                    entity.date = dateObj
                    entity.hdurl = model.imageUrl
                    entity.isFavourite = model.isFav;
                    do {
                        try context.save()
                    }
            }
            
        } catch let err as NSError {
            print(err)
        }
    }

    func fetchAll()-> [ApodEntity]{
        var result:[ApodEntity] = [ApodEntity]()
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ApodEntity")

        do {
            let results = try context.fetch(fetchRequest)
            result = results as! [ApodEntity]
            
        }catch let error as NSError {
            print(error.debugDescription)
        }
       return result
    }







}



extension CoreDataStack {
    
    func applicationDocumentsDirectory() {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "yo.BlogReaderApp" in the application's documents directory.
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
}
