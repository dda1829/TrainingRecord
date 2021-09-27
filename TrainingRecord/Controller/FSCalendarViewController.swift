//
//  CVCCalenderViewController.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/9/4.
//

import UIKit
import FSCalendar
class FSCalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
        // Do any additional setup after loading the view.
        
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let formatter = DateFormatter()
//        formatter.dateFormat = "EEEE MM-dd-YYYY"
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let string = formatter.string(from: date)
        let nowDate = Date()
        let string2 = formatter.string(from: nowDate)
        if string == string2 {
            return 1
        }
        return 0
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
//        formatter.dateFormat = "EEEE MM-dd-YYYY"
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let string = formatter.string(from: date)
        print(string)
    }

}
