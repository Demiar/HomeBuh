//
//  DetailRecordViewController.swift
//  HomeBuh
//
//  Created by Алексей on 20.07.2021.
//

import UIKit

class DetailRecordViewController: UIViewController, UITextFieldDelegate {
    
    var categories: [Category] = []
    var products: [Product] = []
    var record: Record?
    var update = false
    var categoryType: Bool = false
    var dataManager = DataManager.shared

    private var recordView: RecordView?
    
    private lazy var datePicker: UIDatePicker = UIDatePicker()
    private lazy var datePickerValue: Date = Date()
 
    private let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 800)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton().customButton(colorButton: UIColor(
                                                red: 21 / 255,
                                                green: 101 / 255,
                                                blue: 192 / 255,
                                                alpha: 1
                                            ),
                                            title: "Сохранить",
                                            font: .boldSystemFont(ofSize: 18),
                                            colorTitle: .white,
                                            cornerRadius: 4
                                            )
            button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton().customButton(colorButton: .red,
                                            title: "Отмена",
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
        recordView = RecordView(categoryType: categoryType)
        guard let recordView = recordView else { return }
        recordView.categoryType = categoryType
        categories = dataManager.fetchCategories(type: categoryType)
        products = dataManager.fetchProducts()
        self.view.addSubview(scrollView)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        datePickerValue = datePicker.date
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        recordView.productCount.text = "1"
        setupViews([recordView, datePicker, saveButton, cancelButton])
        setConstraints()
        
        var filterString = [""]
        for product in products {
            filterString.append(product.title ?? "")
        }
        recordView.productTextField.filterStrings(filterString)
        filterString = [""]
        for category in categories {
            filterString.append(category.title ?? "")
        }
        recordView.categorySearchField.filterStrings(filterString)
        
        recordView.productTextField.becomeFirstResponder()
        if update == true {
            guard let record = record else { return }
            recordView.categoryType = record.type
            recordView.productTextField.text = record.product?.title
            recordView.priceTextField.text = String(record.price)
            recordView.categorySearchField.text = record.category?.title
            recordView.productCount.text = String(record.count)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.locale = .current
            datePicker.date = record.date ?? Date()
            datePickerValue = record.date ?? Date()

            
        }
    }

    
    private func setupViews(_ views: [UIView]) {
        views.forEach {
            scrollView.addSubview($0)
        }
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        datePickerValue = sender.date
    }

    
    @objc private func save() {
        guard let recordView = recordView else { return }
        if recordView.priceTextField.text == "" { return }
        guard let price = recordView.priceTextField.text else { return }
        if categories.isEmpty { return }
        if update {
            guard let record = record else { return }
            dataManager.updateRecord(product: recordView.productTextField.text ?? "no product",
                                            record: record,
                                            price: Double(price)!,
                                            type: categoryType,//typeSegmentedControl.selectedSegmentIndex,
                                            category: recordView.categorySearchField.text ?? "no category",//categories[selectedPicker],
                                            date: datePickerValue,
                                            count: Double(recordView.productCount.text ?? "") ?? 1.0
            )
        } else {
            dataManager.saveRecord(product: recordView.productTextField.text ?? "no product",
                                          price: Double(price)!,
                                          type: categoryType,//typeSegmentedControl.selectedSegmentIndex,
                                          category: recordView.categorySearchField.text ?? "no category",//categories[selectedPicker],
                                          date: datePickerValue,
                                          count: Double(recordView.productCount.text ?? "") ?? 1.0
            )
        }

        dismiss(animated: true)
    }

    @objc private func cancel() {
        dismiss(animated: true)
    }
    
    @objc private func addView() {
        dismiss(animated: true)
    }
    
}


// MARK: Constraints
extension DetailRecordViewController {
    private func setConstraints() {
        guard let recordView = recordView else { return }
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 2.0),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 2.0),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -2.0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2.0)
        ])
        
        recordView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recordView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 80),
            recordView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            recordView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: recordView.bottomAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])

        saveButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
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
