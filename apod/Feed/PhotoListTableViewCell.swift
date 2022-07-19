//
//  ApodListCellViewModel.swift
//  apod
//
//  Created by vivek on 16/07/22.
//

import Foundation
import UIKit

var imageCache = NSCache<NSString, UIImage>()

class PhotoListTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    var favButtonAction : ()->() = {}
    
   // @IBOutlet weak var descContainerHeightConstraint: NSLayoutConstraint!
    weak var feedListViewModel: FeedListViewModel?
    var photoListCellViewModel : PhotoListCellViewModel? {
        didSet {
            nameLabel.text = photoListCellViewModel?.titleText
            descriptionLabel.text = photoListCellViewModel?.descriptionText
            mainImageView?.loadImageUsingCacheWithURLString(photoListCellViewModel?.imageUrl ?? "", placeHolder: UIImage(named: "placeHolder"))
            dateLabel.text = "Date " + (photoListCellViewModel?.dateText ?? "")
            if(photoListCellViewModel?.isFav == true)   {
                self.favButton.setImage(UIImage(systemName: "heart.fill"), for: UIControl.State.normal)
            }
            else{
                self.favButton.setImage(UIImage(systemName: "heart"), for: UIControl.State.normal)
            }
        }
    }
    
    
    @IBAction func onFavButton(_ sender: Any) {
        favButtonAction()
    }
    
}

