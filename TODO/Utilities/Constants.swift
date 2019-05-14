//
//  Constants.swift
//  TODO
//
//  Created by rajneesh on 14/05/19.
//  Copyright © 2019 rajneesh. All rights reserved.
//

import Foundation

struct Constants {
    static let newTaskScreenName = "New task"
    static let taskListScreenName = "Todo List"
    
    static let dateFormat = "dd-MM-YYYY hh:mm a"
    
    static let cellIdentifier = "TaskCell"
    
    static let taskDetailsSeque = "TaskDetails"
    
    static let searchPlaceHolder = "Search Task List"
    
    enum Error: String {
        case titleValidation = "Task title cannot be left blank or can't be of same name as existing tasks"
        case dateValidation = "Date cannot be left blank"
        case taskCreation = "Error occured while creating a task!"
    }
    
    enum Notification: String {
        case title = "Task to be accomplished"
        
    }
}
