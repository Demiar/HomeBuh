//
//  RecordCollectionViewCell.swift
//  HomeBuh
//
//  Created by Алексей on 16.09.2021.
//

import UIKit

class RecordCollectionViewCell: UICollectionViewCell {
    var record: Record?
    
    var productTextField = SearchTextField()
    var priceTextField = UITextField()
    var categorySearchField = SearchTextField()
    var addViewButton = UIButton()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addCustomView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCustomView() {
        productTextField.placeholder = "Продукт"
        productTextField.textColor = .darkGray
        productTextField.borderStyle = .roundedRect
        self.addSubview(productTextField)

        priceTextField.placeholder = "Сумма"
        priceTextField.textColor = .darkGray
        priceTextField.borderStyle = .roundedRect
        self.addSubview(priceTextField)
        
        categorySearchField.placeholder = "Категория"
        categorySearchField.textColor = .darkGray
        categorySearchField.borderStyle = .roundedRect
        self.addSubview(categorySearchField)
        
        addViewButton.setTitle("Ещё", for: .normal)
        addViewButton.setTitleColor(.blue, for: .normal)
        self.addSubview(addViewButton)
        

    }
    
}

extension RecordCollectionViewCell {
    private func setConstraints() {
        productTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            productTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 2.0),
            productTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
        ])
        
        priceTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            priceTextField.topAnchor.constraint(equalTo: productTextField.bottomAnchor, constant: 10),
            priceTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            priceTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
        ])
        
        categorySearchField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categorySearchField.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 10),
            categorySearchField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            categorySearchField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
        ])
        
        addViewButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addViewButton.topAnchor.constraint(equalTo: categorySearchField.bottomAnchor, constant: 10),
            addViewButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 60),
            addViewButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -60),
            addViewButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2.0)
        ])
    }
}
