//
//  ViewController.swift
//  dailyRoutine
//
//  Created by Миша on 14.03.2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    // MARK: - private methods
    private func setupTabBar(){
        
        let scheduleViewController = createNavController(
            vc: ScheduleViewController(),
            itemName: "Schedule",
            itemImage: "calendar.badge.clock")
        
        let tasksViewController = createNavController(
            vc: TasksViewController(),
            itemName: "Tasks",
            itemImage: "text.badge.checkmark")
        
        let contactsViewController = createNavController(
            vc: ContactsViewController(),
            itemName: "Contacts",
            itemImage: "rectangle.stack.person.crop")
        
        viewControllers = [
            scheduleViewController,
            tasksViewController,
            contactsViewController
        ]
    }
    
    private func createNavController(vc: UIViewController, itemName: String, itemImage: String) -> UINavigationController {
        
        let item = UITabBarItem(
            title: itemName,
            image: UIImage(systemName: itemImage)?.withAlignmentRectInsets(.init(
                top: 10,
                left: 0,
                bottom: 0,
                right: 0)),
            tag: 0)
        
        item.titlePositionAdjustment = .init(horizontal: 0, vertical: 10)
        
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = item
        
        return navController
    }
}

