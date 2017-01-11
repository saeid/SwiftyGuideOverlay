//
//  ViewController.swift
//  SwiftyGuideOverlay
//
//  Created by Saeid Basirnia on 8/19/16.
//  Copyright © 2016 Saeid Basirnia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SkipOverlayDelegate {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var button3: UIButton!
    
    var o: GDOverlay!
    
    override func viewDidAppear(_ animated: Bool){
        //Create an instance of GDOverlay to setup help view
        o = GDOverlay()
        
    /////appereance customizations
        o.arrowColor = UIColor.red
        o.showBorder = false
        o.boxBackColor = UIColor.clear

//        o.highlightView = true
//        o.arrowWidth = 2.0
//        o.backColor = UIColor.blueColor()
//        o.boxBorderColor = UIColor.blackColor()
//        o.headColor = UIColor.whiteColor()
//        o.headRadius = 6
//        o.labelFont = UIFont.systemFontOfSize(12)
//        o.labelColor = UIColor.greenColor()
        
//        currently only LineType.line_bubble and LineType.dash_bubble
//        o.lineType = LineType.line_bubble
        o.lineType = LineType.dash_bubble
        
//        if view controller has navigation bar use this
//        to calculate the correct height
        o.navHeight = o.calculateNavHeight(self)

        //Always set the delegate for SkipOverlayDelegate
        //for onSkipSignal() function call
        o.delegate = self
        
        self.onSkipSignal()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    var a = 1

    func onSkipSignal(){
        a += 1
        
        if a == 1{
            o.drawOverlay(self.view, containerWidth: 200, descText: "this is another button. press it for blah blah", toView: button2, isCircle: false)

        }else if a == 2{
            o.drawOverlay(self.view, containerWidth: 200, descText: "this is another button. press it for blah blah action", toView: button1, isCircle: false)

        }else if a == 3{
            o.drawOverlay(self.view, containerWidth: 200, descText: "this is a label. blah blah blah information about it. read it loud!", toView: lbl, isCircle: true)

        }else if a == 4{
            o.drawOverlay(self.view, containerWidth: 200, descText: "this is switch. switch it!", toView: switch1, isCircle: false)
            
        }else{
            o.drawOverlay(self.view, containerWidth: 200, descText: "this is another button. helloooooooooooooooooooooooo", toView: button3, isCircle: true)

            a = 0
        }
    }
}

