
#import "DataController.h"

#define AWS_S3_BASE_URL @"https://s3.amazonaws.com/papr-user-images-1000001"

@interface DataController ()
@end


@implementation DataController

- (id) init {
    
    self = [super init];
    if (self) {
        self.testMode = TRUE;
    }
    
    return self;
    
}


#pragma mark - PAPR Methods

// PAPR
- (void) createPaprDictionaryWithDictionary : (NSDictionary *)newDictionaryRCVD {
    
    NSString *publisherID = [newDictionaryRCVD objectForKey:@"fb_user_id"];

    NSDictionary *editionHeaderDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                             @"1", @"edition_is_serif",
                                             @"https://i.imgur.com/Kn9tNdg.png", @"edition_avatar_url",
                                             [newDictionaryRCVD objectForKey:@"user_username"], @"edition_display_name",
                                             [newDictionaryRCVD objectForKey:@"user_username"], @"user_username",
                                             nil];
    
    NSArray *arrayOfPaprItemsDEFAULT = [[NSArray alloc] init];

    NSDictionary *editionDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          editionHeaderDictionary, @"EDITION_HEADER",
                                          arrayOfPaprItemsDEFAULT, @"EDITION_POSTS",
                                          publisherID, @"PUBLISHER_ID",
                                          nil];
    
    [self saveMyPaprDictionary:editionDictionary];

}
- (void) updatePaprDictionaryWithNewPosts : (NSArray *)updatedArrayRCVD {
    
    NSDictionary *paprDictionary = [[NSDictionary alloc] initWithDictionary: [self returnMyPaprDictionary] ];
    
    NSDictionary *updatedDefaultDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              [paprDictionary objectForKey:@"EDITION_HEADER"], @"EDITION_HEADER",
                                              updatedArrayRCVD, @"EDITION_POSTS",
                                              [paprDictionary objectForKey:@"PUBLISHER_ID"], @"PUBLISHER_ID",
                                              nil];
    
    [self saveMyPaprDictionary:updatedDefaultDictionary];

}
- (void) updatePaprHeaderDictionaryWithNewSubscriptions : (NSArray *)updatedSubscriptionsRCVD {

    // SETUP LABEL . FOLLOWING
    NSString *userFollowingCount = [NSString stringWithFormat:@"%i", (int)[[DataController dc] returnUserSubscriptions].count];

    
    NSDictionary *paprDictionary = [[NSDictionary alloc] initWithDictionary: [self returnMyPaprDictionary] ];
    
    NSDictionary *updatedDefaultDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              [paprDictionary objectForKey:@"EDITION_HEADER"], @"EDITION_HEADER",
                                              updatedSubscriptionsRCVD, @"EDITION_POSTS",
                                              [paprDictionary objectForKey:@"PUBLISHER_ID"], @"PUBLISHER_ID",
                                              nil];
    
    [self saveMyPaprDictionary:updatedDefaultDictionary];
    
}
- (void) updatePaprDictionaryWithNewHeader : (NSDictionary *)updatedDictionaryRCVD {
    
    NSDictionary *paprDictionary = [[NSDictionary alloc] initWithDictionary: [self returnMyPaprDictionary] ];
    
    NSDictionary *updatedDefaultDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              updatedDictionaryRCVD, @"EDITION_HEADER",
                                              [paprDictionary objectForKey:@"EDITION_POSTS"], @"EDITION_POSTS",
                                              [paprDictionary objectForKey:@"PUBLISHER_ID"], @"PUBLISHER_ID",
                                              nil];
    
    [self saveMyPaprDictionary:updatedDefaultDictionary];

}
- (void) updatePaprDictionaryWithDictionary : (NSDictionary *)updateDictionaryRCVD {

    [self saveMyPaprDictionary:updateDictionaryRCVD];
    
}
- (void) updatePaprHeaderDictionaryWithKeyValue : (NSDictionary *)keyValueRCVD {
    
    NSMutableDictionary *headerDictionaryUPDATED = [[NSMutableDictionary alloc] initWithDictionary: [self returnMyPaprHeaderDictionary] ];
    
    NSString *updatedKey = [keyValueRCVD objectForKey:@"key"];
    NSString *updatedValue = [keyValueRCVD objectForKey:@"value"];
    
    [headerDictionaryUPDATED setObject:updatedValue forKey:updatedKey];

    [self updatePaprDictionaryWithNewHeader:headerDictionaryUPDATED];
    
}
- (NSArray *) returnArrayOfFreshPaprDictionaries : (NSArray *)arrayOfPaprDictionariesRCVD {

    NSArray *arrayOfCleanPaprDictionaries = [[NSArray alloc] initWithArray: [self returnArrayFromOptionsArray:arrayOfPaprDictionariesRCVD] ];
    
    NSMutableArray *arrayOfPaprDictionariesLEGIT = [[NSMutableArray alloc] init];

    for (NSDictionary *thisPaprDictionary in arrayOfCleanPaprDictionaries) {
    
        NSMutableDictionary *paprDictionaryEDITED = [[NSMutableDictionary alloc] initWithDictionary:thisPaprDictionary];
        NSArray *arrayOfPaprItems = [[NSArray alloc] initWithArray: [self returnArrayOfFreshPaprItems: [paprDictionaryEDITED objectForKey:@"EDITION_POSTS"] ] ];
        
        if (arrayOfPaprItems.count > 0) {
        
            [paprDictionaryEDITED setObject:arrayOfPaprItems forKey:@"EDITION_POSTS"];
            
            [arrayOfPaprDictionariesLEGIT addObject:paprDictionaryEDITED];
            
        }

    }

    NSArray *arrayOfPaprDictionaries = [[NSArray alloc] initWithArray: arrayOfPaprDictionariesLEGIT ];
    
    return arrayOfPaprDictionaries;
    
    
}
- (NSArray *) returnArrayOfSortedPaprSubscriptions : (NSArray *)arrayOfPaprSubscriptionsRCVD {
    
    NSMutableArray *arrayOfPaprSubscriptionsHEAD = [[NSMutableArray alloc] init];
    NSMutableArray *arrayOfPaprSubscriptionsTAIL = [[NSMutableArray alloc] init];
    
    // FIRST WE SPLIT THE SUBSCRIPTIONS FROM THE NON-SUBSCRIPTIONS
    for (NSDictionary *thisPaprSubscription in arrayOfPaprSubscriptionsRCVD) {
        
        NSString *publisherID = [thisPaprSubscription objectForKey:@"PUBLISHER_ID"];
        
        NSArray *arrayOfSubscriptionIDs = [[DataController dc] returnUserSubscriptions];
        
        if ([arrayOfSubscriptionIDs containsObject:publisherID]) {
            
            [arrayOfPaprSubscriptionsTAIL addObject:thisPaprSubscription];

        } else {

            [arrayOfPaprSubscriptionsHEAD addObject:thisPaprSubscription];

        }

    }
    
    // THEN WE ADD THE NON-SUBSCRIPTIONS TO THE END OF THE ARRAY OF SUBSCRIPTIONS
    for (NSDictionary *thisPaprSubscription in arrayOfPaprSubscriptionsTAIL) {
    
        [arrayOfPaprSubscriptionsHEAD addObject:thisPaprSubscription];
    
    }

    // THEN RETURN THE ARRAY
    
    NSArray *arrayOfPaprSubscriptions = [[NSArray alloc] initWithArray: arrayOfPaprSubscriptionsHEAD ];
    
    return arrayOfPaprSubscriptions;

    
}
- (NSArray *) returnArrayOfFreshPaprItems : (NSArray *)paprItemsRCVD {
    
    NSMutableArray *arrayOfPaprItemsEDITED = [[NSMutableArray alloc] init];
    
    for (NSDictionary *thisItemDictionary in paprItemsRCVD) {
        
        NSString *thisTimestamp = [thisItemDictionary objectForKey:@"post_timestamp"];
        NSString *thisImageURL = [thisItemDictionary objectForKey:@"post_image_url"];
        if ( [[DataController dc] thisPostIsFresh:thisTimestamp] && [[DataController dc] thisPostIsNullFree:thisImageURL] ) {
            [arrayOfPaprItemsEDITED addObject:thisItemDictionary];
        }
        
    }

    NSArray *arrayOfPaprItemsFINAL = [[NSArray alloc] initWithArray: arrayOfPaprItemsEDITED ];
    
    return arrayOfPaprItemsFINAL;
    
}
- (NSArray *) returnMyActivePaprItems {
    
    NSDictionary *myPaprDictionary = [self returnMyPaprDictionary];
    
    NSArray *arrayOfPaprItemsFRESH = [[NSMutableArray alloc] initWithArray: [self returnArrayOfFreshPaprItems: [myPaprDictionary objectForKey:@"EDITION_POSTS"]] ];

    return arrayOfPaprItemsFRESH;

}
- (BOOL) returnIfWeUseSerifs {
    
    NSDictionary *myPaprDictionary = [self returnMyPaprDictionary];

    NSDictionary *editionHeaderDictionary = [[NSDictionary alloc] initWithDictionary: [myPaprDictionary objectForKey:@"EDITION_HEADER"] ];
    
    return [[editionHeaderDictionary objectForKey:@"edition_is_serif"] boolValue];
    
}
- (NSDictionary *) returnMyPaprDictionary {
    
    NSData *dataDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyPaprDictionary"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithDictionary: [NSKeyedUnarchiver unarchiveObjectWithData:dataDictionary] ];
    
    return dictionary;
    
}
- (NSDictionary *) returnMyPaprHeaderDictionary {
    
    NSData *dataDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyPaprDictionary"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithDictionary: [NSKeyedUnarchiver unarchiveObjectWithData:dataDictionary] ];
    NSLog(@"DC . returnMyPaprHeaderDictionary . dictionary = %@", dictionary);
    NSDictionary *headerDictionary = [[NSDictionary alloc] initWithDictionary: [dictionary objectForKey:@"EDITION_HEADER"] ];
    NSLog(@"DC . returnMyPaprHeaderDictionary . headerDictionary = %@", headerDictionary);
    
    return headerDictionary;
    
}
- (void) saveMyPaprDictionary : (NSDictionary *)dictionaryRCVD {
    
    NSData *dictionaryData = [NSKeyedArchiver archivedDataWithRootObject:dictionaryRCVD];
    [[NSUserDefaults standardUserDefaults] setObject:dictionaryData forKey:@"MyPaprDictionary"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - POST METHODS

- (NSDictionary *) returnFullEditionDictionaryWithNewPost : (NSDictionary *)postDictionaryRCVD {

    NSMutableDictionary *editionDictionaryUPDATING = [[NSMutableDictionary alloc] initWithDictionary: [self returnMyPaprDictionary] ];

    NSArray *arrayFromOldEdition = [[NSArray alloc] initWithArray: [editionDictionaryUPDATING objectForKey:@"EDITION_POSTS"] ];
    
    NSMutableArray *editionPostsUPDATING = [[NSMutableArray alloc] initWithArray: [self returnArrayOfFreshPaprItems:arrayFromOldEdition] ];

    [editionPostsUPDATING insertObject:postDictionaryRCVD atIndex:0];

    NSArray *editionPosts = [[NSArray alloc] initWithArray: editionPostsUPDATING];
    
    [editionDictionaryUPDATING setObject:editionPosts forKey:@"EDITION_POSTS"];

    NSDictionary *editionDictionary = [[NSDictionary alloc] initWithDictionary: editionDictionaryUPDATING ];
    
    return editionDictionary;
    
}
- (int) returnNumberOfLinesForPostText : (NSString *)textRCVD {

    UILabel *labelSize = [[UILabel alloc] init];
    labelSize.font = [UIFont systemFontOfSize:14];
    labelSize.text = textRCVD;
    labelSize.numberOfLines = 0;
    labelSize.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize maximumLabelSize = CGSizeMake(310, CGFLOAT_MAX);
    
    CGSize expectSize = [labelSize sizeThatFits:maximumLabelSize];
    
    return 1;
    
}
- (NSString *) returnPostID {
    
    NSDictionary *userDictionary = [[NSDictionary alloc] initWithDictionary: [self returnMyUserDictionary] ];
    
    NSDate *dateNow = [NSDate date];
    
    NSString *postID = [NSString stringWithFormat:@"%@-%@", [userDictionary objectForKey:@"fb_user_id"], [self returnTimestampFromDate:dateNow] ];
    
    return postID;
    
}
- (NSString *) returnImageStringForUser : (NSString *)userID {
    
    NSDate *dateNow = [NSDate date];

    NSString *imageString = [NSString stringWithFormat:@"%@_%@.jpg", userID, [self returnTimestampFromDate:dateNow] ];
    
    return imageString;
    
}
- (NSString *) returnImageStringURL : (NSString *)stringRCVD {
    
    NSString *stringURL = [NSString stringWithFormat:@"%@/%@", AWS_S3_BASE_URL, stringRCVD];
    
    return stringURL;
    
}

#pragma mark - SHARE METHODS

- (NSString *) returnShortURL : (NSString *)postID {

    // "post_id": "p7000035-2018-05-22-13-16-29-66"
    int counter = 0;
    NSString *shorty = @"";
    NSArray *arrayID = [postID componentsSeparatedByString:@"-"];

    for (NSString *thisString in arrayID) {
        
        if (counter == 0) {
            // PUBLISHER ID . last four digits
            NSString *stringPUBLISHER = [thisString substringFromIndex:MAX((int)[thisString length] - 4, 0)];

            shorty = [shorty stringByAppendingString: [self returnTopSecretBaseSixtyTwoCharacter: [NSString stringWithFormat:@"%C", [stringPUBLISHER characterAtIndex:3]]] ];
            shorty = [shorty stringByAppendingString: [self returnTopSecretBaseSixtyTwoCharacter: [NSString stringWithFormat:@"%C", [stringPUBLISHER characterAtIndex:2]]] ];
            shorty = [shorty stringByAppendingString: [self returnTopSecretBaseSixtyTwoCharacter: [NSString stringWithFormat:@"%C", [stringPUBLISHER characterAtIndex:1]]] ];
            shorty = [shorty stringByAppendingString: [self returnTopSecretBaseSixtyTwoCharacter: [NSString stringWithFormat:@"%C", [stringPUBLISHER characterAtIndex:0]]] ];
            
        } else if (counter == 1) {
            // YEAR . last two digits
            NSString *stringYEAR = [thisString substringFromIndex:MAX((int)[thisString length] - 2, 0)];

            shorty = [shorty stringByAppendingString: [self returnTopSecretBaseSixtyTwoCharacter: stringYEAR] ];

        } else if (counter == 7) {
            // NANO (1 & 2) . split digits

            shorty = [shorty stringByAppendingString: [self returnTopSecretBaseSixtyTwoCharacter: [NSString stringWithFormat:@"%C", [thisString characterAtIndex:0]]] ];
            shorty = [shorty stringByAppendingString: [self returnTopSecretBaseSixtyTwoCharacter: [NSString stringWithFormat:@"%C", [thisString characterAtIndex:1]]] ];

        } else {
            // MONTH, DAY, HOUR, MINUTE
            // NOTE: 05 = 5!

            shorty = [shorty stringByAppendingString: [self returnTopSecretBaseSixtyTwoCharacter:thisString] ];

        }
        
        counter++;
        
    }
    
    NSLog(@"returnShortURL . shorty = %@", shorty);
    return shorty;
    
}
- (NSString *) returnTopSecretBaseSixtyTwoCharacter : (NSString *)charRCVD {
    
    NSLog(@"returnTopSecretBaseSixtyTwoCharacter . charRCVD = %@", charRCVD);

    int index = [charRCVD intValue];

    NSLog(@"returnTopSecretBaseSixtyTwoCharacter . index = %i", index);

    NSArray *arrayBase62 = @[@"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j"];

    if (index >= 0 && index < arrayBase62.count) {
        NSLog(@"returnTopSecretBaseSixtyTwoCharacter . [arrayBase62 objectAtIndex:index] = %@", [arrayBase62 objectAtIndex:index]);
        return [arrayBase62 objectAtIndex:index];
    } else {
        NSLog(@"returnTopSecretBaseSixtyTwoCharacter . index = X");
        return @"x";
    }

}
- (NSString *) decodeTopSecretPublisherCharacter : (NSString *)charRCVD {

    NSArray *arrayNumbers = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
    NSArray *arrayPublisherBase62 = @[@"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t"];

    int index = (int)[arrayPublisherBase62 indexOfObject:charRCVD];

    return [arrayNumbers objectAtIndex:index];
    
}

#pragma mark - USER METHODS

- (void) createUserDictionaryWithDictionary : (NSDictionary *)newDictionaryRCVD {

    NSDictionary *profileDictionary = @{@"user_profile_display_name" : [newDictionaryRCVD objectForKey:@"user_username"],
                                        @"user_profile_avatar_url" : [newDictionaryRCVD objectForKey:@"user_profile_avatar_url"],
                                        @"user_profile_mast_url" : @"-",
                                        @"user_profile_blurb" : @"-",
                                        @"user_profile_url" : @"-",
                                        @"user_profile_stat_followers" : @"1",
                                        @"user_profile_stat_following" : @"1",
                                        @"user_profile_stat_posts" : @"0"};

    NSDictionary *settingsDictionary = @{@"user_settings_font" : @"1",
                                         @"user_settings_private" : @"0",
                                         @"user_settings_push" : @"0"};

    
    NSDictionary *newUserDictionary = @{@"user_username" : [newDictionaryRCVD objectForKey:@"user_username"],
                                        @"user_profile" : profileDictionary,
                                        @"user_settings" : settingsDictionary,
                                        @"fb_user_id" : [newDictionaryRCVD objectForKey:@"fb_user_id"],
                                        @"fb_phone_number" : [newDictionaryRCVD objectForKey:@"fb_phone_number"],
                                        @"fb_timestamp" : [newDictionaryRCVD objectForKey:@"fb_timestamp"]};

    [self saveMyUserDictionary:newUserDictionary];
    
}
- (void) updateUserDictionaryWithNewLocation : (NSDictionary *)updatedDictionaryRCVD {
    
    NSMutableDictionary *userDictionaryEDITED = [[NSMutableDictionary alloc] initWithDictionary: [self returnMyUserDictionary] ];
    
    [userDictionaryEDITED setObject:updatedDictionaryRCVD forKey:@"user_location"];
    
    NSDictionary *updatedUserDictionary = [[NSDictionary alloc] initWithDictionary: userDictionaryEDITED ];
    
    [self saveMyUserDictionary:updatedUserDictionary];
    
}
- (void) updateUserDictionaryWithNewProfile : (NSDictionary *)profileDictionaryRCVD {
    
    NSMutableDictionary *userDictionaryEDITED = [[NSMutableDictionary alloc] initWithDictionary: [self returnMyUserDictionary] ];
    
    [userDictionaryEDITED setObject:profileDictionaryRCVD forKey:@"user_profile"];
    
    NSDictionary *updatedUserDictionary = [[NSDictionary alloc] initWithDictionary: userDictionaryEDITED ];
    
    [self saveMyUserDictionary:updatedUserDictionary];
    
}
- (void) updateUserDictionaryWithNewSettings : (NSDictionary *)settingsDictionaryRCVD {
    
    NSMutableDictionary *userDictionaryEDITED = [[NSMutableDictionary alloc] initWithDictionary: [self returnMyUserDictionary] ];
    
    [userDictionaryEDITED setObject:settingsDictionaryRCVD forKey:@"user_settings"];
    
    NSDictionary *updatedUserDictionary = [[NSDictionary alloc] initWithDictionary: userDictionaryEDITED ];
    
    [self saveMyUserDictionary:updatedUserDictionary];
    
}
- (void) updateUserDictionaryWithSubscriptions : (NSArray *)updatedArrayRCVD {
    
    NSMutableDictionary *userDictionaryEDITED = [[NSMutableDictionary alloc] initWithDictionary: [self returnMyUserDictionary] ];
    
    [userDictionaryEDITED setObject:updatedArrayRCVD forKey:@"user_subscriptions"];
    
    NSDictionary *updatedUserDictionary = [[NSDictionary alloc] initWithDictionary: userDictionaryEDITED ];
    
    [self saveMyUserDictionary:updatedUserDictionary];

}
- (void) updateUserSubscriptions:(NSString *)subscriptionRCVD subscribeToThisUser:(BOOL)newSubscriptionRCVD {

    // MARK LOCAL SUBSCRIPTIONS AS UPDATED SO WE CAN SAVE TO DATABASE WHEN APP CLOSES
    // WHY NOT: self.iUpdatedMySubscriberList = TRUE; ???
    self.iUpdatedMySubscriberList = TRUE;
    
    // UPDATE ADD/REMOVE
    NSMutableArray *mySubscriptionsEDITED = [[NSMutableArray alloc] initWithArray: [self returnUserSubscriptions] ];

    if (newSubscriptionRCVD) {

        [mySubscriptionsEDITED addObject:subscriptionRCVD];

    } else {

        [mySubscriptionsEDITED removeObject:subscriptionRCVD];

    }
    
    NSArray *mySubscriptions = [[NSArray alloc] initWithArray: mySubscriptionsEDITED];

    // UPDATE LOCAL DICTIONARY WITH NEW ARRAY OF SUBSCRIPTIONS
    [self updateUserDictionaryWithSubscriptions:mySubscriptions];

}
- (void) moveUserSubscriptionsFromIndex:(int)fromIndex toIndex:(int)toIndex {
    
    NSMutableArray *userSubscriptionsEDITING = [[NSMutableArray alloc] initWithArray: [self returnUserSubscriptions] ];

    NSString *publisherID = [userSubscriptionsEDITING objectAtIndex:fromIndex];
    
    NSLog(@"Move This: %@", publisherID);
    NSLog(@"Move: %i to %i", fromIndex, toIndex);

    NSLog(@"First 3 B4: %@, %@, %@", [userSubscriptionsEDITING objectAtIndex:0], [userSubscriptionsEDITING objectAtIndex:1], [userSubscriptionsEDITING objectAtIndex:2] );

    [userSubscriptionsEDITING removeObjectAtIndex:fromIndex];

    if (fromIndex > toIndex) {
        [userSubscriptionsEDITING insertObject:publisherID atIndex:toIndex];
    } else {
        [userSubscriptionsEDITING insertObject:publisherID atIndex:toIndex];
    }
    
    NSArray *userSubscriptionsUPDATED = [[NSArray alloc] initWithArray: userSubscriptionsEDITING];
    
    // UPDATE LOCAL DICTIONARY WITH NEW ARRAY OF SUBSCRIPTIONS
    [self updateUserDictionaryWithSubscriptions:userSubscriptionsUPDATED];

    NSMutableArray *userSubscriptionsAFTA = [[NSMutableArray alloc] initWithArray: [self returnUserSubscriptions] ];

    NSLog(@"First 3 AFTA: %@, %@, %@", [userSubscriptionsAFTA objectAtIndex:0], [userSubscriptionsAFTA objectAtIndex:1], [userSubscriptionsAFTA objectAtIndex:2] );

}

- (void) updateUserPostTotal {

    int userPostTotal = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userPostTotal"] intValue];

    userPostTotal++;
    
    NSString *userPostTotalString = [NSString stringWithFormat:@"%i", userPostTotal];
    
    [[NSUserDefaults standardUserDefaults] setObject:userPostTotalString forKey:@"userPostTotal"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (void) updateUserToken : (NSString *)updatedTokenRCVD {
    
    NSMutableDictionary *userDictionaryEDITED = [[NSMutableDictionary alloc] initWithDictionary: [self returnMyUserDictionary] ];
    
    [userDictionaryEDITED setObject:updatedTokenRCVD forKey:@"user_token"];

    NSDictionary *updatedUserDictionary = [[NSDictionary alloc] initWithDictionary: userDictionaryEDITED ];

    [self saveMyUserDictionary:updatedUserDictionary];

}
- (NSArray *) returnUserSubscriptions {
    
    // NSLog(@"who just called returnUserSubscriptions? %@", [NSThread callStackSymbols]);

    NSDictionary *userDictionary = [[NSDictionary alloc] initWithDictionary: [self returnMyUserDictionary] ];
    
    NSArray *arrayOfUserSubscriptions = [[NSArray alloc] initWithArray: [userDictionary objectForKey:@"user_subscriptions"] ];
    
    return arrayOfUserSubscriptions;
    
}
- (NSString *) returnUserSubscriptionsAsString {
    
    NSDictionary *userDictionary = [[NSDictionary alloc] initWithDictionary: [self returnMyUserDictionary] ];
    
    NSArray *arrayOfUserSubscriptions = [[NSArray alloc] initWithArray: [userDictionary objectForKey:@"user_subscriptions"] ];
    
    NSString *userSubscriptionsString = [arrayOfUserSubscriptions componentsJoinedByString:@","];
    
    return userSubscriptionsString;
    
}
- (NSString *) returnUserToken {
    
    NSDictionary *userDictionary = [[NSDictionary alloc] initWithDictionary: [self returnMyUserDictionary] ];
    
    return [userDictionary objectForKey:@"user_token"];
    
}
- (NSString *) returnMyUserID {
    
    NSDictionary *userDictionary = [[NSDictionary alloc] initWithDictionary: [self returnMyUserDictionary] ];
    
    return [userDictionary objectForKey:@"fb_user_id"];
    
}
- (NSString *) returnMyUsername {
    
    NSDictionary *userDictionary = [[NSDictionary alloc] initWithDictionary: [self returnMyUserDictionary] ];
    
    return [userDictionary objectForKey:@"user_username"];
    
}
- (NSString *) returnMyDisplayName {
    
    NSDictionary *userDictionary = [[NSDictionary alloc] initWithDictionary: [self returnMyUserDictionary] ];
    NSDictionary *profileDictionary = [[NSDictionary alloc] initWithDictionary: [userDictionary objectForKey:@"user_profile"] ];
    
    return [profileDictionary objectForKey:@"user_profile_display_name"];
    
}
- (NSString *) returnMyAvatarBucket {
    
    return @"papr-user-images-1000001";
    
}
- (NSString *) returnMyAvatarURL {
    
    NSDictionary *userDictionary = [[NSDictionary alloc] initWithDictionary: [self returnMyUserDictionary] ];
    NSDictionary *profileDictionary = [[NSDictionary alloc] initWithDictionary: [userDictionary objectForKey:@"user_profile"] ];
    
    return [profileDictionary objectForKey:@"user_profile_avatar_url"];
    
}
- (NSString *) returnRandomAvatarURL {
    
    int avatarNumber = arc4random_uniform(8);
    //
    NSArray *avatarArray = @[@"https://s3.amazonaws.com/papr-user-images-1000001/profile_papr_piece_01.png",
                             @"https://s3.amazonaws.com/papr-user-images-1000001/profile_papr_piece_02.png",
                             @"https://s3.amazonaws.com/papr-user-images-1000001/profile_papr_piece_03.png",
                             @"https://s3.amazonaws.com/papr-user-images-1000001/profile_papr_piece_04.png",
                             @"https://s3.amazonaws.com/papr-user-images-1000001/profile_papr_piece_05.png",
                             @"https://s3.amazonaws.com/papr-user-images-1000001/profile_papr_piece_06.png",
                             @"https://s3.amazonaws.com/papr-user-images-1000001/profile_papr_piece_07.png",
                             @"https://s3.amazonaws.com/papr-user-images-1000001/profile_papr_piece_08.png",
                             ];
    
    return [avatarArray objectAtIndex:avatarNumber];
    
}
- (NSString *) returnMyMastURL {
    
    NSDictionary *userDictionary = [[NSDictionary alloc] initWithDictionary: [self returnMyUserDictionary] ];
    NSDictionary *profileDictionary = [[NSDictionary alloc] initWithDictionary: [userDictionary objectForKey:@"user_profile"] ];
    
    return [profileDictionary objectForKey:@"user_profile_mast_url"];

}

- (NSDictionary *) returnMyUserDictionary {
    
    NSData *dataDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserDictionary"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithDictionary: [NSKeyedUnarchiver unarchiveObjectWithData:dataDictionary] ];
    
    return dictionary;
    
}
- (void) saveMyUserDictionary : (NSDictionary *)dictionaryRCVD {
    
    NSData *dictionaryData = [NSKeyedArchiver archivedDataWithRootObject:dictionaryRCVD];
    [[NSUserDefaults standardUserDefaults] setObject:dictionaryData forKey:@"MyUserDictionary"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - HELPER METHODS

- (BOOL) iSubscribeToThisPublisher : (NSString *)publisherID {
    
    NSArray *arrayOfSubscriptionIDs = [[DataController dc] returnUserSubscriptions];
    
    if ([arrayOfSubscriptionIDs containsObject:publisherID]) {
        
        return TRUE;

    } else {
        
        return FALSE;

    }

}
- (NSString *) returnAvatarURL : (NSString *)publisherID {

    NSString *avatarURL = [NSString stringWithFormat:@"https://s3.amazonaws.com/papr-user-images-1000001/%@.png", publisherID];

    return avatarURL;
    
}
- (int) returnHeightForCommentCell : (NSString *)text : (BOOL)typeIsComment {
    
    // VARIABLES . PRESET
    int labelHeightOneLine = 21;
    int labelOffsetY = 15;
    int cellRemainder = 34; // DISTANCE FROM BOTTOM OF COMMENT LABEL TO BOTTOM OF CELL
    int labelHeightAddition = 18;
    
    // VARIABLES . CRUNCHED
    int linesCount = [self returnLineCountForCommentCell : text : typeIsComment] - 1;
    int labelHeight = labelHeightOneLine + (labelHeightAddition * linesCount);
    int cellHeight = labelOffsetY + labelHeight + [self returnRelativeSizeForThisScreen:cellRemainder];
    
    // RETURN
    return cellHeight;
    
}
- (CGRect) returnFrameForCommentLabel : (UILabel *)label : (NSString *)text : (BOOL)typeIsComment {

    // VARIABLES . PRESET
    int labelHeightOneLine = 21;
    int labelHeightAddition = 18;

    // VARIABLES . CRUNCHED
    int linesCount = [self returnLineCountForCommentCell : text : typeIsComment] - 1;

    // CALCULATE
    int labelHeight = labelHeightOneLine + (labelHeightAddition * linesCount);

    // RETURN
    return CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, labelHeight);
    
}
- (int) returnLineCountForCommentCell : (NSString *)text : (BOOL)typeIsComment {

    int fontSize = 15;
    int labelWidth;
    int labelWidthAdjustment = 0;

    UIFont *font = [UIFont systemFontOfSize: [self returnRelativeSizeForThisScreen:fontSize] ];
    
    if (typeIsComment) {
        
        labelWidth = [self returnRelativeSizeForThisScreen:275];
        
    } else {
        
        labelWidth = [self returnRelativeSizeForThisScreen:241];
        
    }
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:NSKernAttributeName value:@-0.5 range:NSMakeRange(0, text.length)];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,labelWidth - labelWidthAdjustment,1000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);

    if (lines.count > 0) {
        return (int)lines.count;
    } else {
        return 1;
    }
    
}
- (int) returnLineCountForTitle : (NSString *)text {
    
    // THESE VALUES ARE FROM PaprTableCell.labelTitle01
    int labelWidth = [self returnRelativeSizeForThisScreen:325];
    // UIFont *font = [UIFont boldSystemFontOfSize: [self returnRelativeSizeForThisScreen:23] ];
    UIFont *font = [UIFont systemFontOfSize:[self returnRelativeSizeForThisScreen:23] weight:UIFontWeightBold];

    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:NSKernAttributeName value:@-0.8 range:NSMakeRange(0, text.length)];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,labelWidth,1000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    
    if (lines.count > 0) {
        return (int)lines.count;
    } else {
        return 1;
    }
    
}
- (int) returnLineCountForDescription : (NSString *)text : (UILabel *)labelDescription {
    
    // THESE VALUES ARE FROM PaprTableCell.labelDescription
    int labelWidth = [self returnRelativeSizeForThisScreen:325];
    // UIFont *font = [UIFont boldSystemFontOfSize: [self returnRelativeSizeForThisScreen:23] ];
    UIFont *font = [UIFont systemFontOfSize:[self returnRelativeSizeForThisScreen:16] weight:UIFontWeightRegular];

    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:NSKernAttributeName value:@-0.5 range:NSMakeRange(0, text.length)];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,labelWidth,1000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    
    if (lines.count > 0) {
        return (int)lines.count;
    } else {
        return 1;
    }
    
}

#pragma mark - HELPER METHODS (PRE v1.4)

- (int) returnRelativeSizeForThisScreen : (int) sizeRCVD {

    float screenWidth;
    float multiplier = 0.5622;
    
    if ([[UIScreen mainScreen] bounds].size.width < 321) {
        screenWidth = 320;
    } else if ([[UIScreen mainScreen] bounds].size.width < 376) {
        screenWidth = 375;
    } else if ([[UIScreen mainScreen] bounds].size.width < 415) {
        screenWidth = 414;
    }

    // 320 x 568
    // 375 x 667
    // 414 x 736
    
    float relativeSize = (sizeRCVD * screenWidth) / 375;
    
    return (int)relativeSize;
    
}
- (NSArray *) returnArrayFromOptionsArray : (NSArray *)arrayRCVD {

    NSMutableArray *arrayOfPaprItemsEDITED = [[NSMutableArray alloc] init];
    
    for (NSDictionary *itemDictionary in arrayRCVD) {
        
        NSDictionary *paprItemDictionary = [[NSDictionary alloc] initWithDictionary: [itemDictionary objectForKey:@"Item"] ];
        
        [arrayOfPaprItemsEDITED addObject:paprItemDictionary];
        
    }
    
    NSArray *arrayOfPaprItemsFINAL = [[NSArray alloc] initWithArray: arrayOfPaprItemsEDITED ];
    
    return arrayOfPaprItemsFINAL;
}
- (int) updatecurrentNotificationCount : (NSArray *)notificationsRCVD {

    //////// TESTING . REMOVE . FROM HERE
    // [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"lastActiveNotificationID"];
    // [[NSUserDefaults standardUserDefaults] synchronize];
    //////// TESTING . REMOVE . TO HERE
    
    self.currentNotificationCount = 0;
    
    NSString *lastActiveNotificationID = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastActiveNotificationID"];

    for (NSDictionary *thisNotificationDictionary in notificationsRCVD) {
    
        NSString *timestampFirstID;
        NSString *timestampID = [thisNotificationDictionary objectForKey:@"timestamp"];
        
        // GRAB FIRST ID TO SAVE LATER
        if (self.currentNotificationCount == 0) {
        
            timestampFirstID = timestampID;
            
        }
        
        // CHECK TO SEE IF THE NOTIFICATION IS NEW
        if ( [timestampID isEqualToString:lastActiveNotificationID] ) {
            
            [[NSUserDefaults standardUserDefaults] setObject:timestampFirstID forKey:@"lastActiveNotificationID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        
            break;
            
        } else {
        
            self.currentNotificationCount++;
            
        }
        
    }
    
    return self.currentNotificationCount;
    
}
- (int) returnNumberOfLinesForTextCell : (NSString *)text : (BOOL)serif : (int)labelWidth : (int)fontSize {
    
    int labelWidthAdjustment = 0;
    
    UIFont *font;
    if (serif) {
        font = [UIFont fontWithName:@"Georgia-Bold" size:fontSize];
    } else {
        font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightHeavy];
    }
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:NSKernAttributeName value:@-0.5 range:NSMakeRange(0, text.length)];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,labelWidth - labelWidthAdjustment,1000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    
    NSLog(@"returnNumberOfLinesF . TITLE(%i): %@ = %i", serif, text, (int)lines.count);
    
    return (int)lines.count;
    
}

#pragma mark - DATE METHODS

- (NSString *) returnTimestamp {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd-HH-mm-ss-SS"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"US/Eastern"]];
    NSString *timestampString = [dateFormat stringFromDate:[NSDate date]];
    
    return timestampString;
    
}
- (BOOL) thisPostIsFresh : (NSString *)timestampRCVD {
    
    NSDate *dateNow = [NSDate date];
    NSDate *dateTimestamp = [self returnDateFromTimestamp:timestampRCVD];
    NSDate *dateExpiration = [dateNow dateByAddingTimeInterval: -86400.0];
    
    if ([dateTimestamp compare: dateExpiration] == NSOrderedDescending) {
        return TRUE;
    } else {
        return FALSE;
    }
    
}
- (BOOL) thisPostIsNullFree : (NSString *)imageURL {
    
    if ( [imageURL isKindOfClass:[NSNull class]]) {
        return FALSE;
    } else {
        return TRUE;
    }
    
}
- (NSDate *) returnDateFromTimestamp : (NSString *)timestampRCVD {

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd-HH-mm-ss-SS"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"US/Eastern"]];
    NSDate *timestampDate = [dateFormat dateFromString:timestampRCVD];
    
    return timestampDate;

}
- (NSString *) returnTimestampFromDate : (NSDate *)dateRCVD {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd-HH-mm-ss-SS"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"US/Eastern"]];
    NSString *timestampString = [dateFormat stringFromDate:dateRCVD];
    
    return timestampString;
    
}
- (NSString *) returnHumanDateString : (NSString *)timestampRCVD {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
//    NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
//    dateFormatter.locale = frLocale;
    
    dateFormatter.doesRelativeDateFormatting = YES;
    
    NSDate *dateTimestamp = [self returnDateFromTimestamp:timestampRCVD];
//    NSTimeInterval  tiNow = [dateTimestamp timeIntervalSinceReferenceDate];
////    NSDate * newNow = [NSDate dateWithTimeIntervalSinceReferenceDate:tiNow];
//    
//    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:tiNow];
    NSString *dateString = [dateFormatter stringFromDate:dateTimestamp];
    
    return dateString;
    
}
- (NSString *) returnHumanDateStringFancy : (NSString *)timestampRCVD {

    NSDate *dateRCVD = [self returnDateFromTimestamp:timestampRCVD];
    
//    NSDate *timeAgoDate = [NSDate dateWithTimeIntervalSinceNow: nil ];
//    NSLog(@"Time Ago: %@", timeAgoDate.timeAgoSinceNow);
    NSLog(@"Time Ago: %@", dateRCVD.shortTimeAgoSinceNow);
    
    return dateRCVD.shortTimeAgoSinceNow;
    
}
- (NSString *) returnTimeRemaining : (NSString *)timestampRCVD {
    
    NSDate *dateNow = [NSDate date];
    NSDate *dateTimestamp = [self returnDateFromTimestamp:timestampRCVD];
    NSDate *dateExpiration = [dateTimestamp dateByAddingTimeInterval: 86400.0];
    
    NSTimeInterval remainingSec = [dateExpiration timeIntervalSinceDate:dateNow];
    
    int timeRemaingInteger = ceil(remainingSec / 3600);
    
    NSLog(@"remainingSec = %f", remainingSec);
    NSLog(@"< %i hour(s) left", timeRemaingInteger);
    
    if (timeRemaingInteger == 1) {
        return [NSString stringWithFormat:@"%i\nhr", timeRemaingInteger];
    } else {
        return [NSString stringWithFormat:@"%i\nhrs", timeRemaingInteger];
    }
    
}


#pragma mark - Singleton Methods

+ (DataController *) dc {
    
    static DataController *_dc;
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _dc = [[self alloc] init];
    });
    
    return _dc;
    
}





@end

