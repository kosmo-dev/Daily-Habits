//
//  StatisticCellView.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 09.08.2023.
//

import UIKit

class StatisticCellView: UIView {
    private let gradientView: UIView = {
        let gradientView = UIView()
        gradientView.layer.cornerRadius = 16
        gradientView.layer.masksToBounds = true
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        return gradientView
    }()

    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.colorSelection1.cgColor, UIColor.colorSelection9.cgColor, UIColor.colorSelection3.cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        return gradientLayer
    }()

    private let counterLabel: UILabel = {
        let counterLabel = UILabel()
        counterLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        counterLabel.textColor = .ypBlack
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        return counterLabel
    }()

    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        descriptionLabel.textColor = .ypBlack
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()

    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.layer.cornerRadius = 16
        backgroundView.layer.masksToBounds = true
        backgroundView.backgroundColor = .ypWhite
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        layer.masksToBounds = true
        backgroundColor = .ypWhite
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = gradientView.bounds
    }

    func configureCell(counterText: String, desciptionText: String) {
        counterLabel.text = counterText
        descriptionLabel.text = desciptionText
    }

    private func configureView() {
        addSubview(gradientView)
        gradientView.layer.addSublayer(gradientLayer)
        gradientView.addSubview(backgroundView)
        backgroundView.addSubview(counterLabel)
        backgroundView.addSubview(descriptionLabel)

        let borderWidth: CGFloat = 1

        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),

            backgroundView.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: borderWidth),
            backgroundView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: borderWidth),
            backgroundView.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -borderWidth),
            backgroundView.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -borderWidth),

            counterLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 12),
            counterLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 12),
            counterLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -12),

            descriptionLabel.topAnchor.constraint(equalTo: counterLabel.bottomAnchor, constant: 7),
            descriptionLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -12),
            descriptionLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -12)
        ])
    }
}
