//
//  APIController+Comments.m
//  papr
//
//  Created by Brian WF Tobin on 9/17/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "APIController+Comments.h"


@implementation APIController (Comments)


// GET COMMENTS
- (void) getComments:(NSDictionary *)commentDictionaryRCVD success:(CommentsSuccess)success failure:(CommentsFailure)failure {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/%@/comments/threads/?format=json", PAPR_API_BASE_URL, PAPR_API_VERSION];
    
    [self apiGET:path parameters:commentDictionaryRCVD success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"responseObject = %@", responseObject);
        
        NSDictionary *responseDictionary = [[NSDictionary alloc] initWithDictionary: responseObject ];
        
        success(responseDictionary);

/* PRE v1.4 . DEPRECATED
        NSLog(@"responseObject = %@", responseObject);
        
        NSArray *responseItems = [[NSArray alloc] initWithArray:[responseObject objectForKey:@"Items"]];
        NSDictionary *responseDictionary;
        if (responseItems.count > 0) {
            responseDictionary = [[NSDictionary alloc] initWithDictionary: [responseItems objectAtIndex:0] ];
        } else {
            responseDictionary = [[NSDictionary alloc] init];
        }
        
        success(responseDictionary);
*/
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}
// PUBLISH COMMENT
- (void) publishComment:(NSDictionary *)commentDictionaryRCVD success:(CommentsSuccess)success failure:(CommentsFailure)failure {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/%@/comments/threads/?format=json", PAPR_API_BASE_URL, PAPR_API_VERSION];

    [self apiPOST:path parameters:commentDictionaryRCVD success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *responseItems = [[NSArray alloc] initWithArray:[responseObject objectForKey:@"Items"]];
        NSDictionary *responseDictionary;
        if (responseItems.count > 0) {
            responseDictionary = [[NSDictionary alloc] initWithDictionary: [responseItems objectAtIndex:0] ];
        } else {
            responseDictionary = [[NSDictionary alloc] init];
        }
        
        success(responseDictionary);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}
// GET REPLIES
- (void) getReplies:(NSDictionary *)commentDictionaryRCVD success:(CommentsSuccess)success failure:(CommentsFailure)failure {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/%@/comments/replies/?format=json", PAPR_API_BASE_URL, PAPR_API_VERSION];
    
    [self apiGET:path parameters:commentDictionaryRCVD success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseDictionary = [[NSDictionary alloc] initWithDictionary: responseObject ];
        
        success(responseDictionary);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}


// GET NOTIFICATIONS
- (void) getNotifications:(CommentsSuccess)success failure:(CommentsFailure)failure {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/notifications/?format=json", PAPR_API_BASE_URL];
    
    NSDictionary *parameters = @{@"publisher_id" : [[DataController dc] returnMyUserID] };
    
    [self apiGET:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *responseItems = [[NSArray alloc] initWithArray:[responseObject objectForKey:@"Items"]];
        NSDictionary *responseDictionary;
        if (responseItems.count > 0) {
            responseDictionary = [[NSDictionary alloc] initWithDictionary: [responseItems objectAtIndex:0] ];
        } else {
            responseDictionary = [[NSDictionary alloc] initWithDictionary:responseObject];
        }
        
        success(responseDictionary);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}

// PUBLISH NOTIFICATIONS
- (void) postNotifications:(NSDictionary *)notificationsDictionaryRCVD success:(CommentsSuccess)success failure:(CommentsFailure)failure {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/notifications/?format=json", PAPR_API_BASE_URL];
    
    NSDictionary *parameters = @{@"notification_dictionary" : notificationsDictionaryRCVD};
    
    [self apiPOST:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *responseItems = [[NSArray alloc] initWithArray:[responseObject objectForKey:@"Items"]];
        NSDictionary *responseDictionary;
        if (responseItems.count > 0) {
            responseDictionary = [[NSDictionary alloc] initWithDictionary: [responseItems objectAtIndex:0] ];
        } else {
            responseDictionary = [[NSDictionary alloc] init];
        }
        
        success(responseDictionary);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}

// TIMESTAMP
- (NSString *) returnFBTimestamp {
    
    NSString *timestamp = [[NSProcessInfo processInfo] globallyUniqueString];
    
    int digit_08 = arc4random_uniform(9);
    int digit_18 = 8 - digit_08;
    
    NSString *string_08 = [NSString stringWithFormat:@"%i", digit_08];
    NSString *string_18 = [NSString stringWithFormat:@"%i", digit_18];
    
    timestamp = [timestamp stringByReplacingCharactersInRange:NSMakeRange(8, 1) withString:string_08];
    timestamp = [timestamp stringByReplacingCharactersInRange:NSMakeRange(18, 1) withString:string_18];
    
    return timestamp;
    
}


@end
