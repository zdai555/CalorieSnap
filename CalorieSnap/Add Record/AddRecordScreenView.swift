//
//  AddRecordScreenView.swift
//  CalorieSnap
//
//  Created by Yuk Yeung Ho on 5/12/2024.
//

import UIKit

class AddRecordScreenView: UIView {
    
    var labelName: UILabel!
    var textFieldName: UITextField!
    var labelCalorie: UILabel!
    var textFieldCalorie: UITextField!
    var labelDate: UILabel!
    var textFieldDate: UITextField!
    var labelDetails: UILabel!
    var textFieldDetails: UITextField!
    var buttonTakePhoto: UIButton!
    var labelPhoto: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLabelName()
        setupTextFieldName()
        setupLabelCalorie()
        setupTextFieldCalorie()
        setupLabelDate()
        setupTextFieldDate()
        setupLabelDetails()
        setupTextFieldDetails()
        setupbuttonTakePhoto()
        setupLabelPhoto()
        
        initConstraints()
        
        self.backgroundColor = .white
    }
    
    func setupLabelName() {
        labelName = UILabel()
        labelName.text = "Name"
        labelName.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelName)
    }
    
    func setupTextFieldName() {
        textFieldName = UITextField()
        textFieldName.placeholder = "Enter name"
        textFieldName.borderStyle = .roundedRect
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldName)
    }
    
    func setupLabelCalorie() {
        labelCalorie = UILabel()
        labelCalorie.text = "Calories"
        labelCalorie.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        labelCalorie.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelCalorie)
    }
    
    func setupTextFieldCalorie() {
        textFieldCalorie = UITextField()
        textFieldCalorie.placeholder = "Enter calorie count"
        textFieldCalorie.borderStyle = .roundedRect
        textFieldCalorie.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldCalorie)
    }
    
    func setupLabelDate() {
        labelDate = UILabel()
        labelDate.text = "Date"
        labelDate.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        labelDate.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelDate)
    }
    
    func setupTextFieldDate() {
        textFieldDate = UITextField()
        textFieldDate.placeholder = "Enter Date (MM/DD/YY)"
        textFieldDate.borderStyle = .roundedRect
        textFieldDate.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldDate)
    }

    func setupLabelDetails() {
        labelDetails = UILabel()
        labelDetails.text = "Details"
        labelDetails.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        labelDetails.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelDetails)
    }
    
    func setupTextFieldDetails() {
        textFieldDetails = UITextField()
        textFieldDetails.placeholder = "Enter details"
        textFieldDetails.borderStyle = .roundedRect
        textFieldDetails.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldDetails)
    }

    func setupbuttonTakePhoto(){
        buttonTakePhoto = UIButton(type: .system)
        buttonTakePhoto.setTitle("", for: .normal)
        buttonTakePhoto.setImage(UIImage(systemName: "photo"), for: .normal)
        buttonTakePhoto.contentMode = .scaleAspectFit
        buttonTakePhoto.imageView?.contentMode = .scaleAspectFill
        buttonTakePhoto.clipsToBounds = true
        buttonTakePhoto.translatesAutoresizingMaskIntoConstraints = false
        buttonTakePhoto.showsMenuAsPrimaryAction = true
        self.addSubview(buttonTakePhoto)
    }
    
    func setupLabelPhoto() {
        labelPhoto = UILabel()
        labelPhoto.text = "Photo"
        labelPhoto.translatesAutoresizingMaskIntoConstraints = false
        labelPhoto.textColor = .gray
        labelPhoto.font = labelPhoto.font.withSize(16)
        self.addSubview(labelPhoto)
    }
    
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            labelName.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            labelName.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            labelName.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            textFieldName.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8),
            textFieldName.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textFieldName.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            buttonTakePhoto.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 4),
            buttonTakePhoto.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            buttonTakePhoto.widthAnchor.constraint(equalToConstant: 100),
            buttonTakePhoto.heightAnchor.constraint(equalToConstant: 100),
            
            labelPhoto.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            labelPhoto.topAnchor.constraint(equalTo: buttonTakePhoto.bottomAnchor, constant: 8),
            
            labelCalorie.topAnchor.constraint(equalTo: labelPhoto.bottomAnchor, constant: 16),
            labelCalorie.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            labelCalorie.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            textFieldCalorie.topAnchor.constraint(equalTo: labelCalorie.bottomAnchor, constant: 8),
            textFieldCalorie.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textFieldCalorie.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            labelDate.topAnchor.constraint(equalTo: textFieldCalorie.bottomAnchor, constant: 16),
            labelDate.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            labelDate.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            textFieldDate.topAnchor.constraint(equalTo: labelDate.bottomAnchor, constant: 8),
            textFieldDate.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textFieldDate.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            labelDetails.topAnchor.constraint(equalTo: textFieldDate.bottomAnchor, constant: 16),
            labelDetails.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            labelDetails.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            textFieldDetails.topAnchor.constraint(equalTo: labelDetails.bottomAnchor, constant: 8),
            textFieldDetails.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textFieldDetails.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
