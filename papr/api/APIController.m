//
//  APIController.m
//  papr
//
//  Created by Brian WF Tobin on 8/8/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "APIController.h"


@implementation APIController

- (id) init {
    
    self = [super init];
    if (self) {
        
    }
    
    return self;
    
}

#pragma mark - API METHODS

- (void) apiGET : (NSString *)urlRCVD parameters:(NSDictionary *)parametersRCVD success:(ApiControllerSuccess)success failure:(ApiControllerFailure)failure {
    
    AFHTTPSessionManager *httpSession = [self returnAFHTTPSessionManager];
    AFJSONResponseSerializer *jsonResponseSerializer = [self returnAFJSONResponseSerializer];
    httpSession.responseSerializer = jsonResponseSerializer;
    
    NSLog(@"APIController . apiGET . urlRCVD = %@", urlRCVD);
    
    // [self quickPingStart];
    
    [httpSession GET:urlRCVD parameters:parametersRCVD progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        // [self quickPingStop : urlRCVD];

        NSDictionary *jsonDictionary;
        if ([responseObject isKindOfClass:[NSString class]]) {
            NSData *responseData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            jsonDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            jsonDictionary = responseObject;
        } else {
            NSLog(@"APIController . apiGET . responseObject IS NOT A STRING OR A DICTIONARY!");
        }

        success(task, jsonDictionary);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"APIController . apiGET . httpSession.req.http = %@", httpSession.requestSerializer.HTTPRequestHeaders);
        
        if ( [self iHaveInternet] ) {
            
            NSLog(@"iHaveInternet . YUPP");
            
        } else {
            
            NSDictionary *alertDictionary = @{@"alert_type":@"internet"};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.pushPaprAlertVC" object:nil userInfo:alertDictionary];
            
        }
        //NSLog(@"APIController . apiGET . task.response = %@", task.response);
        //NSLog(@"APIController . apiGET . failure.error = %@", error);
        
        failure(task, error);
        
    }];
    
}
- (void) apiPOST : (NSString *)urlRCVD parameters:(NSDictionary *)parametersRCVD success:(ApiControllerSuccess)success failure:(ApiControllerFailure)failure {

    AFHTTPSessionManager *httpSession = [self returnAFHTTPSessionManager];
    AFJSONResponseSerializer *jsonResponseSerializer = [self returnAFJSONResponseSerializer];
    httpSession.responseSerializer = jsonResponseSerializer;

    NSLog(@"APIController . apiPOST . urlRCVD = %@", urlRCVD);
    NSLog(@"APIController . apiPOST . httpSession.req.http = %@", httpSession.requestSerializer.HTTPRequestHeaders);

    [httpSession POST:urlRCVD parameters:parametersRCVD progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *jsonDictionary;
        if ([responseObject isKindOfClass:[NSString class]]) {
            NSData *responseData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            jsonDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            jsonDictionary = responseObject;
        } else {
            NSLog(@"APIController . apiPOST . responseObject IS NOT A STRING OR A DICTIONARY!");
        }
        
        success(task, jsonDictionary);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"APIController . apiPOST . httpSession.req.http = %@", httpSession.requestSerializer.HTTPRequestHeaders);
        
        if ( [self iHaveInternet] ) {
            
            NSLog(@"iHaveInternet . YUPP");
            
        } else {
            
            NSDictionary *alertDictionary = @{@"alert_type":@"internet"};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.pushPaprAlertVC" object:nil userInfo:alertDictionary];
            
        }

        // NSLog(@"APIController . apiPOST . task.response = %@", task.response);
        // NSLog(@"APIController . apiPOST . failure.error = %@", error);

        failure(task, error);
        
    }];
    
}

#pragma mark - API TOOLS

- (BOOL) iHaveInternet {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
    
}
- (void) quickPingStart {

    self.start=[NSDate date];

}
- (void) quickPingStop : (NSString *)urlRCVD {
    
    NSDate *end=[NSDate date];
    double latency = [end timeIntervalSinceDate:self.start];
    
    NSLog(@"TIME (%@) = %f", urlRCVD, latency);
    NSLog(@"");
    
}

#pragma mark - API VOTING

// VOTING
- (NSDictionary *) returnVoteDictionary {

    // API CALL
    self.voteDictionary = [[NSMutableDictionary alloc] init];

    if (self.arrayOfComments.count > 0) {
        [self.voteDictionary setObject:self.arrayOfComments forKey:@"array_of_comments"];
    }

    if (self.arrayOfLikes.count > 0) {
        [self.voteDictionary setObject:self.arrayOfLikes forKey:@"array_of_likes"];
    }

    if (self.arrayOfViews.count > 0) {
        [self.voteDictionary setObject:self.arrayOfViews forKey:@"array_of_views"];
    }

    if (self.arrayOfVotesUp.count > 0) {
        [self.voteDictionary setObject:self.arrayOfVotesUp forKey:@"array_of_votes_up"];
    }

    if (self.arrayOfVotesDown.count > 0) {
        [self.voteDictionary setObject:self.arrayOfVotesDown forKey:@"array_of_votes_down"];
    }

    NSLog(@"self.voteDictionary = %@", self.voteDictionary);
    
    NSDictionary *returnDictionary = [[NSDictionary alloc] initWithDictionary:self.voteDictionary];
    
    return returnDictionary;
    
}
- (void) addComments : (NSString *)commentRCVD {
    
    if ( ! self.arrayOfComments ) {
        self.arrayOfComments = [[NSMutableArray alloc] init];
    }
    
    [self.arrayOfComments addObject:commentRCVD];
    
}
- (void) addLikes : (NSString *)likeRCVD {
    
    if ( ! self.arrayOfLikes ) {
        self.arrayOfLikes = [[NSMutableArray alloc] init];
    }
    
    [self.arrayOfLikes addObject:likeRCVD];
    
}
- (void) removeLikes : (NSString *)likeRCVD {
    
    if ( ! self.arrayOfLikes ) {
        return;
    }
    
    [self.arrayOfLikes removeObject:likeRCVD];
    
}
- (void) addViews : (NSString *)viewRCVD {
    
    if ( ! self.arrayOfViews ) {
        self.arrayOfViews = [[NSMutableArray alloc] init];
    }
    
    [self.arrayOfViews addObject:viewRCVD];
    
}
- (void) addUpVotes : (NSString *)voteRCVD {

    if ( ! self.arrayOfVotesUp ) {
        self.arrayOfVotesUp = [[NSMutableArray alloc] init];
    }

    [self.arrayOfVotesUp addObject:voteRCVD];
    
    NSLog(@"self.arrayOfVotesUp = %@", self.arrayOfVotesUp);

}
- (void) removeUpVotes : (NSString *)voteRCVD {
    
    if ( ! self.arrayOfVotesUp ) {
        return;
    }
    
    [self.arrayOfVotesUp removeObject:voteRCVD];
    
}
- (void) addDownVotes : (NSString *)voteRCVD {
    
    if ( ! self.arrayOfVotesDown ) {
        self.arrayOfVotesDown = [[NSMutableArray alloc] init];
    }
    
    [self.arrayOfVotesDown addObject:voteRCVD];
    
}
- (void) removeDownVotes : (NSString *)voteRCVD {
    
    if ( ! self.arrayOfVotesDown ) {
        return;
    }
    
    [self.arrayOfVotesDown removeObject:voteRCVD];
    
}


- (NSString *) returnTokenAuth {

    NSString *tokenString = [NSString stringWithFormat:@"Token %@", [[DataController dc] returnUserToken]];
    
    return tokenString;
    
}
- (AFHTTPSessionManager *) returnAFHTTPSessionManager {

    AFHTTPSessionManager *httpSession = [[AFHTTPSessionManager alloc] init];
    httpSession.requestSerializer = [AFJSONRequestSerializer serializer];
    [httpSession.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [httpSession.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    if ( [[DataController dc] returnUserToken] ) {
        [httpSession.requestSerializer setValue:[self returnTokenAuth] forHTTPHeaderField:@"Authorization"];
    }

    return httpSession;
    
}
- (AFJSONResponseSerializer *) returnAFJSONResponseSerializer {

    AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
    [jsonAcceptableContentTypes addObject:@"text/plain"];
    jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;

    return jsonResponseSerializer;

}

#pragma mark - Singleton Methods

+ (APIController *) api {
    
    static APIController *_api;
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _api = [[self alloc] init];
    });
    
    return _api;
    
}


@end
