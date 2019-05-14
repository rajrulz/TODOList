//
//  StoreManager.swift
//  TODO
//
//  Created by rajneesh on 14/05/19.
//  Copyright © 2019 rajneesh. All rights reserved.
//

import Foundation

extension UserDefaults {
    func addOrUpdate(task: Task) -> Bool{
        var tasks = getAllTasks()
        var filteredObjects = tasks.filter { (taskElement) -> Bool in
            if taskElement.title == task.title {
                return true
            }
            else {
                return false
            }
        }
        if filteredObjects.count > 0 {
            filteredObjects[0].time = task.time
        }
        else {
            tasks.append(task)
        }
        return save(tasks)
    }
    
    func delete(task: Task)  {
        var allTasks = getAllTasks()
        for (index, todoTask) in allTasks.enumerated() {
            if todoTask.title == task.title {
                allTasks.remove(at: index)
                break
            }
        }
        save(allTasks)
    }
    
    func getTask(Of title: String) -> Task? {
        let filteredtasks = getAllTasks().filter { (task) -> Bool in
            if task.title == title {
                return true
            }
            else {
                return false
            }
        }
        
        if filteredtasks.count > 0 {
            return filteredtasks[0]
        }
        else {
            return nil
        }
    }
    
    func getAllTasks() -> [Task] {
        guard let tasksData = self.value(forKey: "tasks") as? Data,
            let tasks = try? JSONDecoder().decode([Task].self, from: tasksData) else {
            return []
        }
        return tasks
    }
    
    @discardableResult func save(_ tasks: [Task]) -> Bool {
        do {
            let data = try JSONEncoder().encode(tasks)
            self.setValue(data, forKey: "tasks")
            return true
        }
        catch {
            print("**** error occured \(error.localizedDescription)")
            return false
        }
    }
}
