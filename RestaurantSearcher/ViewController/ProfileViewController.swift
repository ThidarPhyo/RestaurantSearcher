//
//  ProfileViewController.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2023/06/13.
//

import UIKit
import SwiftUI

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var theContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let childView = UIHostingController(rootView: ProfileView())
        addChild(childView)
        childView.view.frame = theContainer.bounds
        theContainer.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
     
}
