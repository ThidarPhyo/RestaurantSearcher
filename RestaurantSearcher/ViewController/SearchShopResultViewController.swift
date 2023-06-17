//
//  SearchShopResultViewController.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2023/06/07.
//

import UIKit
import CoreLocation

class SearchShopResultViewController: UIViewController, UITextFieldDelegate {
    
    var shopData = [Shop]()
    var isFromMain = false
    
    private var latValue = Double()
    private var lngValue = Double()
    private var locManager: CLLocationManager!
    
    var parseGenre = ""
    var isFromSearchShopView = false
    
    var parseSearchKeyword = ""
    
    @IBOutlet weak private var searchShopResultTableView: UITableView!
    @IBOutlet weak private var backButton: UIButton!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchView: UIView!
    
    
    @IBOutlet weak var searchViewNSLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchBtnNSLayoutConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
        
        searchButton.addTarget(self, action: #selector(tappedSearchButton), for: .touchUpInside)
        sortShopDataByDistance {_ in
            self.searchShopResultTableView.reloadData()
        }
        setupView()
        
        searchTextField.delegate = self
        
        //call when user editing text
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if isFromMain == true {
            
        }
        if isFromSearchShopView == true {
            
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.searchTextField.text = self.parseSearchKeyword
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFromSearchShopView == true {
//            searchViewNSLayoutConstraint.constant = 0
//            searchBtnNSLayoutConstraint.constant = 0
            fetchSearchShopInfoWithArea(searchText: parseGenre)
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if(textField.text != ""){
            
            
        } else {
        
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let textField = searchTextField.text {
            if textField != ""{
                self.parseSearchKeyword = textField
                fetchSearchShopInfo(searchText: textField)
            } else {
                
            }
        }
        
        searchTextField.resignFirstResponder()
        //return false statement indicates that you don't want the text field to process the return key as a line break.
        return false
        
    }
    
    @objc private func tappedSearchButton() {
        if let textField = searchTextField.text {
            
            if(textField != ""){
                self.parseSearchKeyword = textField
                fetchSearchShopInfo(searchText: textField)
            } else {
                popupAlert(title: "Warning!!!", message: "Please enter the name of the restaurant", actionTitle: "OK") { action in
                    
                }
                
            }
            searchTextField.resignFirstResponder()
        }
    }
    
    
    private func fetchSearchShopInfo(searchText: String) {
        
        let params = [
            
            "keyword": searchText,
            "lat": "\(latValue)",
            "lng": "\(lngValue)"
            
        ] as [String : Any]
        
        GenericAPIClient.shared.request(params: params, type: ShopData.self) { [self] (shop) in
            
            self.shopData = shop.results.shop
            self.searchShopResultTableView.reloadData()
            
        }
    }
    private func fetchSearchShopInfoWithArea(searchText: String) {
        
        let params = [
            
            "keyword": searchText
            
        ] as [String : Any]
        
        GenericAPIClient.shared.request(params: params, type: ShopData.self) { [self] (shop) in
            
            self.shopData = shop.results.shop
            self.searchShopResultTableView.reloadData()
            
        }
    }
    
    //MARK: - Method setupTableView
    private func setupView() {
        
        backButton.addTarget(self, action: #selector(tappedBackButton), for: .touchUpInside)
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor.gray.cgColor
        searchShopResultTableView.delegate = self
        searchShopResultTableView.dataSource = self
        searchShopResultTableView.register(UINib(nibName: "SearchShopResultTableViewCell", bundle: nil), forCellReuseIdentifier: "cellId")
    }
    
    private func setupLocation() {
        locManager = CLLocationManager()
        locManager.delegate = self
        
        locManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locManager.requestWhenInUseAuthorization()
        locManager.distanceFilter = 10
        
        // Get permission to use location information
        locManager.requestWhenInUseAuthorization()
    }
    
    @objc private func tappedBackButton() {
        
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .darkContent
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
                
                //add lant and long
                latValue = location.coordinate.latitude
                lngValue = location.coordinate.longitude
                return location
            }
        }
        
        return nil
    }

    func locationServicesEnabled() async -> Bool {
        await withCheckedContinuation { continuation in
            let locationManager = CLLocationManager()
            
            if #available(iOS 14.0, *) {
                let status = locationManager.authorizationStatus
                
                continuation.resume(returning: status == .authorizedWhenInUse || status == .authorizedAlways)
            } else {
                let status = CLLocationManager.authorizationStatus()
                
                continuation.resume(returning: status == .authorizedWhenInUse || status == .authorizedAlways)
            }
        }
    }

    
    func sortShopDataByDistance(completion: @escaping (Double?) -> Void) {
        DispatchQueue.global().async {
            // Obtain the current location
            guard self.getCurrentLocation() != nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            // Calculate the distances for each shop and find the maximum distance
            var maxDistance: Double = 0.0
            
            self.shopData.forEach { shop in
                guard let distance = self.distanceInMetersFromCurrentLocation(to: CLLocation(latitude: shop.lat, longitude: shop.lng)) else {
                    return
                }
                
                //let formattedDistance = String(format: "%.0f", distance)
                
                if distance > maxDistance {
                    maxDistance = distance
                }
            }
            
            // Sort the shop data based on distance
            self.shopData.sort {
                guard let distance1 = self.distanceInMetersFromCurrentLocation(to: CLLocation(latitude: $0.lat, longitude: $0.lng)),
                      let distance2 = self.distanceInMetersFromCurrentLocation(to: CLLocation(latitude: $1.lat, longitude: $1.lng)) else {
                    return false // Handle cases where distance calculation fails
                }
                
                return distance1 < distance2
            }
            
            DispatchQueue.main.async {
                completion(maxDistance)
                
                // Reload the table view after sorting and retrieving the data
                self.searchShopResultTableView.reloadData()
            }
        }
    }
    
}

// MARK: - SearchShopResulrViewController: UITableViewDelegate, UITableViewDataSource
extension SearchShopResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return shopData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchShopResultTableView.dequeueReusableCell(withIdentifier: "cellId") as! SearchShopResultTableViewCell
        
        let shopDetail = shopData[indexPath.row] // Access the sorted shop data using indexPath.row
        
        let shopLocation = CLLocation(latitude: shopDetail.lat, longitude: shopDetail.lng)
        
        if let distanceMeters = distanceInMetersFromCurrentLocation(to: shopLocation) {
            // If 2 decimal "%.2f"
            let formattedDistance = String(format: "%.0f", distanceMeters)
            cell.distanceLabel.text = "\(formattedDistance) m"
            cell.shopDetail = shopDetail
        }
        
        return cell
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let shopDetailViewController = UIStoryboard(name: "ShopDetail", bundle: nil).instantiateViewController(withIdentifier: "ShopDetailViewController") as! ShopDetailViewController
        shopDetailViewController.modalPresentationStyle = .fullScreen
        shopDetailViewController.shopDetail = self.shopData[indexPath.row]
        self.present(shopDetailViewController, animated: true, completion: nil)
        
        //when select off animation
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension SearchShopResultViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        let longitude = (locations.last?.coordinate.longitude)!
        let latitude = (locations.last?.coordinate.latitude)!
        
        let lngFloor = ceil(longitude * 1000)/1000
        let latFloor = floor(latitude * 100)/100
        
        latValue = latFloor
        lngValue = lngFloor
    }
    
}
