//
//  ItemTest.h
//  Phone-Crawl
//
//  Created by Austin Kelley on 3/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GTMSenTestCase.h"
#import "Phone_Crawl_Prefix.pch"

@interface ItemTest : GTMTestCase
{
	
}

- (void) testItemNameForItemType;

- (void) testInitWithBaseStats;

- (void) testInitExactItemWithName;

- (void) testIconNameForItemType;

- (void) testItemCast;

@end