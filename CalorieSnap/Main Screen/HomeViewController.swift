//
//  ContactsTableViewCell.swift
//  CalorieSnap
//
//  Created by Steph on 2/11/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {
    private let db = Firestore.firestore()
    private let currentUserId = Auth.auth().currentUser?.uid ?? ""
    
    private let tableViewRecords = UITableView()
    private var records = [Record]()
    
    private let bottomNavigationView = UIView()
    private let homeButton = UIButton(type: .system)
    private let profileButton = UIButton(type: .system)
    private let communityButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "My Food Records"
        
        setupTableView()
        setupBottomNavigationView()
        setupNavigationBarButtons()
        loadRecords()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupNavigationBarButtons() {
        let addButton = UIBarButtonItem(title: "New Record", style: .plain, target: self, action: #selector(addRecordTapped))
        self.navigationItem.rightBarButtonItem = addButton
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped))
        self.navigationItem.leftBarButtonItem = logoutButton
    }
    
    @objc func logoutButtonTapped() {
        showLogoutConfirmation()
    }
    
    func showLogoutConfirmation() {
        let alertController = UIAlertController(
            title: "Confirm Logout",
            message: "Are you sure you want to log out?",
            preferredStyle: .alert
        )
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.logoutUser()
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func logoutUser() {
        do {
            try Auth.auth().signOut()
            let loginVC = LoginViewController()
            let navController = UINavigationController(rootViewController: loginVC)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    window.rootViewController = navController
                    window.makeKeyAndVisible()
                }
            }
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    private func setupTableView() {
        tableViewRecords.translatesAutoresizingMaskIntoConstraints = false
        tableViewRecords.delegate = self
        tableViewRecords.dataSource = self
        tableViewRecords.register(RecordsTableViewCell.self, forCellReuseIdentifier: "RecordsTableViewCell")
        
        view.addSubview(tableViewRecords)
        
        NSLayoutConstraint.activate([
            tableViewRecords.topAnchor.constraint(equalTo: view.topAnchor),
            tableViewRecords.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            tableViewRecords.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewRecords.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupBottomNavigationView() {
        bottomNavigationView.backgroundColor = .white
        bottomNavigationView.layer.shadowColor = UIColor.black.cgColor
        bottomNavigationView.layer.shadowOpacity = 0.1
        bottomNavigationView.layer.shadowOffset = CGSize(width: 0, height: -2)
        bottomNavigationView.layer.shadowRadius = 4
        bottomNavigationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomNavigationView)
        
        let buttonStackView = UIStackView(arrangedSubviews: [homeButton, profileButton, communityButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.alignment = .center
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomNavigationView.addSubview(buttonStackView)
        
        homeButton.setTitle("Calorie Record", for: .normal)
        homeButton.setImage(UIImage(systemName: "house"), for: .normal)
        homeButton.tintColor = .systemBlue
        homeButton.addTarget(self, action: #selector(navigateToHome), for: .touchUpInside)
        
        profileButton.setTitle("Profile", for: .normal)
        profileButton.setImage(UIImage(systemName: "person.circle"), for: .normal)
        profileButton.tintColor = .systemBlue
        profileButton.addTarget(self, action: #selector(navigateToProfile), for: .touchUpInside)
        
        communityButton.setTitle("Community", for: .normal)
        communityButton.setImage(UIImage(systemName: "message"), for: .normal)
        communityButton.tintColor = .systemBlue
        communityButton.addTarget(self, action: #selector(navigateToCommunity), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            bottomNavigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomNavigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomNavigationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomNavigationView.heightAnchor.constraint(equalToConstant: 60),
            
            buttonStackView.topAnchor.constraint(equalTo: bottomNavigationView.topAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: bottomNavigationView.bottomAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: bottomNavigationView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: bottomNavigationView.trailingAnchor)
        ])
    }
    
    @objc func navigateToHome() {
        print("Stay on Home Page")
    }
    
    @objc func navigateToProfile() {
        let profileDetailsVC = ProfileDetailsViewController()
        navigationController?.pushViewController(profileDetailsVC, animated: true)
    }
    
    @objc func navigateToCommunity() {
        let communityVC = CommunityViewController()
        navigationController?.pushViewController(communityVC, animated: true)
    }
    
    @objc private func addRecordTapped() {
        let addVC = AddRecordViewController()
        addVC.onRecordAdded = { [weak self] newRecord in
            self?.records.insert(newRecord, at: 0)
            self?.tableViewRecords.reloadData()
        }
        navigationController?.pushViewController(addVC, animated: true)
    }

    private func loadRecords() {
        db.collection("users")
            .document(currentUserId)
            .collection("records")
            .order(by: "timestamp", descending: true)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error loading records: \(error.localizedDescription)")
                    return
                }
                
                self?.records = snapshot?.documents.compactMap { document in
                    try? document.data(as: Record.self)
                } ?? []
                
                DispatchQueue.main.async {
                    self?.tableViewRecords.reloadData()
                }
            }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let record = records[indexPath.row]
        let detailsVC = RecordDetailsViewController(record: record)
        detailsVC.onRecordUpdated = { [weak self] updatedRecord in
            guard let self = self else { return }
            if let index = self.records.firstIndex(where: { $0.id == updatedRecord.id }) {
                self.records[index] = updatedRecord
                self.tableViewRecords.reloadData()
            }
        }
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecordsTableViewCell", for: indexPath) as? RecordsTableViewCell else {
            return UITableViewCell()
        }

        let record = records[indexPath.row]
        cell.configure(with: record)
        return cell
    }
}
