//
//  ProfileDetailsView.swift
//  CalorieSnap
//
//  Created by Steph on 6/12/2024.
//

import UIKit

class ProfileDetailsView: UIView {
    let scrollView = UIScrollView()
    let contentView = UIView()
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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        labelName.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelName)

        labelAge.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        labelAge.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelAge)

        labelGender.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        labelGender.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelGender)

        labelPronouns.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        labelPronouns.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelPronouns)

        labelCalorieTarget.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        labelCalorieTarget.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelCalorieTarget)

        labelFavoriteFood.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        labelFavoriteFood.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelFavoriteFood)

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

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),

            labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            labelName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            labelAge.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8),
            labelAge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelAge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            labelGender.topAnchor.constraint(equalTo: labelAge.bottomAnchor, constant: 8),
            labelGender.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelGender.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            labelPronouns.topAnchor.constraint(equalTo: labelGender.bottomAnchor, constant: 8),
            labelPronouns.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelPronouns.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            labelCalorieTarget.topAnchor.constraint(equalTo: labelPronouns.bottomAnchor, constant: 8),
            labelCalorieTarget.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelCalorieTarget.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            labelFavoriteFood.topAnchor.constraint(equalTo: labelCalorieTarget.bottomAnchor, constant: 8),
            labelFavoriteFood.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelFavoriteFood.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            labelFavoriteFood.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
