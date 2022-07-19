//
//  SearchViewController.swift
//  apod
//
//  Created by vivek on 16/07/22.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate{
    
    lazy var searchBar:UISearchBar = UISearchBar()
    private var datePicker = UIDatePicker()
    private var activityIndicator: UIActivityIndicatorView!
    private let tableView: UITableView = {
        let tableView = UITableView()
        let PhotoListTableViewCellnib = UINib(nibName: "PhotoListTableViewCell", bundle: nil)
        tableView.register(PhotoListTableViewCellnib, forCellReuseIdentifier: "PhotoListTableViewCell")
        //tableView.separatorColor = UIColor.clear
        return tableView
    }()
    lazy var viewModel: SearchViewModel = {
        return SearchViewModel()
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
        print("Clicked in Search Bar")
    }
    
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func initView(){
        self.view.backgroundColor = UIColor.gray
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        self.navigationController?.title = "Search"
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        datePicker.datePickerMode = .date
        datePicker.sizeThatFits(CGSize(width: self.view.frame.size.width, height: 400))
        datePicker.preferredDatePickerStyle = .inline
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dateSelected));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        self.searchBar.inputAccessoryView = toolbar
        self.searchBar.searchTextField.inputView = datePicker
        
        
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

    }
    
    @objc
    func dateSelected(_ sender: AnyObject){
        print("dateSelected =  \(datePicker.date)")
        viewModel.initFetch(date: datePicker.date)
        searchBar.resignFirstResponder()
    }

    @objc
    func cancelDatePicker(_ sender: AnyObject){
        print("cancelDatePicker")
        searchBar.resignFirstResponder()
    }
    
    func showAlert(_ message: String){
        
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
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

