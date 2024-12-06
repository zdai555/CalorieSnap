//
//  RecordDetailsViewController.swift
//  CalorieSnap
//
//  Created by Yuk Yeung Ho on 6/12/2024.
//

import UIKit

class RecordDetailsViewController: UIViewController {
    var onRecordUpdated: ((Record) -> Void)?
    private let detailsView = RecordDetailsView()
    private var record: Record

    init(record: Record) {
        self.record = record
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = detailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Item Details"
        setupNavigationBar()
        populateDetails()
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
    }

    @objc private func editButtonTapped() {
        let editVC = EditRecordViewController(record: record)
        editVC.onRecordUpdated = { [weak self] updatedRecord in
            self?.record = updatedRecord
            self?.populateDetails()
            self?.onRecordUpdated?(updatedRecord)
        }
        navigationController?.pushViewController(editVC, animated: true)
    }



    private func populateDetails() {
        detailsView.labelName.text = "Name: \(record.name)"
        detailsView.labelCalories.text = "Calories: \(record.calorie) kcal"
        detailsView.labelDetails.text = "Details: \(record.details)"

        if let photoURLString = record.photoURL, let photoURL = URL(string: photoURLString) {
            detailsView.imageRecord.loadRemoteImage(from: photoURL) 
        } else {
            detailsView.imageRecord.image = UIImage(systemName: "photo")
        }
    }
}
