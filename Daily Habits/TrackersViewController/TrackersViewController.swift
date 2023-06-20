//
//  TrackersViewController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 15.06.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    // MARK: - Private Properties
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Трекеры"
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = .ypBlack
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    private let datePickerView: UIDatePicker = {
        let datePickerView = UIDatePicker()
        datePickerView.preferredDatePickerStyle = .compact
        datePickerView.datePickerMode = .date
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        return datePickerView
    }()

    private let searchField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.placeholder = "Поиск"
        searchField.translatesAutoresizingMaskIntoConstraints = false
        return searchField
    }()

    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        configureNavigationBar()
        configureCollectionView()
        makeLayout()
    }

    // MARK: - Private Methods
    private func configureNavigationBar() {
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: nil)
        leftBarButtonItem.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }

    private func makeLayout() {
        [titleLabel, datePickerView, searchField, collectionView].forEach({ view.addSubview($0) })

        let padding: CGFloat = 16

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),

            datePickerView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            datePickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),

            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),

            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CardCollectionViewCell
        cell?.configureCell()
        return cell ?? UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 167, height: 148)
    }
}
