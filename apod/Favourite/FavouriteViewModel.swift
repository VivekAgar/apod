//
//  FavouriteViewModel.swift
//  apod
//
//  Created by vivek on 17/07/22.
//

import Foundation
import CoreData
class FavouriteViewModel{

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
    var reloadTableViewAtIndexClosure: (( _ indexPath:IndexPath)->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    
    func initFetch() {
        self.isLoading = true

        fetchData()
    }
    
    func fetchData(){
        self.cellViewModels.removeAll()
        var cellVMArray = [PhotoListCellViewModel]()
        
        let results: [ApodEntity] = CoreDataStack.sharedInstance.fetchAll()
            for item in results{
                if (item.isFavourite == true){
                    cellVMArray.append(createCellViewModel(apodEntity: item))
                }
            }
            
        self.cellViewModels = cellVMArray
        self.isLoading = false
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
    
    func getCellViewModel( at indexPath: IndexPath ) -> PhotoListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( apod: Apod ) -> PhotoListCellViewModel {

        //Wrap a description
        var descTextContainer: [String] = [String]()
//        if let camera = photo.camera {
//            descTextContainer.append(camera)
//        }
        if let description = apod.explanation {
            descTextContainer.append( description )
        }
        let desc = descTextContainer.joined(separator: " - ")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let title = apod.title ?? ""
        return PhotoListCellViewModel( titleText: title,
                                       descriptionText: desc,
                                       imageUrl: apod.hdurl ?? "",
                                       dateText: apod.date ?? "",
                                       copyrightText: apod.copyright ?? "", isFav: true)
    }
    
    func addtoFav(at indexPath: IndexPath){
        
        let cellVM = self.cellViewModels[indexPath.row]
        CoreDataStack.sharedInstance.savetoFav(model: cellVM)
        self.cellViewModels[indexPath.row] = cellVM
        reloadTableViewAtIndexClosure?(indexPath)
        
    }
    
}
    

    


