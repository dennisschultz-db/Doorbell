/*
 * IBM Confidential OCO Source Materials
 *
 * 5725-I43 Copyright IBM Corp. 2015, 2015
 *
 * The source code for this program is not published or otherwise
 * divested of its trade secrets, irrespective of what has
 * been deposited with the U.S. Copyright Office.
 *
 */

#import <Foundation/Foundation.h>

@interface CDTHttpHelper : NSObject

@property NSURLRequestCachePolicy defaultCachePolicy;
@property NSTimeInterval defaultTimeout;

#pragma mark - HTTP Helper Methods
+(NSString*) buildLogStringForRequest: (NSURLRequest*) request clazz: (NSString*) clazz method: (NSString*) method;

-(void) sendPost: (NSURL*) requestUrl headers: (NSDictionary*) headers body: (NSDictionary*) body completionHandler: (void(^) (NSInteger httpStatus, NSDictionary *responseBody, NSError *requestError)) completionHandler;

-(void) sendPut: (NSURL*) requestUrl headers: (NSDictionary*) headers body: (NSDictionary*) body completionHandler: (void(^) (NSInteger httpStatus, NSDictionary *responseBody, NSError *requestError)) completionHandler;

-(void) sendDelete: (NSURL*) requestUrl headers: (NSDictionary*) headers completionHandler: (void(^) (NSInteger httpStatus, NSDictionary *responseBody, NSError *requestError)) completionHandler;

-(void) sendDelete: (NSURL*) requestUrl headers: (NSDictionary*) headers body: (NSDictionary*) body completionHandler: (void(^) (NSInteger httpStatus, NSDictionary *responseBody, NSError *requestError)) completionHandler;

-(void) sendGet: (NSURL*) requestUrl headers: (NSDictionary*) headers completionHandler: (void(^) (NSInteger httpStatus, NSDictionary *responseBody, NSError *requestError)) completionHandler;


#pragma mark - Binary Data Methods

-(void) sendPost: (NSURL*) requestUrl headers: (NSDictionary*) headers payload: (NSData*) payload completionHandler: (void(^) (NSInteger httpStatus, NSDictionary *responseBody, NSError *requestError)) completionHandler;

-(void) sendPut: (NSURL*) requestUrl headers: (NSDictionary*) headers payload: (NSData*) payload completionHandler: (void(^) (NSInteger httpStatus, NSDictionary *responseBody, NSError *requestError)) completionHandler;

@end
