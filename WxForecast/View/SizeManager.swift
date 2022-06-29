//
//  SizeManager.swift
//  WxForecast
//
//  Created by Chung EXI-Nguyen on 6/20/22.
//

import Foundation
import UIKit

class SizeManager {
    static let COLLECTION_WIDTH = 50.0
    static let TABLE_ROW_HEIGHT = 40.0
    
    static let COLLECTION_CELL_INSET = UIEdgeInsets(top: 15,
                                         left: 20,
                                         bottom: 15,
                                         right: 20)
    
    // tableview inset left, right can not shink the cell's width, so
    // we shoud leave the cell manage the inset left and right by settings
    // leading and trailing (WORKAROUND
    static let TABLE_CELL_INSET = UIEdgeInsets(top: 0,
                                         left: 0,
                                         bottom: 0,
                                         right: 0)
}
