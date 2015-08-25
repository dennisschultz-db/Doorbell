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
#import <CloudantToolkit/CDTObjectMapper.h>
@protocol CDTDataObject;
@protocol CDTPropertySerializer;

/**
 The CDTDataObjectMapper is used to convert data objects from Object to CDTDocumentRevision (and vice versa).  It conforms to the CDTObjectMapper protocol.
 */
@interface CDTDataObjectMapper : NSObject<CDTObjectMapper>

/**
 Set a property serializer for a class name / data type.
 @param serializer The serializer to set.
 @param className The class associated with the serializer.
 @param dataType The data type associated with the serializer.
 */
-(void)setPropertySerializer: (id<CDTPropertySerializer>) serializer forClassName: (NSString*) className withDataType: (NSString*) dataType;

@end
