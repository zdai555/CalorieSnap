//
//  ProfileDetailsView.swift
//  CalorieSnap
//
//  Created by Steph on 6/12/2024.
//

import UIKit

class ProfileDetailsView: UIView {
    let imageView = UIImageView()
    let labelName = UILabel()
    let labelAge = UILabel()
    let labelGender = UILabel()
    let labelPronouns = UILabel()
    let labelCalorieTarget = UILabel()
    let labelFavoriteFood = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        labelName.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelName)

        labelAge.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        labelAge.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelAge)

        labelGender.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        labelGender.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelGender)

        labelPronouns.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        labelPronouns.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelPronouns)

        labelCalorieTarget.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        labelCalorieTarget.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelCalorieTarget)

        labelFavoriteFood.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        labelFavoriteFood.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelFavoriteFood)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),

            labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            labelName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            labelAge.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8),
            labelAge.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelAge.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            labelGender.topAnchor.constraint(equalTo: labelAge.bottomAnchor, constant: 8),
            labelGender.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelGender.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            labelPronouns.topAnchor.constraint(equalTo: labelGender.bottomAnchor, constant: 8),
            labelPronouns.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelPronouns.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            labelCalorieTarget.topAnchor.constraint(equalTo: labelPronouns.bottomAnchor, constant: 8),
            labelCalorieTarget.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelCalorieTarget.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            labelFavoriteFood.topAnchor.constraint(equalTo: labelCalorieTarget.bottomAnchor, constant: 8),
            labelFavoriteFood.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelFavoriteFood.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
