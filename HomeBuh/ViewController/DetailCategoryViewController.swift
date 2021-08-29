//
//  DetailCategoryViewController.swift
//  HomeBuh
//
//  Created by Алексей on 21.07.2021.
//

import UIKit

class DetailCategoryViewController: UIViewController {
    var update = false
    var category: Category?
    
    private lazy var typeSegmentedControl: UISegmentedControl = UISegmentedControl(items: ["Расход", "Приход"])
        
    private lazy var categoryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "New category"
        textField.textColor = .darkGray
        textField.borderStyle = .roundedRect
        return textField
    }()
        
    private lazy var saveButton: UIButton = {
        let button = UIButton().customButton(colorButton: UIColor(
                                                red: 21 / 255,
                                                green: 101 / 255,
                                                blue: 192 / 255,
                                                alpha: 1
                                            ),
                                            title: "Save category",
                                            font: .boldSystemFont(ofSize: 18),
                                            colorTitle: .white,
                                            cornerRadius: 4
                                            )
            button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton().customButton(colorButton: .red,
                                            title: "Cancel Task",
                                            font: .boldSystemFont(ofSize: 18),
                                            colorTitle: .white,
                                            cornerRadius: 4
                                            )
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        if update {
            categoryTextField.text = category?.title
            if ((category?.type) != nil) {
                typeSegmentedControl.selectedSegmentIndex = 1
            } else {
                typeSegmentedControl.selectedSegmentIndex = 0
            }
        }
        categoryTextField.becomeFirstResponder()
        
        setupViews([typeSegmentedControl, categoryTextField, saveButton, cancelButton])
        setConstraints()
    }
    

    private func setupViews(_ views: [UIView]) {
        views.forEach { view.addSubview($0) }
    }
        
    @objc private func save() {
        if categoryTextField.text == "" { return }
        guard let text = categoryTextField.text else { return }
        if update {
            guard let category = category else { return }
            DataManager.shared.updateCategory(category: category,
                                              title: text,
                                              type: typeSegmentedControl.selectedSegmentIndex
            )
        } else {
            DataManager.shared.saveCategory(title: text,
                                            type: typeSegmentedControl.selectedSegmentIndex
            )
        }
        
        dismiss(animated: true)
    }

    @objc private func cancel() {
        dismiss(animated: true)
    }
}


// MARK: Set Contstraints
extension DetailCategoryViewController {
    private func setConstraints() {
        categoryTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            categoryTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            categoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            categoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        typeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            typeSegmentedControl.topAnchor.constraint(equalTo: categoryTextField.topAnchor, constant: 80),
            typeSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            typeSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])

        saveButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: typeSegmentedControl.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])

        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}
