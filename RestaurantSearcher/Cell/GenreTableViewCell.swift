//
//  GenreTableViewCell.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2023/06/11.
//

import UIKit


class GenreTableViewCell: UITableViewCell {
    
    weak var delegate: GerneTableViewCellDelegate?
    
    @IBOutlet weak var checkboxButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkboxButton.setImage(UIImage(named: "uncheck"), for: .normal)
        checkboxButton.setImage(UIImage(named: "check"), for: .selected)
        checkboxButton.addTarget(self, action: #selector(checkboxButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func checkboxButtonTapped(_ sender: UIButton) {
        checkboxButton.isSelected.toggle()
        delegate?.checkboxCell(self, didChangeSelection: checkboxButton.isSelected)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(selected: Bool) {
        checkboxButton.isSelected = selected
    }
}

protocol GerneTableViewCellDelegate: AnyObject {
    func checkboxCell(_ cell: UITableViewCell, didChangeSelection isSelected: Bool)
}
