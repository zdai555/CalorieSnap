//
//  RecordDetailsView.swift
//  CalorieSnap
//
//  Created by Yuk Yeung Ho on 6/12/2024.
//

import UIKit

class RecordDetailsView: UIView {
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var imageRecord: UIImageView!
    var labelName: UILabel!
    var labelCalories: UILabel!
    var labelDate: UILabel!
    var labelDetails: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupScrollView()
        setupImageRecord()
        setupLabelName()
        setupLabelCalories()
        setupLabelDate()
        setupLabelDetails()
        initConstraints()
    }

    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
    }

    func setupImageRecord() {
        imageRecord = UIImageView()
        imageRecord.image = UIImage(systemName: "photo")
        imageRecord.contentMode = .scaleAspectFill
        imageRecord.clipsToBounds = true
        imageRecord.layer.cornerRadius = 8
        imageRecord.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageRecord)
    }

    func setupLabelName() {
        labelName = UILabel()
        labelName.font = UIFont.boldSystemFont(ofSize: 20)
        labelName.textColor = .black
        labelName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelName)
    }

    func setupLabelCalories() {
        labelCalories = UILabel()
        labelCalories.font = UIFont.systemFont(ofSize: 18)
        labelCalories.textColor = .red
        labelCalories.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelCalories)
    }
    
    func setupLabelDate() {
        labelDate = UILabel()
        labelDate.font = UIFont.systemFont(ofSize: 16)
        labelDate.textColor = .darkGray
        labelDate.numberOfLines = 0
        labelDate.textAlignment = .center
        labelDate.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelDate)
    }

    func setupLabelDetails() {
        labelDetails = UILabel()
        labelDetails.font = UIFont.systemFont(ofSize: 16)
        labelDetails.textColor = .darkGray
        labelDetails.numberOfLines = 0
        labelDetails.textAlignment = .center
        labelDetails.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelDetails)
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            imageRecord.widthAnchor.constraint(equalToConstant: 150),
            imageRecord.heightAnchor.constraint(equalToConstant: 150),
            imageRecord.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageRecord.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),

            labelName.topAnchor.constraint(equalTo: imageRecord.bottomAnchor, constant: 20),
            labelName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            labelCalories.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 10),
            labelCalories.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            labelDate.topAnchor.constraint(equalTo: labelCalories.bottomAnchor, constant: 10),
            labelDate.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            labelDetails.topAnchor.constraint(equalTo: labelDate.bottomAnchor, constant: 10),
            labelDetails.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            labelDetails.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            labelDetails.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
