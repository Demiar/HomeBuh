//
//  RecordView.swift
//  HomeBuh
//
//  Created by Алексей on 13.09.2021.
//

import UIKit

class RecordView: UIView {
    var record: Record?
    var categoryType: Bool 
    
    var productTextField = SearchTextField()
    var productCount = UITextField()
    var priceTextField = UITextField()
    var categorySearchField = SearchTextField()
    var addViewButton = UIButton()
    var stackView = UIStackView()
    
    init(categoryType: Bool) {
        self.categoryType = categoryType
        super.init(frame: CGRect())
        self.addCustomView()
        setConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCustomView() {
        //print(categoryType)
        productTextField.placeholder = "Продукт"
        productTextField.textColor = .darkGray
        productTextField.borderStyle = .roundedRect
        //self.addSubview(productTextField)
        
        productCount.placeholder = "Количество"
        productCount.text = "1"
        productCount.textColor = .darkGray
        productCount.borderStyle = .roundedRect
        productCount.keyboardType = .decimalPad

        priceTextField.placeholder = "Сумма"
        priceTextField.textColor = .darkGray
        priceTextField.borderStyle = .roundedRect
        priceTextField.keyboardType = .decimalPad
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution  = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 30
        stackView.addArrangedSubview(productCount)
        stackView.addArrangedSubview(priceTextField)
        //self.addSubview(stackView)
        
        categorySearchField.placeholder = "Категория"
        categorySearchField.textColor = .darkGray
        categorySearchField.borderStyle = .roundedRect
        //self.addSubview(categorySearchField)
        
        addViewButton.setTitle("Ещё", for: .normal)
        addViewButton.setTitleColor(.blue, for: .normal)
        //self.addSubview(addViewButton)
        
        if categoryType {
            setupViews([productTextField, priceTextField, categorySearchField])
        } else {
            setupViews([productTextField, stackView, categorySearchField])
        }
    }
    
    private func setupViews(_ views: [UIView]) {
        views.forEach {
            self.addSubview($0)
        }
    }
    
}

extension RecordView {
    private func setConstraints() {
        productTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            productTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 2.0),
            productTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
        ])
        if categoryType {
            priceTextField.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                priceTextField.topAnchor.constraint(equalTo: productTextField.bottomAnchor, constant: 10),
                priceTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
                priceTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
            ])
        } else {
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: productTextField.bottomAnchor, constant: 10),
                stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
                stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            ])
        }

        

        
        categorySearchField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categorySearchField.topAnchor.constraint(equalTo: (categoryType ? priceTextField : stackView).bottomAnchor, constant: 10),
            categorySearchField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            categorySearchField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            categorySearchField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2.0)
        ])
        
//        addViewButton.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            addViewButton.topAnchor.constraint(equalTo: categorySearchField.bottomAnchor, constant: 10),
//            addViewButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 60),
//            addViewButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -60),
//            addViewButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2.0)
//        ])
    }
}
