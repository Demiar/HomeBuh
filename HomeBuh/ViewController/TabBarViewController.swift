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

        let tabOne = RecordsTableViewController()
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
        
        let tabThree = DiagramViewController()
        let tabThreeBarItem3 = UITabBarItem(title: "Diagram",
                                          image: UIImage(systemName: "house"),
                                          selectedImage: UIImage(named: "house")
        )
        
        tabThree.tabBarItem = tabThreeBarItem3
        
        let controllers = [tabOne, tabTwo, tabThree]
        self.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
    }
    
    private func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        return UINavigationController(rootViewController: rootViewController)
    }

}
