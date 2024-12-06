//
//  RecordDetailsView.swift
//  CalorieSnap
//
//  Created by Yuk Yeung Ho on 6/12/2024.
//

import UIKit

class RecordDetailsView: UIView {
    var imageRecord: UIImageView!
    var labelName: UILabel!
    var labelCalories: UILabel!
    var labelDetails: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupImageRecord()
        setupLabelName()
        setupLabelCalories()
        setupLabelDetails()
        initConstraints()
    }

    func setupImageRecord() {
        imageRecord = UIImageView()
        imageRecord.image = UIImage(systemName: "photo")
        imageRecord.contentMode = .scaleAspectFill
        imageRecord.clipsToBounds = true
        imageRecord.layer.cornerRadius = 8
        imageRecord.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageRecord)
    }

    func setupLabelName() {
        labelName = UILabel()
        labelName.font = UIFont.boldSystemFont(ofSize: 20)
        labelName.textColor = .black
        labelName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelName)
    }

    func setupLabelCalories() {
        labelCalories = UILabel()
        labelCalories.font = UIFont.systemFont(ofSize: 18)
        labelCalories.textColor = .red
        labelCalories.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelCalories)
    }

    func setupLabelDetails() {
        labelDetails = UILabel()
        labelDetails.font = UIFont.systemFont(ofSize: 16)
        labelDetails.textColor = .darkGray
        labelDetails.numberOfLines = 0
        labelDetails.textAlignment = .center
        labelDetails.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelDetails)
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            imageRecord.widthAnchor.constraint(equalToConstant: 150),
            imageRecord.heightAnchor.constraint(equalToConstant: 150),
            imageRecord.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            imageRecord.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),

            labelName.topAnchor.constraint(equalTo: imageRecord.bottomAnchor, constant: 20),
            labelName.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),

            labelCalories.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 10),
            labelCalories.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),

            labelDetails.topAnchor.constraint(equalTo: labelCalories.bottomAnchor, constant: 10),
            labelDetails.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            labelDetails.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
