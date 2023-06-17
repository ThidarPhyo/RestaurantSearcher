//
//  TabBarViewController.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2023/06/10.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.layer.cornerRadius = 30
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    
    }
    

    override func viewDidLayoutSubviews() {
        changeHeightOfTabbar()
    }

    func changeHeightOfTabbar() {
        if UIDevice().userInterfaceIdiom == .phone {
            var tabFrame = tabBar.frame
            tabFrame.size.height = 100
            tabFrame.origin.y = view.frame.size.height - 100
            tabBar.frame = tabFrame
        }
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        AnimationWhenSelectedItem(item)
    }
    func AnimationWhenSelectedItem(_ item: UITabBarItem){
        guard let barItemView = item.value(forKey: "view") as? UIView else {
            return
        }
        let timeInterval: TimeInterval = 0.5
        let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.5) {
            barItemView.transform = CGAffineTransform.identity.scaledBy(x: 1.9, y: 1.9)
        }
        propertyAnimator.addAnimations({
            barItemView.transform = .identity
        }, delayFactor: CGFloat(timeInterval))
        propertyAnimator.startAnimation()
        
    }
}
