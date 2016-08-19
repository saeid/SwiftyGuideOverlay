//
//  ViewController.swift
//  SwiftyGuideOverlay
//
//  Created by Saeid Basirnia on 8/19/16.
//  Copyright © 2016 Saeid Basirnia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SkipOverlayDelegate {

    @IBOutlet weak var navButt: UINavigationItem!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var button3: UIButton!
    
    var o: GDOverlay!

    override func viewDidAppear(animated: Bool) {
        o = GDOverlay()
        o.arrowColor = UIColor.redColor()
        o.showBorder = false
        o.boxBackColor = UIColor.clearColor()
        o.delegate = self
        o.lineType = LineType.dash_bubble
        
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
            o.drawOverlay(self.view, containerWidth: 200, descText: "this is another button. press it for blah blah", toView: button2)

        }else if a == 2{
            o.drawOverlay(self.view, containerWidth: 200, descText: "this is another button. press it for blah blah action", toView: button1)

        }else if a == 3{
            o.drawOverlay(self.view, containerWidth: 200, descText: "this is a label. blah blah blah information about it. read it loud!", toView: lbl)

        }else if a == 4{
            o.drawOverlay(self.view, containerWidth: 200, descText: "this is switch. switch it!", toView: switch1)
        }else{
            o.drawOverlay(self.view, containerWidth: 200, descText: "this is another button. helloooooooooooooooooooooooo", toView: button3)

            a = 0
        }
    }
}

