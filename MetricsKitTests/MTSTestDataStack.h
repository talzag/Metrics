//
//  MTSTestDataStack.h
//  Metrics
//
//  Created by Daniel Strokis on 3/18/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface MTSTestDataStack : NSObject

@property (nonatomic) NSManagedObjectModel *model;
@property (nonatomic) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;

@end
