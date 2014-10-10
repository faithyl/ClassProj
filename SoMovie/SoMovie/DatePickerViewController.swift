//
//  DatePickerViewController.swift
//  SoMovie
//
//  Created by Erin Chuang on 10/11/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

@objc protocol DatePickerDelegate {
    func dateSelected(date: NSDate)
}

class DatePickerViewController: UIViewController {
    var delegate : DatePickerDelegate? = nil

    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var today = NSDate()
        datePicker.minimumDate = today
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy"
        var year = formatter.stringFromDate(today)
        formatter.dateFormat = "M/d/yyyy"
        var lastDate = formatter.dateFromString("12/31/"+year)
        datePicker.maximumDate = lastDate
        datePicker.setDate(today, animated: false)
        datePicker.selected = true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onDone(sender: UIButton) {
        if delegate != nil {
            delegate!.dateSelected(datePicker.date)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onCancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
