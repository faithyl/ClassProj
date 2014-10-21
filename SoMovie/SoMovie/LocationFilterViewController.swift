//
//  LocationFilterViewController.swift
//  SoMovie
//
//  Created by Erin Chuang on 10/20/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

@objc protocol LocationFilterDelegate {
    func locationFilterSet(zipCode: String, radius: Int)
}

class LocationFilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var zipCodeInput: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var radiusList : [String]!
    var delegate : LocationFilterDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.radiusList = ["5 miles", "10 miles", "15 miles", "20 miles", "25 miles", "30 miles", "35 miles", "40 miles", "45 miles", "50 miles"]
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return radiusList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return radiusList[row]
    }
    
    @IBAction func onCancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onDone(sender: UIButton) {
        if delegate != nil {
            var selectedRow = pickerView.selectedRowInComponent(0)
            var radiusString = pickerView(pickerView, titleForRow: selectedRow, forComponent: 0)
            let startIndex = advance(radiusString.startIndex, 0)
            let endIndex = find(radiusString, " ")
            let range = startIndex..<endIndex!
            let radiusInt = radiusString[range].toInt()
            delegate!.locationFilterSet(zipCodeInput.text, radius: radiusInt!)
        }
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
