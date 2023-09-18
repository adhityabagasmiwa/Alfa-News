//
//  MainTabBarViewController.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTabBarView()
    }
    
    private func initTabBarView() {
        let vcHome = UINavigationController(rootViewController: HomeNewsViewController())
        let vcSource = UINavigationController(rootViewController: HomeNewsSourceViewController())
        
        vcHome.tabBarItem.image = iconHome
        vcSource.tabBarItem.image = iconSource
        
        vcHome.tabBarItem.title = "Home"
        vcSource.tabBarItem.title = "Source"
        
        tabBar.tintColor = .systemPink
        tabBar.backgroundColor = .white
        
        setViewControllers([vcHome, vcSource], animated: true)
    }
}
