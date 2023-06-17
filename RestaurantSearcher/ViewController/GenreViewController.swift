//
//  GenreViewController.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2023/06/11.
//

import UIKit


class GenreViewController: UIViewController {
    
    weak var delegate: GenreViewControllerDelegate?
    
    
    var selectedData = ""
    
    var selectedItems: [String] = []


    var genreData = [Genre]()
    
    var isFromArea = false
    
    var largeArea = [LargeArea]()
    
    @IBOutlet weak var genreTableView: UITableView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    //MARK: - Method setupTableView
    private func setupView() {
        
        // MARK: - disable my tableview
        genreTableView.allowsSelection = false
        backButton.addTarget(self, action: #selector(tappedBackButton), for: .touchUpInside)
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor.gray.cgColor
        genreTableView.delegate = self
        genreTableView.dataSource = self
        genreTableView.register(UINib(nibName: "GenreTableViewCell", bundle: nil), forCellReuseIdentifier: "cellId")
        confirmButton.addTarget(self, action: #selector(tappedConfirmButton), for: .touchUpInside)
        if isFromArea {
            titleLabel.text = "Area List"
        } else {
            titleLabel.text = "Gerne List"
        }
        
    }
    
    @objc private func tappedBackButton() {
        
        dismiss(animated: true, completion: nil)
    }
    @objc private func tappedConfirmButton() {
        if self.selectedData == "" {
            popupAlert(title: "Warning!!", message: "Please select Genre", actionTitle: "OK")
        } else {
            delegate?.genreViewController(self, isFromArea: self.isFromArea, didSelectData: selectedData)
            dismiss(animated: true, completion: nil)
        }
 
    }
    
}
// MARK: - GenreViewController: UITableViewDelegate, UITableViewDataSource
extension GenreViewController: UITableViewDelegate, UITableViewDataSource,GerneTableViewCellDelegate {
    
    func checkboxCell(_ cell: UITableViewCell, didChangeSelection isSelected: Bool) {
        if isFromArea {
            guard let indexPath = genreTableView.indexPath(for: cell) else { return }
            
            let selectedArray = largeArea[indexPath.row].name
            
            if isSelected {
                selectedItems.append(selectedArray)
                print("Selected data: \(selectedArray)")
            } else {
                if let index = selectedItems.firstIndex(of: selectedArray) {
                    selectedItems.remove(at: index)
                }
                print("Unselected data: \(selectedArray)")
            }
            
            self.selectedData = selectedItems.joined(separator: "、")
            print(selectedData)
        } else {
            guard let indexPath = genreTableView.indexPath(for: cell) else { return }
            // Assuming you have an array of data to represent your table view data source
            let selectedArray = genreData[indexPath.row].name
            
            if isSelected {
                selectedItems.append(selectedArray)
                print("Selected data: \(selectedArray)")
            } else {
                if let index = selectedItems.firstIndex(of: selectedArray) {
                    selectedItems.remove(at: index)
                }
                print("Unselected data: \(selectedArray)")
            }
            
            self.selectedData = selectedItems.joined(separator: "、")
            print(selectedData)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromArea {
            return largeArea.count
        } else {
            return genreData.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isFromArea {
            let cell = genreTableView.dequeueReusableCell(withIdentifier: "cellId") as! GenreTableViewCell
            cell.delegate = self
            //cell.textLabel?.text = dataArray[indexPath.row]
            cell.textLabel?.text = self.largeArea[indexPath.row].name
            return cell
        } else {
            let cell = genreTableView.dequeueReusableCell(withIdentifier: "cellId") as! GenreTableViewCell
            cell.delegate = self
            //cell.textLabel?.text = dataArray[indexPath.row]
            cell.textLabel?.text = genreData[indexPath.row].name
            return cell
        }
    }
    
    
}

protocol GenreViewControllerDelegate: AnyObject {
    func genreViewController(_ viewController: GenreViewController,isFromArea: Bool ,didSelectData selectedData: String)
}

