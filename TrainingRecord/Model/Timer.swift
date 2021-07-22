//
//  Timer.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/6/25.
//

import Foundation

class TimerUse {
    static var share = TimerUse()
    private var timer = Timer()
    private var timer2 = Timer()
    private var timer3 = Timer()
    init() { }
    func setTimer(_ Second: Float,_ toClass: Any, _ toDo: Selector,_ isRepeated: Bool, _ number: Int){
        switch number {
        case 1:
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(Second), target: toClass, selector: toDo, userInfo: nil, repeats: isRepeated)
        case 2:
            timer2 = Timer.scheduledTimer(timeInterval: TimeInterval(Second), target: toClass, selector: toDo, userInfo: nil, repeats: isRepeated)
        case 3:
            timer3 = Timer.scheduledTimer(timeInterval: TimeInterval(Second), target: toClass, selector: toDo, userInfo: nil, repeats: isRepeated)
        default:
            print("Something wrong")
        }
    }
    
    func stopTimer(_ number: Int){
        switch number {
        case 1:
            timer.invalidate()
        case 2:
            timer2.invalidate()
        case 3:
            timer3.invalidate()
        default:
            print("something wrong")
        }
        
    }
   
    
    
}
