//
//  ViewController.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2023/06/06.
//

import UIKit
import MapKit

class CellClass: UITableViewCell {
    
}

class MainViewController: UIViewController, UITextFieldDelegate {
    
    private var shopDetail: Shop?
    private var shopData = [Shop]()
    private var shopCount = Int()
    
    private var nameStringArray = [String]()
    private var shopImageStringArray = [String]()
    private var addressStringArray = [String]()
    private var accessStringArray = [String]()
    private var openStringArray = [String]()
    private var parkingStringArray = [String]()
    private var catchStringArray = [String]()
    private var indexNumber = Int()
    
    private var latValue = Double()
    private var lngValue = Double()
    var imageUrl: String = ""
    
    private var locManager: CLLocationManager!
    private var pointAno: MKPointAnnotation = MKPointAnnotation()
    
    private var searchText = ""
    
    let dropdownTableView = UITableView()
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var searchResultButton: UIButton!
    
    @IBOutlet weak var mkMapView: MKMapView!
    
    @IBOutlet weak var dropdownButton: UIButton!
    
    //MARK: - For DropDown
    let transparentView = UIView()
    let tableView = UITableView()
    
    var selectedButton = UIButton()
    
    var dataSource = [String]()
    
    private var range : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        searchButton.addTarget(self, action: #selector(tappedSearchButton), for: .touchUpInside)
        searchResultButton.addTarget(self, action: #selector(tappedSearchResultButton), for: .touchUpInside)
        
        //Make sure to set the text field's delegate
        searchTextField.delegate = self
        
        //call when user editing text
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        setupDropdownList()

        dropdownButton.addTarget(self, action: #selector(tappedDropdownButton), for: .touchUpInside)
    }
    
    
    //For Dropdown
    private func setupDropdownList(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
    }
    
    //MARK: - Dropdown View
    func addTransparentView(frames: CGRect) {
        //'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }

        transparentView.frame = window.frame
        window.addSubview(transparentView)

        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        window.addSubview(tableView)
        tableView.layer.cornerRadius = 5

        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        transparentView.alpha = 0

        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
        }, completion: nil)

    }
    
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
    @objc private func tappedDropdownButton() {
        dataSource = ["300m", "500m", "1000m","2000m", "3000m"]
        selectedButton = dropdownButton
        addTransparentView(frames: dropdownButton.frame)
    }
    func didSelectDropDownOption(at meter: String) {
        
        switch meter {
        case "300m":
            
            self.range = "1"
        case "500m":
            
            self.range = "2"
        case "1000m":
           
            self.range = "3"
        case "2000m":
           
            self.range = "4"
        case "3000m":
           
            self.range = "5"
        default:
           
            break
        }
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if(textField.text == ""){
            
            
        } else {
            
            
        }
    }
    
    @objc private func tappedSearchButton() {
        if let textField = searchTextField.text {
            
            if(textField != ""){
                fetchSearchShopInfo(searchText: textField)
            } else {
                popupAlert(title: "Warning!!!", message: "Please enter the name of the restaurant", actionTitle: "OK") { action in
                    
                }
                
            }
            searchTextField.resignFirstResponder()
        }
        
    }
    @objc private func tappedSearchResultButton() {
        let shopSearchResultViewController = UIStoryboard(name: "SearchShopResult", bundle: nil).instantiateViewController(withIdentifier: "SearchShopResultViewController") as! SearchShopResultViewController
        
        shopSearchResultViewController.modalPresentationStyle = .fullScreen
        guard let text = self.searchTextField.text else {return}
        shopSearchResultViewController.parseSearchKeyword = text
        shopSearchResultViewController.isFromMain = true
        shopSearchResultViewController.shopData = shopData
        
        self.present(shopSearchResultViewController, animated: true, completion: nil)
        
    }
    
    private func fetchShopDataInfo() {
        
        let params = [
            
            "keyword": searchText,
            "range" : "1",
            "lat": "\(latValue)",
            "lng": "\(lngValue)"
            
        ] as [String : Any]
        
        GenericAPIClient.shared.request(params: params, type: ShopData.self) { (shop) in
            
            self.shopData = shop.results.shop
            self.shopCount = shop.results.shop.count
            self.addAnnotation()
            
            // Save ShopData to UserDefaults
            saveShopData(shopData: self.shopData)
        }
    }
    
    private func fetchSearchShopInfo(searchText: String) {
        
        let params = [
            
            "keyword": searchText,
            "range" : self.range ?? "1",
            "lat": "\(latValue)",
            "lng": "\(lngValue)"
            
        ] as [String : Any]
        
        GenericAPIClient.shared.request(params: params, type: ShopData.self) { (shop) in
            
            self.shopData = shop.results.shop
            self.shopCount = shop.results.shop.count
            self.addAnnotation()
        }
    }
    
    private func setupMap() {
        
        locManager = CLLocationManager()
        locManager.delegate = self
        mkMapView.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locManager.requestWhenInUseAuthorization()
        locManager.distanceFilter = 10
        
        // Get permission to use location information
        locManager.requestWhenInUseAuthorization()
        
        
        // set scale
        var region:MKCoordinateRegion = mkMapView.region
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        mkMapView.setRegion(region,animated:true)
        
        // enable current location display
        mkMapView.showsUserLocation = true
        // Set the current position (the center position is updated with the current position only once at this time as the device moves)
        mkMapView.userTrackingMode = .follow
        
        // show tracking button
        let trakingButton = MKUserTrackingButton(mapView: mkMapView)
        trakingButton.layer.backgroundColor = UIColor(white: 1, alpha: 0.7).cgColor
        
        let dispSize: CGSize = UIScreen.main.bounds.size
        let height = Int(dispSize.height)
        trakingButton.frame = CGRect(x:40, y:height - 82, width:40, height:40)
        
        self.view.addSubview(trakingButton)
        
        //Show scale bar
        let scale = MKScaleView(mapView: mkMapView)
        scale.frame.origin.x = 15
        scale.frame.origin.y = 120
        scale.legendAlignment = .trailing
        scale.scaleVisibility = .visible
        self.view.addSubview(scale)
        
        // compass display
        let compass = MKCompassButton(mapView: mkMapView)
        let width = Int(dispSize.width)
        compass.compassVisibility = .adaptive
        compass.frame = CGRect(x: width - 50, y: 120, width: 40, height: 40)
        self.view.addSubview(compass)
        // Hide default compass
        mkMapView.showsCompass = false
        
    }
    
    private func addAnnotation() {
        removeArray()
        
        // When data is empty
        if shopCount == 0 {
            return
        }
        
        for i in 0...shopCount - 1 {
            let imageUrlString = shopData[i].photo.mobile.s
            
            guard let imageUrl = URL(string: imageUrlString) else {
                continue
            }
            
            // Use URLSession for asynchronous image loading
            URLSession.shared.dataTask(with: imageUrl) { [weak self] (data, response, error) in
                guard let self = self, let data = data, let image = UIImage(data: data) else {
                    return
                }
                
                DispatchQueue.main.async {
                    let annotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: self.shopData[i].lat, longitude: self.shopData[i].lng),title: self.shopData[i].name,subtitle: self.shopData[i].open,imageUrl: imageUrlString,image: image)
                    
                    self.nameStringArray.append(self.shopData[i].name)
                    self.addressStringArray.append(self.shopData[i].address)
                    self.shopImageStringArray.append(imageUrlString)
                    self.accessStringArray.append(self.shopData[i].access)
                    self.parkingStringArray.append(self.shopData[i].parking)
                    self.openStringArray.append(self.shopData[i].open)
                    self.catchStringArray.append(self.shopData[i].catch)
                    
                    self.mkMapView.addAnnotation(annotation)
                }
            }.resume()
        }
    }


    
    private func removeArray() {
        
        //if want to removeAnnotations
        mkMapView.removeAnnotations(mkMapView.annotations)
        
        nameStringArray = []
        addressStringArray = []
        shopImageStringArray = []
        accessStringArray = []
        parkingStringArray = []
        openStringArray = []
        catchStringArray = []
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        if let textField = searchTextField.text {
            
            if(textField != ""){
                fetchSearchShopInfo(searchText: textField)
            } else {
//                popupAlert(title: "Failed!!!", message: "Please enter the name of the restaurant correctly", actionTitle: "OK") { action in
//
//                }
                
            }
            searchTextField.resignFirstResponder()
        }
        return false
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .darkContent
    }
    // Function to resize the image
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return resizedImage
    }
    
}

extension MainViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        let longitude = (locations.last?.coordinate.longitude)!
        let latitude = (locations.last?.coordinate.latitude)!
        
        let lngFloor = ceil(longitude * 1000)/1000
        let latFloor = floor(latitude * 100)/100
        
        self.latValue = latFloor
        self.lngValue = lngFloor
    
        fetchShopDataInfo()
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomAnnotation else {
            return nil
        }
        
        let annotationIdentifier = "CustomAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        // Customize the annotation view
        annotationView?.canShowCallout = true
        
        if let image = annotation.image {
            // Resize the image to 30x30
            let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 40, height: 40))
            annotationView?.image = resizedImage
            
            // Apply corner radius to the annotation view's image
            annotationView?.layer.cornerRadius = resizedImage.size.width / 2
            annotationView?.layer.masksToBounds = true
        } else {
            // Set a default image if the annotation's image is nil
            annotationView?.image = UIImage(named: "meal")
        }
        
        // Apply other styling to the annotation view
        annotationView?.layer.shadowColor = UIColor.black.cgColor
        annotationView?.layer.shadowOffset = CGSize(width: 0, height: 2)
        annotationView?.layer.shadowOpacity = 0.5
        annotationView?.layer.shadowRadius = 2
        
        // Disable clipsToBounds for the annotation view
        annotationView?.clipsToBounds = false
        
        return annotationView
    }

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        indexNumber = Int()
        
        if nameStringArray.firstIndex(of: (view.annotation?.title)!!) != nil {
            
            indexNumber = nameStringArray.firstIndex(of: (view.annotation?.title)!!)!
        }
        
        let shopDetailViewController = UIStoryboard(name: "ShopDetail", bundle: nil).instantiateViewController(withIdentifier: "ShopDetailViewController") as! ShopDetailViewController
        
        shopDetailViewController.modalPresentationStyle = .overCurrentContext
        
        //parse data to ShopDetailViewController
        shopDetailViewController.shopDetail = self.shopData[indexNumber]
        self.present(shopDetailViewController, animated: true, completion: nil)
    }

    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //        let status = manager.authorizationStatus
        let status = manager.authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse: locManager.startUpdatingLocation()
            break
            
        case .notDetermined, .denied, .restricted:
            break
            
        default:
            break
            
        }
        
        switch manager.accuracyAuthorization {
        case .reducedAccuracy: break
        case .fullAccuracy: break
            
        default:
            print("This should not happen")
        }
    }
}

//MARK: - CUSTOM DROPDOWNLIST
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        didSelectDropDownOption(at: dataSource[indexPath.row])
        removeTransparentView()
    }
}

