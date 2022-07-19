//
//  FavouriteViewController.swift
//  apod
//
//  Created by vivek on 17/07/22.
//

import Foundation
import UIKit

class FavouriteViewController: UIViewController{
    
    
    var activityIndicator: UIActivityIndicatorView!
    //viewModel
    lazy var viewModel: FavouriteViewModel = {
        return FavouriteViewModel()
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        let PhotoListTableViewCellnib = UINib(nibName: "PhotoListTableViewCell", bundle: nil)
        tableView.register(PhotoListTableViewCellnib, forCellReuseIdentifier: "PhotoListTableViewCell")
        //tableView.separatorColor = UIColor.clear
        return tableView
    }()
    
    
    override func loadView() {
        self.view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init the views
        initView()
        
        // init view model
        initViewModel()
        
    }
    
    func initView() {
        //self.navigationItem.title = "Feed"
        self.tableView.frame = CGRect(origin: CGPoint.zero, size: self.view.frame.size)
        self.view.addSubview(tableView)
        self.activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        self.activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
        
    }
    
    
    func initViewModel(){
        
        viewModel.showAlertClosure =  {[weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }

        viewModel.reloadTableViewClosure = {[weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
            let isLoading = self?.viewModel.isLoading ?? false
            if isLoading {
                self?.activityIndicator.startAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self?.tableView.alpha = 0.0
                })
            }else {
                self?.activityIndicator.stopAnimating()
                self?.tableView.refreshControl?.endRefreshing()
                UIView.animate(withDuration: 0.2, animations: {
                    self?.tableView.alpha = 1.0
                })
                
            }
        }
            
        }
        
        viewModel.reloadTableViewAtIndexClosure = {[weak self] (indexPath) in
            DispatchQueue.main.async {
                var indexPaths = [IndexPath]()
                indexPaths.append(indexPath)
                self?.tableView.beginUpdates()
                self?.tableView.reloadRows(at: indexPaths, with: UITableView.RowAnimation.automatic)
                self?.tableView.endUpdates()
            }
            
        }
        
        viewModel.initFetch()
            
    }
    
    func showAlert(_ message: String){
        
    }
    @objc
    func callPullToRefresh(){
        viewModel.initFetch()
    }
    
    
}
extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoListTableViewCell", for: indexPath) as? PhotoListTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        cell.photoListCellViewModel = cellVM
        cell.favButtonAction = { [weak self] in
            self?.viewModel.addtoFav(at: indexPath)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800.0
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
       // self.viewModel.userPressed(at: indexPath)
        if viewModel.isAllowSegue {
            return indexPath
        }else {
            return nil
        }
    }

}
