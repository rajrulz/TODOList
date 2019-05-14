//
//  NewTaskVC.swift
//  TODO
//
//  Created by rajneesh on 14/05/19.
//  Copyright © 2019 rajneesh. All rights reserved.
//

import UIKit
import UserNotifications

class TaskDetailVC: UIViewController, UITextFieldDelegate {

    var selectedTask: Task?
    
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskDate: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var selectedDate: Date!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let selectedTask = selectedTask {
            loadView(with: selectedTask)
        }
        self.title = Constants.newTaskScreenName
        self.taskTitle.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func loadView(with data: Task) {
        taskTitle.text = data.title
        taskDate.text = getStringFromDate(date: data.time)
        datePicker.date = data.time
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        guard let title = taskTitle.text,
            validateTaskTitle(title) else {
                showAlertWith(message: Constants.Error.titleValidation.rawValue, completionHandler: nil)
            return
        }
        
        guard let date = taskDate.text,
            validateTaskTime(date) else {
                showAlertWith(message: Constants.Error.dateValidation.rawValue, completionHandler: nil)
            return
        }
        
        let newTask = Task(title: title, time: selectedDate)
        if UserDefaults.standard.addOrUpdate(task: newTask) {
            self.scheduleLocalNotification(forTask: newTask)
            showAlertWith(message: "Success!") {[weak self] in
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
        else {
            showAlertWith(message: Constants.Error.taskCreation.rawValue, completionHandler: nil)
        }
    }
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let date = sender.date
        taskDate.text = getStringFromDate(date: date)
        selectedDate = sender.date
    }
    
    func scheduleLocalNotification(forTask: Task) {
         UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        })
        
        let content = UNMutableNotificationContent()
        content.title = Constants.Notification.title.rawValue
        content.subtitle = forTask.title
//        content.body = "\(forTask.title)"
        content.badge = 1
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: forTask.time)

        print("***** trigger date\(triggerDate)")
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: "reminder-TodoList", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("******* error occured******")
            }
        }
    }
}

extension TaskDetailVC: UNUserNotificationCenterDelegate {
    
}

//buisness Requirements
extension TaskDetailVC {
    
    func validateTaskTitle(_ title: String) -> Bool {
        guard title.count > 0 else {
            return false
        }
        if selectedTask == nil {
            return taskAllreadyExistsWith(title: title)
        }
        else {
            return true
        }
    }
    
    func taskAllreadyExistsWith(title: String) -> Bool {
        let taskWithSameName = UserDefaults.standard.getAllTasks().filter { (task) -> Bool in
            if task.title == title {
                return true
            }
            else {
                return false
            }
        }
        return taskWithSameName.count > 0 ? false : true
    }
    
    func validateTaskTime(_ date: String) -> Bool {
        guard date.count > 0 else {
            return false
        }
        return true
    }
    
    func showAlertWith(message: String, completionHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action) in
            completionHandler?()
        }))
        present(alertController, animated: true, completion: nil)
    }
}
