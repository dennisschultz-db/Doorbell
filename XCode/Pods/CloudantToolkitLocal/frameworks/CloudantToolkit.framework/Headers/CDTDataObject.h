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
@class CDTDataObjectMetadata;

/**
 The CDTDataObject protocol is used to store metadata for the CDTDataObjectMapper.  It must be conformed to for data objects using the DataObjectMapper
 */
@protocol CDTDataObject

/**
 Metadata associated with the data object.
 */
@property (strong, nonatomic, readwrite) CDTDataObjectMetadata *metadata;

@end
