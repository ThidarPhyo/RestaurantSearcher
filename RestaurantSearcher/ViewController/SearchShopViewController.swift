//
//  SearchShopViewController.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2023/06/09.
//

import UIKit
import CoreLocation

class SearchShopViewController: UIViewController,UISearchBarDelegate,GenreViewControllerDelegate {
    func genreViewController(_ viewController: GenreViewController, isFromArea: Bool, didSelectData selectedData: String) {
        if selectedData == "" {
            DefaultGenreLabel()
        } else {
            if isFromArea {
                
                self.areaLabel.text = selectedData
                self.areaLabel.textColor = .black
                print("isFromArea Selected data is: \(selectedData)")
            } else {
                self.genreLabel.text = selectedData
                self.genreLabel.textColor = .black
                print("Selected data is: \(selectedData)")
            }
        }
    }
    
    
    
    private var shopDetail: Shop?
    //private var shopData = [Shop]()
    private var shopCount = Int()
    var shopData = [Shop]() {
        didSet {
           collectionView.reloadData()
        }
    }
    
    var genreData = [Genre]()
    
    var largeArea = [LargeArea]()
    
    private var latValue = Double()
    private var lngValue = Double()
    
    private var locManager: CLLocationManager!

    private var timer : Timer?
    private var currentCellIndex = 0
    
    var panGestureRecognizer: UIPanGestureRecognizer!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var gClearBtn: UIButton!
    
    
    @IBOutlet weak var aClearBtn: UIButton!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var areaLabel: UILabel!
    
    
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var genreButton: UIButton!
    
    @IBOutlet weak var areaButton: UIButton!
    
    //for 検索する Button
    @IBOutlet weak var shButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func loadView() {
        super.loadView()
        //call before viewdidload()
        fetchShopDefaultDataInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocation()
        
        searchBar.delegate = self
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        // Set the search bar's search field background color to transparent
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.backgroundColor = .white
        }
        searchBtn.addTarget(self, action: #selector(tappedSearchViewBtn), for: .touchUpInside)
        
        //GenreViewController
        genreButton.addTarget(self, action: #selector(tappedGenreViewBtn), for: .touchUpInside)
        
        //clearGenreButton
        gClearBtn.addTarget(self, action: #selector(tappedGenreClearBtn), for: .touchUpInside)
        
        shButton.addTarget(self, action: #selector(tappedShViewBtn), for: .touchUpInside)
        
        //ShopArea
        areaButton.addTarget(self, action: #selector(tappedAreaViewBtn), for: .touchUpInside)
        
        //clearShopAreaButton
        aClearBtn.addTarget(self, action: #selector(tappedAreaClearBtn), for: .touchUpInside)
        
        fetchGenreDataInfo()
        fetchShopAreaDataInfo()
        setupCollectionView()
        
        //swipe collectionview
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            collectionView.addGestureRecognizer(panGestureRecognizer)
    }
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(moveToNextIndex), userInfo: nil, repeats: true)
    }
    
    private func setupCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        pageControl.numberOfPages = shopCount
        startTimer()
    }
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            // Invalidate the timer when the pan gesture begins
            timer?.invalidate()
        case .ended:
            // Resume the timer when the pan gesture ends
            startTimer()
            
            // Check if the gesture resulted in a significant swipe
            let translation = gestureRecognizer.translation(in: collectionView)
            if translation.x > 50 { // Adjust this threshold as needed
                // Swiped to the right
                moveToPreviousIndex()
            } else if translation.x < -50 { // Adjust this threshold as needed
                // Swiped to the left
                moveToNextIndex()
            }
        default:
            break
        }
    }

    @objc func moveToNextIndex() {
        if currentCellIndex < shopCount - 1 {
            currentCellIndex += 1
        } else {
            currentCellIndex = 0
        }
        
        updateCollectionView()
    }

    @objc func moveToPreviousIndex() {
        if currentCellIndex > 0 {
            currentCellIndex -= 1
        } else {
            currentCellIndex = shopCount - 1
        }
        
        updateCollectionView()
    }

    func updateCollectionView() {
        collectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.currentPage = currentCellIndex
        pageControl.numberOfPages = shopCount
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
    @objc private func tappedGenreClearBtn() {
        
        DefaultGenreLabel()
    }
    @objc private func tappedAreaClearBtn() {
        
        areaLabel.text = "エリア"
        genreLabel.textColor = .darkGray
    }
    
    //Default genreLabel Method
    private func DefaultGenreLabel() {
        genreLabel.text = "ジャンル"
        genreLabel.textColor = .darkGray
    }
    //GenreData
    private func fetchGenreDataInfo() {
        
        let params = [
            "lat": "\(latValue)",
            "lng": "\(lngValue)"
            
        ] as [String : Any]
        
        GenericAPIClient.shared.requestGenre(params: params, type: GenreData.self) { (genre) in
            
            self.genreData = genre.results.genre
        }
    }
    
    //ShopAreaData
    private func fetchShopAreaDataInfo() {
        
        let params = [
            "lat": "\(latValue)",
            "lng": "\(lngValue)"
            
        ] as [String : Any]
        
        GenericAPIClient.shared.requestShopArea(params: params, type: ShopAreaData.self) { (area) in
            self.largeArea = area.results.largeArea
            
        }
    }
    
    //fetchData with Range = 1
    private func fetchShopDefaultDataInfo() {
        
        let params = [
            "range": "1",
            "lat": "\(latValue)",
            "lng": "\(lngValue)"
            
        ] as [String : Any]
        
        GenericAPIClient.shared.request(params: params, type: ShopData.self) { (shop) in
            
            self.shopData = shop.results.shop
            self.shopCount = shop.results.shop.count
            DispatchQueue.main.async{
                self.collectionView.reloadData() //reload data after
            }
        }
        DispatchQueue.main.async {
            // Reload or update the collection view with the loaded data
            self.collectionView.reloadData()
        }
    }
    
    
    // MARK: - tappedSearchViewBtn
    @objc private func tappedSearchViewBtn() {
        let shopSearchResultViewController = UIStoryboard(name: "SearchShopResult", bundle: nil).instantiateViewController(withIdentifier: "SearchShopResultViewController") as! SearchShopResultViewController
        
        shopSearchResultViewController.modalPresentationStyle = .fullScreen
        
        self.present(shopSearchResultViewController, animated: true, completion: nil)
        
    }
    
    // MARK: - GenreViewController
    @objc private func tappedGenreViewBtn() {
        
        let genreViewController = UIStoryboard(name: "Genre", bundle: nil).instantiateViewController(withIdentifier: "GenreViewController") as! GenreViewController
        genreViewController.modalPresentationStyle = .fullScreen
        //need to add delegate always
        genreViewController.genreData = self.genreData
        genreViewController.delegate = self
        self.present(genreViewController, animated: true, completion: nil)
        
    }
    
    // MARK: - GenreViewController
    @objc private func tappedAreaViewBtn() {
        
        let genreViewController = UIStoryboard(name: "Genre", bundle: nil).instantiateViewController(withIdentifier: "GenreViewController") as! GenreViewController
        genreViewController.modalPresentationStyle = .fullScreen
        //need to add delegate always
        genreViewController.largeArea = self.largeArea
        genreViewController.isFromArea = true
        genreViewController.delegate = self
        self.present(genreViewController, animated: true, completion: nil)
        
    }
    
    // MARK: - tappedShViewBtn (検索する)
    @objc private func tappedShViewBtn() {
        
        guard let genre = self.genreLabel.text else {
            return
        }
        guard let area = self.areaLabel.text else {
            return
        }
        if genre == "ジャンル" {
            popupAlert(title: "Warning!!!", message: "Please select ジャンル", actionTitle: "OK") { action in
                
            }
        } else if area == "エリア" {
            popupAlert(title: "Warning!!!", message: "Please select エリア", actionTitle: "OK") { action in
                
            }
        } else {
            let shopSearchResultViewController = UIStoryboard(name: "SearchShopResult", bundle: nil).instantiateViewController(withIdentifier: "SearchShopResultViewController") as! SearchShopResultViewController
            let parseKeyword = "\(genre)　\(area)"
            shopSearchResultViewController.parseSearchKeyword = parseKeyword
            shopSearchResultViewController.modalPresentationStyle = .fullScreen
            
            // MARK: - change 、to (which contains a full-width space)
            //example, the keyword "オーガニック　東京" from hotpepper api
            let replacedparseKeyword = parseKeyword.replacingOccurrences(of: "、", with: "　")
            
            shopSearchResultViewController.isFromSearchShopView = true
            shopSearchResultViewController.parseGenre = replacedparseKeyword
            self.present(shopSearchResultViewController, animated: true, completion: nil)
        }
        
    }
    
}
extension SearchShopViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        let longitude = (locations.last?.coordinate.longitude)!
        let latitude = (locations.last?.coordinate.latitude)!
        
        let lngFloor = ceil(longitude * 1000)/1000
        let latFloor = floor(latitude * 100)/100
        
        latValue = latFloor
        lngValue = lngFloor
        
        fetchShopDefaultDataInfo()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
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
extension SearchShopViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        shopCount
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! ImageCoverCollectionViewCell
        let shopDetail = shopData[indexPath.row]
        cell.shopDetail = shopDetail
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let shopDetailViewController = UIStoryboard(name: "ShopDetail", bundle: nil).instantiateViewController(withIdentifier: "ShopDetailViewController") as! ShopDetailViewController
        shopDetailViewController.modalPresentationStyle = .fullScreen
        shopDetailViewController.shopDetail = self.shopData[indexPath.row]
        self.present(shopDetailViewController, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
