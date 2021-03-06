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
        
        navItem2.title = "Share"
        navItem.title = "cool"
        
        //Create an instance of GDOverlay to setup help view
        o = GDOverlay()
        
        /////appereance customizations
        o.arrowColor = UIColor.red
        o.showBorder = false
        o.boxBackColor = UIColor.clear
        
        o.highlightView = true
        //o.arrowWidth = 2.0
        //o.backColor = UIColor.blue
        //o.showBorder = true
        o.boxBackColor = UIColor.gray.withAlphaComponent(0.7)
        //o.boxBorderColor = UIColor.black
        //o.headColor = UIColor.white
        //o.headRadius = 6
        //o.labelFont = UIFont.systemFont(ofSize: 12)
        //o.labelColor = UIColor.green
        
        /// types are .line_arrow | .line_bubble | .dash_bubble
        o.lineType = LineType.line_arrow
        
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
            let attribStr = NSAttributedString(string: "You can add a fullscreen overlay with an attributed string to present info to the user!", attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
                NSAttributedString.Key.foregroundColor: UIColor.white
                ])
            o.drawOverlay(desc: attribStr)

        }else if a == 2{
            let attribStr = NSAttributedString(string: "This is a UINavigationBar ItemThis is a UINavigationBar ItemThis is a UINavigationBar ItemThis is a UINavigationBar ItemThis is a UINavigationBar ItemThis is a UINavigationBar ItemThis is a UINavigationBar ItemThis is a UINavigationBar ItemThis is a UINavigationBar Item!", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11),
                NSAttributedString.Key.foregroundColor: UIColor.white
                ])
            o.drawOverlay(to: navItem2, desc: attribStr)
            
        }else if a == 3{
            let attribStr = NSAttributedString(string: "This is another UINavigationBar Item!", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11),
                NSAttributedString.Key.foregroundColor: UIColor.white
                ])
            o.drawOverlay(to: navItem, desc: attribStr)
            
        }else if a == 4{
            let attribStr = NSAttributedString(string: "This is a TableView Cell!", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor.white
                ])
            o.drawOverlay(to: tableView, section: 0, row: 0, desc: attribStr)
        }else if a == 5{
            let attribStr = NSAttributedString(string: "This is a UIButton!", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor.white
                ])
            o.drawOverlay(to: button1, desc: attribStr)
        }else if a == 6{
            let attribStr = NSAttributedString(string: "This is another UIButton!", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor.white
                ])
            o.drawOverlay(to: button2, desc: attribStr)
        }else if a == 7{
            let attribStr = NSAttributedString(string: "This is a UITabbar Item!", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor.white
                ])

            guard let tabbar = tabBarController?.tabBar else { return }
            o.drawOverlay(to: tabbar, item: 1, desc: attribStr)
            
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

