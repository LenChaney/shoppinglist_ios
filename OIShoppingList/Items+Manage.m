//
//  Items+Manage.m
//  OIShoppingList
//
//  Created by Tian Hongyu on 19/6/12.
//  Copyright (c) 2012 OpenIntents. All rights reserved.
//

#import "Items+Manage.h"
#import "Units+Manage.h"

@implementation Items (Manage)
+(Items *) creatItemsWithName:(NSString *) name
       inManagedObjectContext:(NSManagedObjectContext *)context
{
    Items  *items = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Items"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *entryList = [context executeFetchRequest:request error:&error];
    
    if (!entryList || ([entryList count] > 1)) {
        // handle error
    } else if (![entryList count]) {
        items = [NSEntityDescription insertNewObjectForEntityForName:@"Items"
                                                  inManagedObjectContext:context];
        items.name=name;
        items.created = [NSDate date];
        items.accessed = [NSDate date];
        items.modified = [NSDate date];
    } else {
        items   = [entryList lastObject];
        items.accessed = [NSDate date];

    }
    
    return items;
    
}
-(void) updateItemName:(NSString*)name
                  unit:(NSString*)unit
                  tags:(NSString*)tags
{
    if(![self.name isEqualToString:name])
    {
        self.name = name;
        self.modified = [NSDate date];
    }
    if(![self.tags isEqualToString:tags])
    {
        self.tags = tags;
        self.modified = [NSDate date];
    }
    if(![self.unit.name isEqualToString:unit])
    {
        [Units getUnitWithName:unit forItem:self inManagedObjectContext:[self managedObjectContext]];
        self.modified = [NSDate date];
    }

}



@end