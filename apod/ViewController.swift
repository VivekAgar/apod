//
//  ViewController.swift
//  apod
//
//  Created by vivek on 16/07/22.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.view.backgroundColor = UIColor.brown
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let feedViewController = FeedViewController()
        let feedTabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "list.dash"), selectedImage: UIImage(systemName: "list.dash"))
        feedViewController.tabBarItem = feedTabBarItem
        // Create Tab two
        let todayViewController = APODViewController()
        let todayBarItem = UITabBarItem(title: "Today", image: UIImage(systemName: "calendar"), selectedImage: UIImage(systemName: "calendar"))
        todayViewController.tabBarItem = todayBarItem
        
        let searchViewController = SearchViewController()
        let tabTwoBarItem2 = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        searchViewController.tabBarItem = tabTwoBarItem2
        
        let favViewController = FavouriteViewController()
        let tabTwoBarItem3 = UITabBarItem(title: "Favourite", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart"))
        favViewController.tabBarItem = tabTwoBarItem3

        self.viewControllers = [
            UINavigationController(rootViewController: feedViewController),
            UINavigationController(rootViewController: todayViewController),
            UINavigationController(rootViewController: searchViewController),
            UINavigationController(rootViewController: favViewController)]
            
            
            
            //feedViewController, todayViewController, searchViewController, favViewController]
        
        self.selectedIndex = 0
        self.tabBar.tintColor = UIColor.systemIndigo
        self.tabBar.backgroundColor = UIColor.systemBackground
        self.tabBar.isTranslucent = false
    }
    
}
    //Mark - UITabBarControllerDelegate
extension ViewController: UITabBarControllerDelegate{
    
    
       func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
           
           
           
       }
}
