//
//  DataManger.swift
//  HomeBuh
//
//  Created by Алексей on 20.07.2021.
//

import UIKit
import CoreData

class DataManager {
    static var shared = DataManager()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getSectionData() -> [SectionData] {
        var result = [SectionData]()
        let data = getData()
        let sortedData = data.sorted(by: { $0.0 > $1.0 })
        for (key, value) in sortedData {
            result.append(SectionData(sectionName: key, sectionObjects: value))
        }
        return result
    }
    
    func fetchData() -> [Record]{
        var records: [Record] = []
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()

        do {
            records = try context.fetch(fetchRequest)
            return records
        } catch let error {
            print(error)
        }
        return records
    }
    
    func getSections() -> Set<Date> {
        var sections: Set<Date> = []
        let records = fetchData()
        for record in records {
            sections.insert(record.date!)
        }
        return sections
    }
    
    func getData() -> Dictionary<String, [Record]> {
        var result = Dictionary<String, [Record]>()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale(identifier: "ru_RU")
        //let dateString = dateFormatter.string(from: key)
        
        let records = fetchData()
        for record in records {
            let dateString = dateFormatter.string(from: record.date!)
            result[dateString, default: [Record]()].append(record)
        }
        return result
    }
    
    func fetchCategories(type: Bool? = nil) -> [Category] {
        var categories: [Category] = []
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        if let poisk = type {
            fetchRequest.predicate = NSPredicate(format: "type == %@", NSNumber(booleanLiteral: poisk))
        }
        
        // true = prixod, false = rasxod
        do {
            categories = try context.fetch(fetchRequest)
            return categories
        } catch let error {
            print(error)
        }
        return categories
    }
    
    func fetchProducts() -> [Product] {
        var products: [Product] = []
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()

        do {
            products = try context.fetch(fetchRequest)
            return products
        } catch let error {
            print(error)
        }
        return products
    }
    
    func fetchProduct(title: String) -> [Product] {
        var product: [Product] = []
        let fetchRequest = NSFetchRequest<Product>(entityName: "Product")
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)

        do {
            product = try context.fetch(fetchRequest)
            return product
        } catch let error {
            print(error)
        }
        return product
    }
    
    func saveRecord(product: String, price: Double, type: Int, category: Category, date: Date) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Record", in: context) else { return }
        guard let record = NSManagedObject(entity: entityDescription, insertInto: context) as? Record else { return }
        var prod = fetchProduct(title: product)
        if prod.isEmpty {
            saveProduct(title: product)
            prod = fetchProduct(title: product)
        }
        record.product = prod[0]
        record.category = category
        record.date = date
        record.price = price
        record.type = (type == 0) ? false : true
        //record.type = Boolean(type)

        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    func updateRecord(product: String, record: Record, price: Double, type: Int, category: Category, date: Date) {
        var prod = fetchProduct(title: product)
        if prod.isEmpty {
            saveProduct(title: product)
            prod = fetchProduct(title: product)
        }
        record.product = prod[0]
        record.category = category
        record.date = date
        record.price = price
        record.type = (type == 0) ? false : true

        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    func saveCategory(title: String, type: Int) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Category", in: context) else { return }
        guard let category = NSManagedObject(entity: entityDescription, insertInto: context) as? Category else { return }
        category.title = title
        //category.type = type
        category.type = (type == 0) ? false : true
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    func saveProduct(title: String) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Product", in: context) else { return }
        guard let product = NSManagedObject(entity: entityDescription, insertInto: context) as? Product else { return }
        product.title = title

        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    func updateCategory(category: Category, title: String, type: Int) {
        category.title = title
        category.type = (type == 0) ? false : true
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    func deleteTask(record: Record) {
        context.delete(record)
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    func deleteCategory(category: Category) {
        context.delete(category)
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
}

