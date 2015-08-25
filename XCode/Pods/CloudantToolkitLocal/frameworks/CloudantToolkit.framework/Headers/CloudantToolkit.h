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

#import <UIKit/UIKit.h>

//! Project version number for CloudantToolkit.
FOUNDATION_EXPORT double CloudantToolkitVersionNumber;

//! Project version string for CloudantToolkit.
FOUNDATION_EXPORT const unsigned char CloudantToolkitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <CloudantToolkit/PublicHeader.h>

#import <CloudantToolkit/CDTDataObjectMetadata.h>
#import <CloudantToolkit/CDTStore.h>
#import <CloudantToolkit/CDTQuery.h>
#import <CloudantToolkit/CDTCloudantQuery.h>
#import <CloudantToolkit/CDTObjectMapper.h>
#import <CloudantToolkit/CDTDataObject.h>
#import <CloudantToolkit/CDTDataObjectMapper.h>
#import <CloudantToolkit/CDTPropertySerializer.h>
#import <CloudantToolkit/CDTHttpHelper.h>
#import <CloudantToolkit/CDTOperation.h>
#import <CloudantToolkit/CDTStoreOperation.h>
#import <CloudantToolkit/CDTQueryOperation.h>
#import <CloudantToolkit/CDTCloudantQueryOperation.h>
#import <CloudantToolkit/CDTQueryCursor.h>

/** 
 * The CloudantToolkit class allows you to get the version and build date.
 */
@interface CloudantToolkit: NSObject

/**
 @return the version of CloudantToolkit
 */
+(NSString*) version;

/**
 @return the build date of CloudantToolkit
 */
+(NSString*) buildDate;
@end
