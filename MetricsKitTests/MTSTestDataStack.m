//
//  MTSTestDataStack.m
//  Metrics
//
//  Created by Daniel Strokis on 3/18/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSTestDataStack.h"

@implementation MTSTestDataStack

- (NSManagedObjectModel *)model {
    if (!_model) {
        NSBundle *metricsKit = [NSBundle bundleWithIdentifier:@"com.dstrokis.MetricsKit"];
        NSURL *modelURL = [metricsKit URLForResource:@"Metrics" withExtension:@"momd"];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        _model = model;
    }
    
    return _model;
}

- (NSPersistentStoreCoordinator *)coordinator {
    if (!_coordinator) {
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];
        [coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
        
        _coordinator = coordinator;
    }
    
    return _coordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [context setPersistentStoreCoordinator:[self coordinator]];
        
        _managedObjectContext = context;
    }
    
    return _managedObjectContext;
}

@end
