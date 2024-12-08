//
//  Untitled.swift
//  CalorieSnap
//
//  Created by Steph on 6/12/2024.
//

import UIKit

class CreateProfileView: UIView {
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let labelName = UILabel()
    let textFieldName = UITextField()
    
    let labelAge = UILabel()
    let textFieldAge = UITextField()
    
    let labelGender = UILabel()
    let textFieldGender = UITextField()
    
    let labelPronouns = UILabel()
    let textFieldPronouns = UITextField()
    
    let labelCalorieTarget = UILabel()
    let textFieldCalorieTarget = UITextField()
    
    let labelFavoriteFood = UILabel()
    let textFieldFavoriteFood = UITextField()
    
    let labelPhoto = UILabel()
    let buttonTakePhoto = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        labelName.text = "Display Name"
        labelName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelName)
        
        textFieldName.borderStyle = .roundedRect
        textFieldName.placeholder = "Enter name"
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textFieldName)

        labelAge.text = "Age"
        labelAge.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelAge)
        
        textFieldAge.borderStyle = .roundedRect
        textFieldAge.placeholder = "Enter age"
        textFieldAge.keyboardType = .numberPad
        textFieldAge.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textFieldAge)

        labelGender.text = "Gender"
        labelGender.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelGender)
        
        textFieldGender.borderStyle = .roundedRect
        textFieldGender.placeholder = "Enter gender"
        textFieldGender.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textFieldGender)

        labelPronouns.text = "Pronouns"
        labelPronouns.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelPronouns)
        
        textFieldPronouns.borderStyle = .roundedRect
        textFieldPronouns.placeholder = "Enter pronouns"
        textFieldPronouns.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textFieldPronouns)

        labelCalorieTarget.text = "Targeted Calorie Intake"
        labelCalorieTarget.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelCalorieTarget)
        
        textFieldCalorieTarget.borderStyle = .roundedRect
        textFieldCalorieTarget.placeholder = "Enter calorie target"
        textFieldCalorieTarget.keyboardType = .numberPad
        textFieldCalorieTarget.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textFieldCalorieTarget)

        labelFavoriteFood.text = "Favorite Food"
        labelFavoriteFood.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelFavoriteFood)
        
        textFieldFavoriteFood.borderStyle = .roundedRect
        textFieldFavoriteFood.placeholder = "Enter favorite food"
        textFieldFavoriteFood.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textFieldFavoriteFood)

        labelPhoto.text = "Profile Photo"
        labelPhoto.textColor = .gray
        labelPhoto.font = labelPhoto.font.withSize(16)
        labelPhoto.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelPhoto)

        buttonTakePhoto.setTitle("", for: .normal)
        buttonTakePhoto.contentMode = .scaleAspectFit
        buttonTakePhoto.imageView?.contentMode = .scaleAspectFill
        buttonTakePhoto.clipsToBounds = true
        buttonTakePhoto.translatesAutoresizingMaskIntoConstraints = false
        buttonTakePhoto.showsMenuAsPrimaryAction = true
        contentView.addSubview(buttonTakePhoto)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            buttonTakePhoto.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            buttonTakePhoto.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonTakePhoto.widthAnchor.constraint(equalToConstant: 100),
            buttonTakePhoto.heightAnchor.constraint(equalToConstant: 100),
            
            labelPhoto.topAnchor.constraint(equalTo: buttonTakePhoto.bottomAnchor, constant: 8),
            labelPhoto.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            labelName.topAnchor.constraint(equalTo: labelPhoto.bottomAnchor, constant: 8),
            labelName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            textFieldName.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8),
            textFieldName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textFieldName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textFieldName.heightAnchor.constraint(equalToConstant: 40),

            labelAge.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 20),
            labelAge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            textFieldAge.topAnchor.constraint(equalTo: labelAge.bottomAnchor, constant: 8),
            textFieldAge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textFieldAge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textFieldAge.heightAnchor.constraint(equalToConstant: 40),

            labelGender.topAnchor.constraint(equalTo: textFieldAge.bottomAnchor, constant: 20),
            labelGender.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            textFieldGender.topAnchor.constraint(equalTo: labelGender.bottomAnchor, constant: 8),
            textFieldGender.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textFieldGender.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textFieldGender.heightAnchor.constraint(equalToConstant: 40),

            labelPronouns.topAnchor.constraint(equalTo: textFieldGender.bottomAnchor, constant: 20),
            labelPronouns.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            textFieldPronouns.topAnchor.constraint(equalTo: labelPronouns.bottomAnchor, constant: 8),
            textFieldPronouns.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textFieldPronouns.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textFieldPronouns.heightAnchor.constraint(equalToConstant: 40),

            labelCalorieTarget.topAnchor.constraint(equalTo: textFieldPronouns.bottomAnchor, constant: 20),
            labelCalorieTarget.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            textFieldCalorieTarget.topAnchor.constraint(equalTo: labelCalorieTarget.bottomAnchor, constant: 8),
            textFieldCalorieTarget.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textFieldCalorieTarget.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textFieldCalorieTarget.heightAnchor.constraint(equalToConstant: 40),

            labelFavoriteFood.topAnchor.constraint(equalTo: textFieldCalorieTarget.bottomAnchor, constant: 20),
            labelFavoriteFood.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            textFieldFavoriteFood.topAnchor.constraint(equalTo: labelFavoriteFood.bottomAnchor, constant: 8),
            textFieldFavoriteFood.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textFieldFavoriteFood.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textFieldFavoriteFood.heightAnchor.constraint(equalToConstant: 40),
            
            textFieldFavoriteFood.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
