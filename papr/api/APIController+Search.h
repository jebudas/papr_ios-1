//
//  APIController+Search.h
//  papr
//
//  Created by Brian WF Tobin on 9/22/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "APIController.h"

typedef void(^SearchSuccess)(NSDictionary *SearchDictionary);
typedef void(^SearchFailure)(NSError *error);


@interface APIController (Search)

// GET FEATURED USERS
- (void) getFeatured:(NSDictionary *)parameters success:(SearchSuccess)success failure:(SearchFailure)failure;
// GET SEARCH USERS
- (void) getUsers:(NSDictionary *)parametersRCVD success:(SearchSuccess)success failure:(SearchFailure)failure;


@end
