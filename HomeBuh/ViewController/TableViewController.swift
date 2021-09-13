//
//  TableViewController.swift
//  HomeBuh
//
//  Created by Алексей on 20.07.2021.
//

import UIKit

class TableViewController: UITableViewController {
    private let cellId = "cell"
    private var categories: [Category] = DataManager.shared.fetchCategories()
    private var sectionData: [SectionData] = DataManager.shared.getSectionData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        setupNavigationBar()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData[section].sectionObjects.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionData[section].sectionName
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath)
        cell.selectionStyle = .none
        
        let record = sectionData[indexPath.section].sectionObjects[indexPath.row]

        var content = cell.defaultContentConfiguration()
        if record.type {
            content.image = UIImage(systemName: "plus")?.withTintColor(.green, renderingMode: .alwaysOriginal)
        } else {
            content.image = UIImage(systemName: "minus")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        }
        if let category = record.category {
            content.secondaryText = category.title
        } else {
            content.secondaryText = "no category"
        }
        if let product = record.product {
            content.text = "\(product.title ?? "no product") \(String(record.price)) Руб"
        } else {
            content.text = "no product \(String(record.price)) Руб"
        }

        cell.contentConfiguration = content

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataManager.shared.deleteTask(record: sectionData[indexPath.section].sectionObjects[indexPath.row])
            sectionData[indexPath.section].sectionObjects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if sectionData[indexPath.section].sectionObjects.isEmpty == true {
                tableView.beginUpdates()
                sectionData.remove(at: indexPath.section)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .left)
                tableView.endUpdates()
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            let detailRecord = DetailRecordViewController()
            detailRecord.modalPresentationStyle = .fullScreen
            present(detailRecord, animated: true)
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailRecord = DetailRecordViewController()
        detailRecord.modalPresentationStyle = .fullScreen
        detailRecord.update = true
        detailRecord.categoryType = sectionData[indexPath.section].sectionObjects[indexPath.row].type
        detailRecord.record = sectionData[indexPath.section].sectionObjects[indexPath.row]
        present(detailRecord, animated: true)
    }
    
    
    private func setupNavigationBar() {
        title = "Record List"
        navigationController?.navigationBar.prefersLargeTitles = true

        // Navigation bar appeareance
        let navBarAppereance = UINavigationBarAppearance()
        navBarAppereance.configureWithOpaqueBackground()

        navBarAppereance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppereance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navBarAppereance.backgroundColor = UIColor(
            red: 21 / 255,
            green: 101 / 255,
            blue: 192 / 255,
            alpha: 194 / 255
        )

        navigationController?.navigationBar.standardAppearance = navBarAppereance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppereance
        let rightBarButtonItem = UIBarButtonItem()
        rightBarButtonItem.primaryAction = UIAction(){ [self]_ in
            addNewRecord(categoryType: true)
        }
        rightBarButtonItem.image = UIImage(systemName: "plus")
        navigationItem.rightBarButtonItem = rightBarButtonItem
        let leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.primaryAction = UIAction(){ [self]_ in
            addNewRecord(categoryType: false)
        }
        leftBarButtonItem.image = UIImage(systemName: "minus")
        navigationItem.leftBarButtonItem = leftBarButtonItem

        navigationController?.navigationBar.tintColor = .white
    }

    private func addNewRecord(categoryType: Bool = true) {
        let detailRecord = DetailRecordViewController()
        detailRecord.modalPresentationStyle = .fullScreen
        detailRecord.categoryType = categoryType
        present(detailRecord, animated: true)
    }
    
}
