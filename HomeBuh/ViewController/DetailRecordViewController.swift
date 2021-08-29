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
    
    private lazy var categoriesPicker: UIPickerView = UIPickerView()
    private lazy var datePickerValue: Date = Date()

    private lazy var selectedPicker: Int = 0

    private lazy var typeSegmentedControl: UISegmentedControl = UISegmentedControl(items: ["Приход", "Расход"])
    
    private let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 800)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private var datePicker: UIDatePicker = UIDatePicker()
    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Сумма"
        textField.textColor = .darkGray
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var searchField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Товар"
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
        categories = DataManager.shared.fetchCategories(type: categoryType)
        products = DataManager.shared.fetchProducts()
        self.view.addSubview(scrollView)
        typeSegmentedControl.selectedSegmentIndex = 1
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        datePickerValue = datePicker.date
        self.categoriesPicker.dataSource = self
        self.categoriesPicker.delegate = self
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        setupViews([searchField, taskTextField, categoriesPicker, datePicker, typeSegmentedControl, saveButton, cancelButton])
        setConstraints()
        
        searchField.becomeFirstResponder()
        if update == true {
            guard let record = record else { return }
            searchField.text = record.product?.title
            taskTextField.text = String(record.price)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.locale = .current
            datePicker.date = record.date ?? Date()
            datePickerValue = record.date ?? Date()
            for i in 0...categories.count {
                if categories[i].title == record.category?.title {
                    categoriesPicker.selectRow(i, inComponent: 0, animated: true)
                    break
                }
            }
            if record.type {
                typeSegmentedControl.selectedSegmentIndex = 1
            } else {
                typeSegmentedControl.selectedSegmentIndex = 0
            }
            
        }
    }
    
    private func setupViews(_ views: [UIView]) {
        views.forEach {
            scrollView.addSubview($0)
        }
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        datePickerValue = sender.date
        print("Selected value \(selectedDate)")
    }

    
    @objc private func save() {
        if taskTextField.text == "" { return }
        guard let text = taskTextField.text else { return }
        if update {
            guard let record = record else { return }
            DataManager.shared.updateRecord(product: searchField.text ?? "no product",
                                            record: record,
                                            price: Double(text)!,
                                            type: typeSegmentedControl.selectedSegmentIndex,
                                            category: categories[selectedPicker],
                                            date: datePickerValue
            )
        } else {
            DataManager.shared.saveRecord(product: searchField.text ?? "no product",
                                          price: Double(text)!,
                                          type: typeSegmentedControl.selectedSegmentIndex,
                                          category: categories[selectedPicker],
                                          date: datePickerValue
            )
        }

        dismiss(animated: true)
    }

    @objc private func cancel() {
        dismiss(animated: true)
    }
    
//    private func removeTimeStamp(fromDate: Date) -> Date {
//        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
//            fatalError("Failed to strip time from Date object")
//        }
//        return date
//    }
}


// MARK: Constraints
extension DetailRecordViewController {
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 2.0),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 2.0),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -2.0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2.0)
        ])
        
        searchField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 80),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        taskTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: searchField.topAnchor, constant: 80),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        categoriesPicker.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            categoriesPicker.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 20),
            categoriesPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            categoriesPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: categoriesPicker.bottomAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        typeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            typeSegmentedControl.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
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


// MARK: UIPicker
extension DetailRecordViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPicker = row
    }
}
