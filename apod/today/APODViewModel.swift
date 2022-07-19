//
//  APODViewModel.swift
//  apod
//
//  Created by vivek on 19/07/22.
//

import Foundation

class APODViewModel
{
    let apiService: APIServiceProtocol

    private var apods: [Apod] = [Apod]()
    
    private var cellViewModels: [PhotoListCellViewModel] = [PhotoListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }

    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    
    var isAllowSegue: Bool = false
    var selectedApod: Apod?

    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    //Change to search
    func initFetch(date: Date) {
        self.cellViewModels.removeAll()
        self.isLoading = true
        apiService.fetchSearchData(date: date, complete: { [weak self](success, apod, error )in
            self?.isLoading = false
            if let error = error {
                self?.alertMessage = error.rawValue
            } else {
                self?.apods = [Apod]()
                self?.apods.append(apod ?? Apod())
                self?.processFetchedApodData( apods: self?.apods)
            }
        })
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> PhotoListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    private func processFetchedApodData( apods: [Apod]? ) {
        self.apods = apods!
        self.cellViewModels.removeAll()
        //Create ManagedObject and save in CoreData
        var cellVMArray = [PhotoListCellViewModel]()
        for apod in apods! {
            let apodEntity = createApodEntity(apod: apod)
            cellVMArray.append(PhotoListCellViewModel.createCellViewModel(apodEntity: apodEntity))

        }
        
        self.cellViewModels = cellVMArray
    }
    func createApodEntity(apod:Apod)-> ApodEntity{
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let entity:  ApodEntity = ApodEntity(context: context)
            entity.title = apod.title
            entity.explanation = apod.explanation
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateObj = dateFormatter.date(from: apod.date ?? "2001-09-22")
            print("Dateobj: \(String(describing: dateObj))")
            entity.date = dateObj
            entity.hdurl = apod.hdurl
            entity.isFavourite = false
        return entity
    }
    func createCellViewModel( apodEntity: ApodEntity ) -> PhotoListCellViewModel {
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
 
    func addtoFav(at indexPath: IndexPath){
        
        let cellVM = self.cellViewModels[indexPath.row]
        CoreDataStack.sharedInstance.savetoFav(model: cellVM)
        self.cellViewModels[indexPath.row] = cellVM
        self.reloadTableViewClosure?()
        
    }

    
}
