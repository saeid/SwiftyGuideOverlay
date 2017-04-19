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
    @IBOutlet weak var navItem: UIBarButtonItem!
    
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
//        o.backColor = UIColor.blue
//        o.boxBorderColor = UIColor.black
//        o.headColor = UIColor.white
//        o.headRadius = 6
//        o.labelFont = UIFont.systemFont(ofSize: 12)
//        o.labelColor = UIColor.green
        
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
            
        }else if a == 5{
            o.drawOverlay(self.view, containerWidth: 200, descText: "this is another button. helloooooooooooooooooooooooo", toView: button3, isCircle: true)
        }else{
            /*view of navbar item needs to be corrected before sending for overlay
                this just do the trick. just remember to remove any extera views after you're done!
                you can think of better ways to get this view for sure! just do it. it's a sample
            */
            let vv = navItem.value(forKey: "view") as! UIView
            
            let newView = UIView(frame: CGRect(x: vv.frame.origin.x, y: vv.frame.midY - o.navHeight, width: vv.frame.width, height: vv.frame.height))
            self.view.addSubview(newView)
            
            o.drawOverlay(self.view, containerWidth: 200, descText: "this is navigation bar item", toView: newView, isCircle: false)
            a = 0
        }
    }
}

