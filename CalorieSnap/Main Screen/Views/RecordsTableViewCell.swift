//
//  ContactsTableViewCell.swift
//  CalorieSnap
//
//  Created by Steph on 2/11/2024.
//

import UIKit

class RecordsTableViewCell: UITableViewCell {
    var wrapperCellView: UIView!
    var labelTitle: UILabel!
    var labelDate: UILabel!
    var labelDetails: UILabel!
    var labelCalories: UILabel!
    var imageReceipt: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupWrapperCellView()
        setupImageReceipt()
        setupLabelTitle()
        setupLabelDetails()
        setupLabelDate()
        setupLabelCalories()
        initConstraints()
    }
    
    func setupWrapperCellView() {
        wrapperCellView = UIView()
        wrapperCellView.layer.borderColor = UIColor.gray.cgColor
        wrapperCellView.layer.borderWidth = 1
        wrapperCellView.layer.cornerRadius = 10
        wrapperCellView.clipsToBounds = true
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(wrapperCellView)
    }
    
    func setupImageReceipt() {
        imageReceipt = UIImageView()
        imageReceipt.image = UIImage(systemName: "photo")
        imageReceipt.contentMode = .scaleAspectFill
        imageReceipt.clipsToBounds = true
        imageReceipt.layer.cornerRadius = 8
        imageReceipt.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(imageReceipt)
    }
    
    func setupLabelTitle() {
        labelTitle = UILabel()
        labelTitle.font = UIFont.boldSystemFont(ofSize: 16)
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelTitle)
    }
    
    func setupLabelDate() {
        labelDate = UILabel()
        labelDate.font = UIFont.systemFont(ofSize: 14)
        labelDate.numberOfLines = 1
        labelDate.textColor = .darkGray
        labelDate.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelDate)
    }
    
    func setupLabelDetails() {
        labelDetails = UILabel()
        labelDetails.font = UIFont.systemFont(ofSize: 14)
        labelDetails.numberOfLines = 1
        labelDetails.textColor = .darkGray
        labelDetails.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelDetails)
    }
    
    func setupLabelCalories() {
        labelCalories = UILabel()
        labelCalories.font = UIFont.systemFont(ofSize: 14)
        labelCalories.textColor = .blue
        labelCalories.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelCalories)
    }
    func initConstraints() {
        let imagePadding: CGFloat = 12 // Padding for the image
        
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            wrapperCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            wrapperCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            wrapperCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            imageReceipt.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: imagePadding),
            imageReceipt.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: imagePadding),
            imageReceipt.bottomAnchor.constraint(lessThanOrEqualTo: wrapperCellView.bottomAnchor, constant: -imagePadding),
            imageReceipt.widthAnchor.constraint(equalToConstant: 80),
            imageReceipt.heightAnchor.constraint(equalToConstant: 80),
            
            labelTitle.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            labelTitle.leadingAnchor.constraint(equalTo: imageReceipt.trailingAnchor, constant: 12),
            labelTitle.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -8),
            
            labelDate.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 4),
            labelDate.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelDate.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -8),
            
            labelDetails.topAnchor.constraint(equalTo: labelDate.bottomAnchor, constant: 4),
            labelDetails.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelDetails.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -8),
            
            labelCalories.topAnchor.constraint(equalTo: labelDetails.bottomAnchor, constant: 4),
            labelCalories.leadingAnchor.constraint(equalTo: labelDetails.leadingAnchor),
            labelCalories.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -8),
            labelCalories.bottomAnchor.constraint(lessThanOrEqualTo: wrapperCellView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with record: Record) {
        labelTitle.text = record.name
        labelDate.text = record.date
        labelDetails.text = record.details
        labelCalories.text = "Calories: \(record.calorie)"
        
        if let photoURLString = record.photoURL, let photoURL = URL(string: photoURLString) {
            imageReceipt.loadRemoteImage(from: photoURL)
        } else {
            imageReceipt.image = UIImage(systemName: "photo")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
