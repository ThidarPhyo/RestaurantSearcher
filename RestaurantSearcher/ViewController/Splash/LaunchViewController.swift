//
//  LaunchViewController.swift
//  RestaurantSearcher
//
//  Created by Thidar Phyo on 6/18/23.
//

import UIKit
import SwiftyGif

class LaunchViewController: UIViewController {
    let logoAnimationView = LogoAnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoAnimationView)
        logoAnimationView.pinEdgesToSuperView()
        logoAnimationView.logoGifImageView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoAnimationView.logoGifImageView.startAnimatingGif()
    }
}

extension LaunchViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true
        
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "TabBar") as? TabBarViewController {
                tabBarVC.selectedIndex = 2 // Index starts from 0, so 1 represents the second tab
                tabBarVC.modalPresentationStyle = .fullScreen
                self.present(tabBarVC, animated: true, completion: nil)
            }
        }
    }
}




