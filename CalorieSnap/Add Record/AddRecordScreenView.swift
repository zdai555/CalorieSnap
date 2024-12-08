//
//  AddRecordScreenView.swift
//  CalorieSnap
//
//  Created by Yuk Yeung Ho on 5/12/2024.
//

import UIKit

class AddRecordScreenView: UIView {
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    
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
        
        setupScrollView()
        setupContentView()
        setupLabelName()
        setupTextFieldName()
        setupLabelCalorie()
        setupTextFieldCalorie()
        setupLabelDate()
        setupTextFieldDate()
        setupLabelDetails()
        setupTextFieldDetails()
        setupButtonTakePhoto()
        setupLabelPhoto()
        
        initConstraints()
        
        self.backgroundColor = .white
    }
    
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
    }
    
    func setupContentView() {
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
    }
    
    func setupLabelName() {
        labelName = UILabel()
        labelName.text = "Name"
        labelName.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelName)
    }
    
    func setupTextFieldName() {
        textFieldName = UITextField()
        textFieldName.placeholder = "Enter name"
        textFieldName.borderStyle = .roundedRect
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textFieldName)
    }
    
    func setupLabelCalorie() {
        labelCalorie = UILabel()
        labelCalorie.text = "Calories"
        labelCalorie.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        labelCalorie.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelCalorie)
    }
    
    func setupTextFieldCalorie() {
        textFieldCalorie = UITextField()
        textFieldCalorie.placeholder = "Enter calorie count"
        textFieldCalorie.borderStyle = .roundedRect
        textFieldCalorie.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textFieldCalorie)
    }
    
    func setupLabelDate() {
        labelDate = UILabel()
        labelDate.text = "Date"
        labelDate.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        labelDate.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelDate)
    }
    
    func setupTextFieldDate() {
        textFieldDate = UITextField()
        textFieldDate.placeholder = "Enter Date (MM/DD/YY)"
        textFieldDate.borderStyle = .roundedRect
        textFieldDate.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textFieldDate)
    }

    func setupLabelDetails() {
        labelDetails = UILabel()
        labelDetails.text = "Details"
        labelDetails.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        labelDetails.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelDetails)
    }
    
    func setupTextFieldDetails() {
        textFieldDetails = UITextField()
        textFieldDetails.placeholder = "Enter details"
        textFieldDetails.borderStyle = .roundedRect
        textFieldDetails.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textFieldDetails)
    }

    func setupButtonTakePhoto(){
        buttonTakePhoto = UIButton(type: .system)
        buttonTakePhoto.setTitle("", for: .normal)
        buttonTakePhoto.setImage(UIImage(systemName: "photo"), for: .normal)
        buttonTakePhoto.contentMode = .scaleAspectFit
        buttonTakePhoto.imageView?.contentMode = .scaleAspectFill
        buttonTakePhoto.clipsToBounds = true
        buttonTakePhoto.translatesAutoresizingMaskIntoConstraints = false
        buttonTakePhoto.showsMenuAsPrimaryAction = true
        contentView.addSubview(buttonTakePhoto)
    }
    
    func setupLabelPhoto() {
        labelPhoto = UILabel()
        labelPhoto.text = "Photo"
        labelPhoto.translatesAutoresizingMaskIntoConstraints = false
        labelPhoto.textColor = .gray
        labelPhoto.font = labelPhoto.font.withSize(16)
        contentView.addSubview(labelPhoto)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            labelName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            labelName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            textFieldName.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8),
            textFieldName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textFieldName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            buttonTakePhoto.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 16),
            buttonTakePhoto.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonTakePhoto.widthAnchor.constraint(equalToConstant: 100),
            buttonTakePhoto.heightAnchor.constraint(equalToConstant: 100),
            
            labelPhoto.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            labelPhoto.topAnchor.constraint(equalTo: buttonTakePhoto.bottomAnchor, constant: 8),
            
            labelCalorie.topAnchor.constraint(equalTo: labelPhoto.bottomAnchor, constant: 16),
            labelCalorie.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelCalorie.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            textFieldCalorie.topAnchor.constraint(equalTo: labelCalorie.bottomAnchor, constant: 8),
            textFieldCalorie.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textFieldCalorie.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            labelDate.topAnchor.constraint(equalTo: textFieldCalorie.bottomAnchor, constant: 16),
            labelDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelDate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            textFieldDate.topAnchor.constraint(equalTo: labelDate.bottomAnchor, constant: 8),
            textFieldDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textFieldDate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            labelDetails.topAnchor.constraint(equalTo: textFieldDate.bottomAnchor, constant: 16),
            labelDetails.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelDetails.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            textFieldDetails.topAnchor.constraint(equalTo: labelDetails.bottomAnchor, constant: 8),
            textFieldDetails.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textFieldDetails.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textFieldDetails.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
