//
//  CategoryTableViewController.swift
//  HomeBuh
//
//  Created by Алексей on 20.07.2021.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    var categories: [Category] = []
    private let cellId = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        categories = DataManager.shared.fetchCategories()
        setupNavigationBar()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.selectionStyle = .none

        var content = cell.defaultContentConfiguration()
        content.text = categories[indexPath.row].title

        cell.contentConfiguration = content

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataManager.shared.deleteCategory(category: categories[indexPath.row])
            self.categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailRecord = DetailCategoryViewController()
        detailRecord.modalPresentationStyle = .fullScreen
        detailRecord.category = categories[indexPath.row]
        detailRecord.update = true
        present(detailRecord, animated: true)
    }
    
    private func setupNavigationBar() {
        title = "Categories"
        navigationController?.navigationBar.prefersLargeTitles = true

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
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewCategory)
        )
        navigationController?.navigationBar.tintColor = .white
    }

    @objc private func addNewCategory() {
        let detailRecord = DetailCategoryViewController()
        detailRecord.modalPresentationStyle = .fullScreen
        present(detailRecord, animated: true)
    }

}
