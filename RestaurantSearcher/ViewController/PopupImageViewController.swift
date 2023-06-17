//
//  PopupImageViewController.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2023/06/07.
//

import UIKit

class PopupImageViewController: UIViewController {
    
    
    @IBOutlet weak var imgView: UIImageView!
    
    var parseUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if let img = URL(string: parseUrl) {
            downloadImage(from: img)
        }
    }
  
    
    @IBAction func dismissBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)

            DispatchQueue.main.async() { [weak self] in
                self?.imgView.image = UIImage(data: data)
            }
        }
    }
    
}
