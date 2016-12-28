//
//  NotebooksdashboardDelegate.swift
//  Zohonote
//
//  Created by Rajesh on 25/12/16.
//  Copyright © 2016 RajesSuku. All rights reserved.
//

import Foundation

public protocol NotebooksdashboardDelegate{
    
    func didBeginLoadingContent()
    func didEndLoadingContent(_ status:ServiceResponseStatus)
    
    func serviceListDidEndLoading(forKeyword keyword: String?,withStatus status: ServiceResponseStatus);

}
