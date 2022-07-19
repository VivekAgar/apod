//
//  PhotoListCellViewModel.swift
//  apod
//
//  Created by vivek on 19/07/22.
//

import Foundation
import CoreData

class PhotoListCellViewModel {
    
    var titleText: String
    var descriptionText: String
    var imageUrl: String
    var dateText: String
    var copyrightText: String
    var isFav = false
    
    init(titleText: String, descriptionText: String, imageUrl: String, dateText: String, copyrightText:String, isFav: Bool){
        self.titleText = titleText
        self.descriptionText = descriptionText
        self.imageUrl = imageUrl
        self.dateText = dateText
        self.copyrightText = copyrightText
        self.isFav = isFav
    }
    
    
    class func createAPODEntityWith(model: PhotoListCellViewModel) ->ApodEntity {
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
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
        return entity
    }
    
    class func createCellViewModel( apodEntity: ApodEntity ) -> PhotoListCellViewModel {
        var descTextContainer: [String] = [String]()
        if let description = apodEntity.explanation {
            descTextContainer.append( description )
        }
        let desc = descTextContainer.joined(separator: " - ")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let title = apodEntity.title ?? ""
        
        let cellViewModel = PhotoListCellViewModel( titleText: title,
                                                    descriptionText: desc,
                                                    imageUrl: apodEntity.hdurl ?? "",
                                                    dateText: dateFormatter.string(from: apodEntity.date ?? Date()) ,
                                                    copyrightText: "", isFav: apodEntity.isFavourite)
        return cellViewModel
    }
    
    
}

extension PhotoListCellViewModel{
    func savetoFav( model :PhotoListCellViewModel){
        isFav = !isFav
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let pred = NSPredicate(format: "hdurl = %@", model.imageUrl)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ApodEntity")
        request.predicate = pred
        do {
            let result = try context.fetch(request) as? [NSManagedObject]
            if(result?.count == 1){
                    let m = result?.first
                    m?.setValue(isFav, forKey: "isFavourite")
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
                    entity.isFavourite = isFav;
                    do {
                        try context.save()
                    }
            }
            
        } catch let err as NSError {
            print(err)
        }
    }

    

}
