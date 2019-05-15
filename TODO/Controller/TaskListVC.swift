//
//  ViewController.swift
//  TODO
//
//  Created by rajneesh on 14/05/19.
//  Copyright © 2019 rajneesh. All rights reserved.
//

import UIKit
import UserNotifications

class TaskListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataArray: [Task] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpTableView()
        setUpNavigationBar()
        UNUserNotificationCenter.current().delegate = self
    }

    func setUpTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 30
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = Constants.taskListScreenName
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = Constants.searchPlaceHolder
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataArray.removeAll()
        dataArray.append(contentsOf: UserDefaults.standard.getAllTasks())
        tableView.reloadData()
    }
    
    @IBAction func addTaskButtonClicked(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: Constants.taskDetailsSeque, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.taskDetailsSeque ,
            let tableView = sender as? UITableView {
            let indexpath = tableView.indexPathForSelectedRow!
            let destinationVC = segue.destination as! TaskDetailVC
            destinationVC.selectedTask = dataArray[indexpath.row]
        }
    }
}

extension TaskListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! TaskCell
        configureCell(cell, at: indexPath)
        
        return cell
    }
    
    func configureCell(_ cell: TaskCell, at indexPath: IndexPath) {
        let data = dataArray[indexPath.row]
        cell.taskTitle.text = data.title
        cell.dateAndTimeLabel.text = getStringFromDate(date: data.time)
        cell.dateAndTimeLabel.textColor = UIColor.light()
        
        if Date().timeIntervalSinceReferenceDate > data.time.timeIntervalSinceReferenceDate {
            cell.expiredLabel.isHidden = false
        }
        else {
            cell.expiredLabel.isHidden = true
        }
    }
}
extension TaskListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.taskDetailsSeque, sender: tableView)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let task = dataArray[indexPath.row]
            UserDefaults.standard.delete(task: task)
            dataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
        case .insert:
            tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        case .none: break
            
        @unknown default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        tableView.endUpdates()
    }
}

extension TaskListVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchedText(searchController.searchBar.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchedText(searchController.searchBar.text)
    }
    
    func filterContentForSearchedText(_ text: String?) {
        var newDataArray: [Task] = []
        dataArray.removeAll()
        if let searchText = text,
            !searchText.isEmpty {
            
            for task in UserDefaults.standard.getAllTasks() {
                if task.title.lowercased().contains(searchText.lowercased()) {
                    newDataArray.append(task)
                }
            }
        } else {
            newDataArray = UserDefaults.standard.getAllTasks()
        }
        dataArray.append(contentsOf: newDataArray)
        tableView.reloadData()
    }
}
extension TaskListVC: UNUserNotificationCenterDelegate {
    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .badge, .sound])
    }
    
    // For handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("tapped on alert")
        completionHandler()
    }
    
    
}
