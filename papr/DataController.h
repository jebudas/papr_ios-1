
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "NSDate+DateTools.h"


@interface DataController : NSObject {
    
}

// PROPERTIES
// ++++++++ v1.4 ++++++++ //
@property (nonatomic, assign) int paprIndexCurrent;
@property (nonatomic, assign) int paprIndexSelected;
@property (nonatomic, assign) BOOL iAmShowingAlert;

// ++++++++ PRE v1.4 ++++++++ //
@property (nonatomic, assign) BOOL testMode;
@property (nonatomic, assign) CGRect frameFullScreen;
@property (nonatomic, assign) int currentPaprIndex;
@property (nonatomic, assign) int currentPaprCount;
@property (nonatomic, assign) int currentPaprViewsCount;
@property (nonatomic, assign) BOOL currentPaprWasEdited;
@property (nonatomic, strong) NSDictionary *currentPaprDictionary;
@property (nonatomic, strong) NSDictionary *currentUserDictionary;
@property (nonatomic, assign) BOOL iUpdatedMySubscriberList;
@property (nonatomic, assign) BOOL userNeedsUpdate;
@property (nonatomic, strong) NSString *currentZone;
// NOTIFICATIONS
@property (nonatomic, assign) int currentNotificationCount;
@property (nonatomic, strong) NSArray *arrayOfNotifications;
// PROPERTIES . CELLS
@property (nonatomic, assign) BOOL cellSliderIsOpen;
@property (nonatomic, assign) BOOL cellSliderIsMoving;
@property (nonatomic, assign) int cellOpenTag;
@property (nonatomic, strong) NSMutableDictionary *cellOpenDictionary;


// DATA METHODS . PAPR
- (void) createPaprDictionaryWithDictionary : (NSDictionary *)newDictionaryRCVD;
- (void) updatePaprDictionaryWithNewPosts : (NSArray *)updatedArrayRCVD;
- (void) updatePaprDictionaryWithNewHeader : (NSDictionary *)updatedDictionaryRCVD;
- (void) updatePaprDictionaryWithDictionary : (NSDictionary *)updateDictionaryRCVD;
- (void) updatePaprHeaderDictionaryWithKeyValue : (NSDictionary *)keyValueRCVD;
- (NSDictionary *) updateMyPaprHeaderDictionary;
- (NSArray *) returnArrayOfFreshPaprDictionaries : (NSArray *)arrayOfPaprDictionariesRCVD;
- (NSArray *) returnArrayOfSortedPaprSubscriptions : (NSArray *)arrayOfPaprSubscriptionsRCVD;
- (NSArray *) returnArrayOfFreshPaprItems : (NSArray *)paprItemsRCVD;
- (NSArray *) returnMyActivePaprItems;
- (NSDictionary *) returnMyPaprDictionary;
- (NSDictionary *) returnMyPaprHeaderDictionary;
- (BOOL) returnIfWeUseSerifs;
- (void) saveMyPaprDictionary : (NSDictionary *)dictionaryRCVD;

// DATA METHODS . POST
- (NSString *) returnPostID;
- (NSString *) returnImageStringForUser : (NSString *)userID;
- (NSString *) returnImageStringURL : (NSString *)stringRCVD;
- (NSDictionary *) returnFullEditionDictionaryWithNewPost : (NSDictionary *)postDictionaryRCVD;

// DATA METHODS . SHARE
- (NSString *) returnShortURL : (NSString *)postID;
- (NSString *) decodeTopSecretPublisherCharacter : (NSString *)charRCVD;

// DATA METHODS . USER
- (void) createUserDictionaryWithDictionary : (NSDictionary *)newDictionaryRCVD;
- (void) updateUserDictionaryWithNewLocation : (NSDictionary *)updatedDictionaryRCVD;
- (void) updateUserDictionaryWithNewProfile : (NSDictionary *)profileDictionaryRCVD;
- (void) updateUserDictionaryWithNewSettings : (NSDictionary *)settingsDictionaryRCVD;
- (void) updateUserDictionaryWithSubscriptions : (NSArray *)updatedArrayRCVD;
- (void) updateUserSubscriptions:(NSString *)subscriptionRCVD subscribeToThisUser:(BOOL)newSubscriptionRCVD;
- (void) moveUserSubscriptionsFromIndex:(int)fromIndex toIndex:(int)toIndex;
- (void) updateUserToken : (NSString *)updatedTokenRCVD;
- (void) updateUserPostTotal;
- (NSArray *) returnUserSubscriptions;
- (NSString *) returnUserSubscriptionsAsString;
- (NSString *) returnUserToken;
- (NSString *) returnMyUserID;
- (NSString *) returnMyUsername;
- (NSString *) returnMyDisplayName;
- (NSString *) returnMyAvatarBucket;
- (NSString *) returnMyAvatarURL;
- (NSString *) returnRandomAvatarURL;
- (NSString *) returnMyMastURL;
- (NSDictionary *) returnMyUserDictionary;
- (void) saveMyUserDictionary : (NSDictionary *)dictionaryRCVD;


// DATA METHODS . TOOLS
- (BOOL) iSubscribeToThisPublisher : (NSString *)publisherID;
- (NSString *) returnAvatarURL : (NSString *)publisherID;
- (int) returnHeightForCommentCell : (NSString *)text : (BOOL)typeIsComment;
- (CGRect) returnFrameForCommentLabel : (UILabel *)label : (NSString *)text : (BOOL)typeIsComment;
- (int) returnLineCountForCommentCell : (NSString *)text : (BOOL)typeIsComment;
- (int) returnLineCountForTitle : (NSString *)text;
- (int) returnLineCountForDescription : (NSString *)text : (UILabel *)labelDescription;
- (int) returnRelativeSizeForThisScreen : (int) sizeRCVD;
- (NSArray *) returnArrayFromOptionsArray : (NSArray *)arrayRCVD;
- (int) updatecurrentNotificationCount : (NSArray *)notificationsRCVD;
- (int) returnNumberOfLinesForTextCell : (NSString *)text : (BOOL)serif : (int)labelWidth : (int)fontSize;

// NSDATE METHODS
- (NSString *) returnTimestamp;
- (BOOL) thisPostIsFresh : (NSString *)timestampRCVD;
- (NSString *) returnHumanDateString : (NSString *)timestampRCVD;
- (NSString *) returnHumanDateStringFancy : (NSString *)timestampRCVD;
- (NSString *) returnTimeRemaining : (NSString *)timestampRCVD;

// SINGLETON
+ (DataController *) dc;



@end
