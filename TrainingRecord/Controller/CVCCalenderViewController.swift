//
//  CVCCalenderViewController.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/9/4.
//

import UIKit
import CVCalendar
class CVCCalenderViewController: UIViewController {

    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func textToImage(drawText text: String, inImage image: UIImage) -> UIImage
    {

        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        var target = ""
        var count = 0
        if text.count >= 4 && text.count < 6 {
            do{
                try text.forEach({ word in
                    count += 1
                    target += String(word)
                    if count == 2{
                        target += "\n"
                    }
                })
            }catch{
                print(error)
            }
            
        }else if text.count >= 6 && text.count < 8{
            do{
                try text.forEach({ word in
                    count += 1
                    target += String(word)
                    if count == 3{
                        target += "\n"
                    }
                })
            }catch{
                print(error)
            }
        }else if text.count >= 8 && text.count < 10{
            do{
                try text.forEach({ word in
                    count += 1
                    target += String(word)
                    if count == 4{
                        target += "\n"
                    }
                })
            }catch{
                print(error)
            }
        }else if text.count >= 10 && text.count < 12{
            do{
                try text.forEach({ word in
                    count += 1
                    target += String(word)
                    if count == 5{
                        target += "\n"
                    }
                })
            }catch{
                print(error)
            }
        }
        
        let font=UIFont(name: "Helvetica-Bold", size: 30)!

        let paraStyle=NSMutableParagraphStyle()
        paraStyle.alignment=NSTextAlignment.center
        
        let attributes = [NSAttributedString.Key.foregroundColor:UIColor.red, NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:paraStyle]

        let height = image.size.height//font.lineHeight

        let y = (height) / 4

        let strRect = CGRect(x: 0, y: y, width: image.size.width, height: height)

        target.draw(in: strRect.integral, withAttributes: attributes)

        let result=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return result!
    }
    @IBAction func touchTest(_ sender: Any)
    {
        let button = sender as! UIButton
        let image = self.textToImage(drawText: "通天背後式", inImage: UIImage.init(named: "backsquare")!)
        button.setBackgroundImage(image, for: .normal)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
