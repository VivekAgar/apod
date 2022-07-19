//
//  APODViewController.swift
//  apod
//
//  Created by vivek on 16/07/22.
//

import Foundation
import UIKit

class APODViewController: UIViewController{
    private var activityIndicator: UIActivityIndicatorView!
    private let tableView: UITableView = {
        let tableView = UITableView()
        let PhotoListTableViewCellnib = UINib(nibName: "PhotoListTableViewCell", bundle: nil)
        tableView.register(PhotoListTableViewCellnib, forCellReuseIdentifier: "PhotoListTableViewCell")
        //tableView.separatorColor = UIColor.clear
        return tableView
    }()
    lazy var viewModel: APODViewModel = {
        return APODViewModel()
    }()
    override func loadView() {
        self.view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
    
    
    override func viewDidLoad() {
        
        
        // Init the views
        initView()
        
        // init view model
        initViewModel()
        
        
        
    }
    
    func initView(){
        self.view.backgroundColor = UIColor.gray
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        self.navigationController?.title = "Search"
        self.tableView.frame = CGRect(origin: CGPoint(x: 0, y: 45), size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height - 100) )
        self.view.addSubview(tableView)
        self.activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        self.activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self

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
                UIView.animate(withDuration: 0.2, animations: {
                    self?.tableView.alpha = 1.0
                })
            }
        }
            
        }
        
        viewModel.initFetch(date: Date())
            
    }
    func showAlert(_ message: String){
        
    }

}
extension APODViewController: UITableViewDelegate, UITableViewDataSource {
    
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
}

