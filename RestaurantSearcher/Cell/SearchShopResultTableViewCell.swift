//
//  SearchShopResultTableViewCell.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2023/06/07.
//

import UIKit
import CoreLocation

class SearchShopResultTableViewCell: UITableViewCell {
    
    private var latValue = Double()
    private var lngValue = Double()
    private var locManager: CLLocationManager!
    
    var distancesArray = [String]()
    
    var shopDetail: Shop? {
        didSet {
            
            if let url = URL(string: shopDetail?.photo.pc.l ?? "") {
                downloadImage(from: url)
            }
            
            shopNameLabel.text = shopDetail?.name
            accessLabel.text = shopDetail?.access
            openLabel.text = shopDetail?.open
            budgetLabel.text = shopDetail?.budget.name
            cardLabel.text = shopDetail?.card
        }
    }
    
    @IBOutlet weak private var ShopImageView: UIImageView!
    @IBOutlet weak private var shopNameLabel: UILabel!
    @IBOutlet weak private var accessLabel: UILabel!
    @IBOutlet weak private var openLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var budgetLabel: UILabel!
    
    
    @IBOutlet weak var cardLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ShopImageView.layer.cornerRadius = 30
        ShopImageView.layer.borderWidth = 2
        ShopImageView.layer.borderColor = UIColor.purple.cgColor
        ShopImageView.layer.shadowColor = UIColor.black.cgColor
        ShopImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        ShopImageView.layer.shadowOpacity = 0.5
        ShopImageView.layer.shadowRadius = 2
        
        cardLabel.layer.borderWidth = 2
        cardLabel.layer.borderColor = UIColor.purple.cgColor

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.ShopImageView.image = UIImage(data: data)
            }
        }
    }
    
    func distanceInMetersFromCurrentLocation(to shopLocation: CLLocation) -> Double? {
        guard let currentLocation = getCurrentLocation() else {
            return nil
        }
        
        let distanceInMeters = currentLocation.distance(from: shopLocation)
        return distanceInMeters
    }
    
    func getCurrentLocation() -> CLLocation? {
        // Create a CLLocationManager instance
        let locationManager = CLLocationManager()
        
        // Check if location services are enabled
        if CLLocationManager.locationServicesEnabled() {
            // Request permission to access the user's location
            locationManager.requestWhenInUseAuthorization()
            
            // Start updating the user's location
            locationManager.startUpdatingLocation()
            
            // Retrieve the user's current location
            if let location = locationManager.location {
                return location
            }
        }
        
        return nil
    }
    
}


