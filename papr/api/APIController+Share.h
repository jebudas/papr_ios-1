//
//  APIController+Share.h
//  papr
//
//  Created by Brian WF Tobin on 5/23/18.
//  Copyright © 2018 Jebudas Communications, Inc. All rights reserved.
//

#import "APIController.h"

typedef void(^ShareSuccess)(NSDictionary *ShareDictionary);
typedef void(^ShareFailure)(NSError *error);


@interface APIController (Share)

// GET SHARE URL
- (void) getShareURL:(NSDictionary *)parameters success:(ShareSuccess)success failure:(ShareFailure)failure;
// POST SHARE URL
- (void) postShareURL:(NSDictionary *)parametersRCVD success:(ShareSuccess)success failure:(ShareFailure)failure;

@end
