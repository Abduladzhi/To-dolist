//
//  TableViewCell.swift
//  Todo-list-new
//
//  Created by Abduladzhi on 27.04.2022.
//

import UIKit


protocol TableViewProtocol {
    func getData(id: String, label: String, image: Data, date: Date, descriptionOne: String, isComplited: Bool)
    func getUp(id: String, label: String, image: Data, date: Date, descriptionOne: String, isComplited: Bool)
}

class TableViewCell: UITableViewCell {
    static let identifier = String(describing: self)
    var textInTextField: String?
    var number: Int!
    var saveDate: Date?
    var saveDescription: String?
    var saveUuid: String!
    var changeImageNew: UIImage?
    var delegate: TableViewProtocol?
   
    @IBOutlet weak var changeButtons: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageSmall: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func pressPlus(_ sender: Any) {
        let dataNew = imageSmall.image?.jpegData(compressionQuality: 0.5) as Data?
        if number == 0 {
            delegate?.getData(id: saveUuid ,label: nameLabel.text ?? "", image: dataNew ?? Data(), date: saveDate ?? Date(), descriptionOne: saveDescription ?? "", isComplited: true)
            number = nil
        } else {
            delegate?.getUp(id: saveUuid ,label: nameLabel.text ?? "", image: dataNew ?? Data(), date: saveDate ?? Date(), descriptionOne: saveDescription ?? "", isComplited: false)
            number = nil
        }
    }

    func configure(delegate: TableViewProtocol, id: String, name: String, image: Data, date: Date, descriptionOne: String, section: Int) {
        if section == 0 {
            changeButtons.setImage(UIImage(systemName: "square"), for: .normal)
            changeButtons.tintColor = .black
        } else {
            changeButtons.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            changeButtons.tintColor = .black
        }
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        saveDescription = descriptionOne
        number = section
        saveDate = date
        nameLabel.text = name
        saveUuid = id
        imageSmall.image = UIImage(data: image)
        dateLabel.text = dateFormatter.string(from: date)
        self.delegate = delegate
    }
    
}
