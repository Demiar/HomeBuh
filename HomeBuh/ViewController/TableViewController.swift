//
//  TableViewController.swift
//  HomeBuh
//
//  Created by Алексей on 20.07.2021.
//

import UIKit

class TableViewController: UITableViewController {
    private let cellId = "cell"
    private var categories: [Category] = []
    private var sectionData = [SectionData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        sectionData = DataManager.shared.getSectionData()
        
        categories = DataManager.shared.fetchCategories()
        setupNavigationBar()
        tableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionData[section].sectionObjects.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let test = DateFormatter()//sectionData[section].sectionName
        test.dateStyle = .short
        let result = sectionData[section].sectionName
        return result//DateFormatter().string(from: sectionData[section].sectionName)
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath)
        cell.selectionStyle = .none
        
        let record = sectionData[indexPath.section].sectionObjects[indexPath.row]

        var content = cell.defaultContentConfiguration()
        if record.type {
            content.image = UIImage(systemName: "minus")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        } else {
            content.image = UIImage(systemName: "plus")?.withTintColor(.green, renderingMode: .alwaysOriginal)
        }
        //content.text = String(record.price)
        if let foo = record.category {
            content.secondaryText = foo.title
        } else {
            content.secondaryText = "no category"
        }
        if let foo = record.product {
            content.text = "\(foo.title ?? "no product") \(String(record.price)) Руб"
        } else {
            content.text = "no product \(String(record.price)) Руб"
        }

        cell.contentConfiguration = content

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            DataManager.shared.deleteTask(record: sectionData[indexPath.section].sectionObjects[indexPath.row])
            sectionData[indexPath.section].sectionObjects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if sectionData[indexPath.section].sectionObjects.isEmpty == true {
                //let indexSet = NSMutableIndexSet()
                //indexSet.add(indexPath.section)
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
