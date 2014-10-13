//
//  BeaconsViewController.swift
//  BlueCap
//
//  Created by Troy Stribling on 9/13/14.
//  Copyright (c) 2014 gnos.us. All rights reserved.
//

import UIKit
import BlueCapKit

class BeaconsViewController: UITableViewController {

    var beaconRegion    : String?
    var beacons         = [Beacon]()

    struct MainStoryBoard {
        static let beaconCell   = "BeaconCell"
    }
    
    required init(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let beaconRegion = self.beaconRegion {
            self.navigationItem.title = beaconRegion
        } else {
            self.navigationItem.title = "Beacons"
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"didBecomeActive", name:BlueCapNotification.didBecomeActive, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"didResignActive", name:BlueCapNotification.didResignActive, object:nil)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func prepareForSegue(segue:UIStoryboardSegue, sender: AnyObject!) {
    }

    func updateBeacons(beacons:[Beacon]) {
        self.beacons = beacons
        self.updateWhenActive()
    }
    
    func sortBeacons(b1:Beacon, b2:Beacon) -> Bool {
        if b1.major > b2.major {
            return true
        } else if b1.major == b2.major && b1.minor > b2.minor {
            return true
        } else {
            return false
        }
    }
    
    func didResignActive() {
        Logger.debug("BeaconRegionsViewController#didResignActive")
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
    
    func didBecomeActive() {
        Logger.debug("BeaconRegionsViewController#didBecomeActive")
    }
    
    // UITableViewDataSource
    override func numberOfSectionsInTableView(tableView:UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.beacons.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryBoard.beaconCell, forIndexPath: indexPath) as BeaconCell
        let beacon = sorted(self.beacons, self.sortBeacons)[indexPath.row]
        if let uuid = beacon.proximityUUID {
            cell.proximityUUIDLabel.text = uuid.UUIDString
        } else {
            cell.proximityUUIDLabel.text = "Unknown"
        }
        if let major = beacon.major {
            cell.majorLabel.text = "\(major)"
        } else {
            cell.majorLabel.text = "Unknown"
        }
        if let minor = beacon.minor {
            cell.minorLabel.text = "\(minor)"
        } else {
            cell.minorLabel.text = "Unknown"
        }
        cell.proximityLabel.text = beacon.proximity.stringValue
        cell.rssiLabel.text = "\(beacon.rssi)"
        let accuracy = NSString(format:"%.4f", beacon.accuracy)
        cell.accuracyLabel.text = "\(accuracy)m"
        return cell
    }

}
