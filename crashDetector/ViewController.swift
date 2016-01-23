//
//  ViewController.swift
//  crashDetector
//
//  Created by Adam Teale on 26/08/2015.
//  Copyright (c) 2015 Adam Teale. All rights reserved.
//

import UIKit
import CoreMotion




class ViewController: UIViewController {

    
    @IBOutlet weak var gforceLabelX: UILabel!
    @IBOutlet weak var gforceLabelY: UILabel!
    @IBOutlet weak var gforceLabelZ: UILabel!


    @IBOutlet weak var graphView: GraphView!
    
    let manager = CMMotionManager()
    
    var managerUpdateInterval = 0.2
    var currentMaxGforce = CMAcceleration(x: 0.0, y: 0.0, z: 0.0)

    var currentUserAccelerationEntry = UserAccelerationEntry()
    
    
    //maxEntries = samples/sec * numberOfSeconds
    var maxEntries = Int((1 / 0.2) * 20)
    
    var maxX = Double(0.0)
    var maxY = Double(0.0)
    var maxZ = Double(0.0)

    var xaxisEntries : [Double] = []
    var yaxisEntries : [Double] = []
    var zaxisEntries : [Double] = []

    //Array of UserAccelerationEntry entries
    var userAccelerationData:[UserAccelerationEntry] = []
    
    
    //keep track of the last seconds - perhaps 10-20seconds?
    //calculate average speed based on the entries
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startDetecting()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func testGraph(){
        
        self.currentUserAccelerationEntry.userAccelerationX = Double(arc4random_uniform(UInt32(50)))
        self.currentUserAccelerationEntry.userAccelerationY = Double(arc4random_uniform(UInt32(50)))
        self.currentUserAccelerationEntry.userAccelerationZ = Double(arc4random_uniform(UInt32(50)))
        

    }
    
    func prepareGraphData(){
        
        //        //remove early entries as more data is added
        //        if self.userAccelerationData.count >= maxEntries{
        //            self.userAccelerationData.removeRange(0...(self.userAccelerationData.count-maxEntries))
        //        }
        //        self.userAccelerationData.append(self.currentUserAccelerationEntry)
        
        //X
        if self.xaxisEntries.count >= maxEntries{
            self.xaxisEntries.removeRange(0...(self.xaxisEntries.count-maxEntries))
        }
        self.xaxisEntries.append(self.currentUserAccelerationEntry.userAccelerationX)
        
        //Y
        if self.yaxisEntries.count >= maxEntries{
            self.yaxisEntries.removeRange(0...(self.yaxisEntries.count-maxEntries))
        }
        self.yaxisEntries.append(self.currentUserAccelerationEntry.userAccelerationY)
        
        //Z
        if self.zaxisEntries.count >= maxEntries{
            self.zaxisEntries.removeRange(0...(self.zaxisEntries.count-maxEntries))
        }
        self.zaxisEntries.append(self.currentUserAccelerationEntry.userAccelerationZ)
        
        //        for axis in self.userAccelerationData{
        //            xaxisEntries.append(axis.userAccelerationX)
        //            yaxisEntries.append(axis.userAccelerationY)
        //            zaxisEntries.append(axis.userAccelerationZ)
        //        }
        
        if self.xaxisEntries.count > 1{
            self.maxX = self.xaxisEntries.maxElement()!
            self.maxY = self.yaxisEntries.maxElement()!
            self.maxZ = self.zaxisEntries.maxElement()!
            
        }
        
        
        self.graphView.addDataToGraphPoints(self.xaxisEntries,
            userAccelerationEntryY: self.yaxisEntries,
            userAccelerationEntryZ: self.zaxisEntries,
            maxX:self.maxX,
            maxY:self.maxY,
            maxZ:self.maxZ
        )
        
        
        updateLabels()
        
    }
    
    
    
    func updateLabels(){
        //update levels
        gforceLabelX.text = "x: \(self.currentUserAccelerationEntry.userAccelerationX)  max: \(self.maxX)"
        gforceLabelY.text = "y: \(self.currentUserAccelerationEntry.userAccelerationY)  max: \(self.maxY)"
        gforceLabelZ.text = "z: \(self.currentUserAccelerationEntry.userAccelerationZ)  max: \(self.maxZ)"
        
    }
    
    
    func startDetecting(){
        if self.manager.deviceMotionAvailable {
            
            print("start detecting motion...", terminator: "")
            
            self.manager.deviceMotionUpdateInterval = self.managerUpdateInterval
            
            
            self.manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {
                
                [weak self] (data: CMDeviceMotion?, error: NSError?) in
                
//                if data!.userAcceleration.x < -2.5 {
//                    self!.crashAlert()
//                }else if data!.userAcceleration.y < -2.5 {
//                    self!.crashAlert()
//                }else if data!.userAcceleration.z < -2.5 {
//                    self!.crashAlert()
//                }
                
//                let maxGforce = [data!.userAcceleration.x, data!.userAcceleration.y, data!.userAcceleration.z].maxElement()!
//                let currentMaxGforceValue = [self!.currentMaxGforce.x, self!.currentMaxGforce.y, self!.currentMaxGforce.z].maxElement()!
//
//                self!.currentMaxGforce = data!.userAcceleration

//                if data!.userAcceleration.x == maxGforce{
//                    self!.gforceLabelX.text = NSString(format: "x: %.2f", data!.userAcceleration.x) as String
//                }
//                else if data!.userAcceleration.y == maxGforce{
//                    self!.gforceLabelY.text = NSString(format: "y: %.2f", data!.userAcceleration.y) as String
//                }
//                else if data!.userAcceleration.z == maxGforce{
//                    self!.gforceLabelZ.text = NSString(format: "z: %.2f", data!.userAcceleration.z) as String
//                }
                
                self!.currentUserAccelerationEntry = UserAccelerationEntry()
                self!.currentUserAccelerationEntry.userAccelerationX = data!.userAcceleration.x
                self!.currentUserAccelerationEntry.userAccelerationY = data!.userAcceleration.y
                self!.currentUserAccelerationEntry.userAccelerationZ = data!.userAcceleration.z

                self!.prepareGraphData()
            }
        }
        else{
            //testing
            NSTimer.scheduledTimerWithTimeInterval(self.managerUpdateInterval, target: self, selector: "testGraph", userInfo: nil, repeats: true)

            
        }
    }
    
    func crashAlert(){

        print("stop detecting motion...", terminator: "")
        
        self.manager.stopDeviceMotionUpdates()

        let tapAlert = UIAlertController(title: "Did you crash?!?!?", message: "Are you ok?", preferredStyle: UIAlertControllerStyle.Alert)
        tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))

        self.presentViewController(tapAlert, animated: true, completion: { () -> Void in
            self.startDetecting()
        })
    }
    
    
}

