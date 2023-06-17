//
//  ShopDetailViewController.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2023/06/06.
//

import UIKit

class ShopDetailViewController: UIViewController {
    
    var shopDetail: Shop?
    private var saveImgUrl = ""
    
    @IBOutlet weak private var shopDetailTableView: UITableView!
    @IBOutlet weak private var shopImageView: UIImageView!
    @IBOutlet weak private var backButton: UIButton!
    
    @IBOutlet weak var imgButton: UIButton!
    
    let imageView: UIImageView = UIImageView(image: UIImage(named: "list"))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
    }
    

    @IBAction func phoneAction(_ sender: Any) {
        "08011871888".makeACall()
    }
    
    @IBAction func imgButtonAction(_ sender: Any) {
        
        let PopupImageViewController = UIStoryboard(name: "PopupImage", bundle: nil).instantiateViewController(withIdentifier: "PopupImageViewController") as! PopupImageViewController
        PopupImageViewController.modalPresentationStyle = .overFullScreen
        PopupImageViewController.parseUrl = self.saveImgUrl
        self.present(PopupImageViewController, animated: true, completion: nil)
    }
    
    // MARK: - Method
    private func setupView() {
        
        shopDetailTableView.delegate = self
        shopDetailTableView.dataSource = self
        shopDetailTableView.register(UINib(nibName: "ShopDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "cellId")
        backButton.addTarget(self, action: #selector(tappedBackButton), for: .touchUpInside)
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor.gray.cgColor
        
        if let url = URL(string:shopDetail?.photo.pc.l ?? "" ) {
            
            downloadImage(from: url)
        }
        
        shopImageView.layer.borderWidth = 1
        
        
    }
    
    
    
    //Asynchronously:
    //Create a method with a completion handler to get the image data from your url
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {

        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
  
            DispatchQueue.main.async() { [weak self] in
                self?.shopImageView.image = UIImage(data: data)
            }
        }
    }
    
    @objc private func tappedBackButton() {
        
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .darkContent
    }
}

// MARK: - ShopDetailViewController: UITableViewDelegate, UITableViewDataSource
extension ShopDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 600
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = shopDetailTableView.dequeueReusableCell(withIdentifier: "cellId") as! ShopDetailTableViewCell
        
        if let strUrl =  shopDetail?.photo.pc.l {
            saveImgUrl = strUrl
            
        }
        
        cell.shopDetail = shopDetail
        
        //disable didSelect
        cell.selectionStyle = .none
        return cell
    }
    
    
    
}

