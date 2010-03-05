//
//  ItemTest.h
//  Phone-Crawl
//
//  Created by Austin Kelley on 3/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GTMSenTestCase.h"
#import "Item.h"
#import "Item+TestingAdditions.h"
#import "Phone_Crawl_Prefix.pch"

@interface ItemTest : GTMTestCase
{

}

- (void) testInitWithBaseStats;

- (void) testInitExactItemWithName;

- (void) testIconNameForItemType;

@end
