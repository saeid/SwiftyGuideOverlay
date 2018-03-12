//
//  ViewController.swift
//  SwiftyGuideOverlay
//
//  Created by Saeid Basirnia on 8/19/16.
//  Copyright © 2016 Saeid Basirnia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SkipOverlayDelegate{
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var navItem: UIBarButtonItem!
    var navItem2: UIBarButtonItem!
    var list: [String] = [
        "This is number 1",
        "This is number 2",
        "This is number 3",
        "This is number 4",
        "This is number 5",
        ]
    
    var o: GDOverlay!
    
    override func viewDidAppear(_ animated: Bool){
        
        navItem = navigationItem.leftBarButtonItem
        navItem2 = navigationItem.rightBarButtonItem
        
        navItem2.title = ""
        navItem.title = "cool"
        
        //Create an instance of GDOverlay to setup help view
        o = GDOverlay()
        
        /////appereance customizations
        o.arrowColor = UIColor.red
        o.showBorder = false
        o.boxBackColor = UIColor.clear
        
        o.highlightView = true
        //        o.arrowWidth = 2.0
        //        o.backColor = UIColor.blue
        //    o.showBorder = true
        //        o.boxBackColor = UIColor.green
        //                o.boxBorderColor = UIColor.black
        //        o.headColor = UIColor.white
        //        o.headRadius = 6
        //        o.labelFont = UIFont.systemFont(ofSize: 12)
        //        o.labelColor = UIColor.green
        
        //        currently only LineType.line_bubble and LineType.dash_bubble
        o.lineType = LineType.dash_bubble
        
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
    
    var a = 0
    func onSkipSignal(){
        a += 1
        
        if a == 1{
            o.drawOverlay(to: navItem2, desc: "This is really cool this is really cool this is really cool this is really cool this  is really cool this is really cool this is really cool!")
            
        }else if a == 2{
            o.drawOverlay(to: navItem, desc: "this  is really coolt!")
            
        }else if a == 3{
            o.drawOverlay(to: tableView, section: 0, row: 0, desc: "This is nice!")
            
        }else if a == 4{
            o.drawOverlay(to: button1, desc: "This button is doing some stuff!")
            
        }else if a == 5{
            o.drawOverlay(to: button2, desc: "This button is awsome!!")
            
        }else if a == 6{
            guard let tabbar = tabBarController?.tabBar else { return }
            o.drawOverlay(to: tabbar, item: 1, desc: "This is second tabbar item!")
            
        }else{
            o.drawOverlay(to: button3, desc: "This button is magic!")
            a = 0
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let curr = list[indexPath.row]
        cell.textLabel?.text = curr
        
        return cell
    }
}

