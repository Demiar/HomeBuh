//
//  TabBarViewController.swift
//  HomeBuh
//
//  Created by Алексей on 20.07.2021.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let tabOne = TableViewController()
        let tabOneBarItem = UITabBarItem(title: "Records",
                                         image: UIImage(systemName: "magnifyingglass"),
                                         selectedImage: UIImage(named: "magnifyingglass")
        )
        
        tabOne.tabBarItem = tabOneBarItem

        let tabTwo = CategoryTableViewController()
        let tabTwoBarItem2 = UITabBarItem(title: "Categories",
                                          image: UIImage(systemName: "house"),
                                          selectedImage: UIImage(named: "house")
        )
        
        tabTwo.tabBarItem = tabTwoBarItem2
        
        let controllers = [tabOne, tabTwo]
        self.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                                    title: String,
                                                    image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        
        return navController
      }

}
