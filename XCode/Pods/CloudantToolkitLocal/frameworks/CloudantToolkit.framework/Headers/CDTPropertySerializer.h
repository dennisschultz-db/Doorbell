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

/**
 Provides a custom serializer for a class.  You can handle cross-platform serialization of any object or override the default serialization of an object.  For example, CDTDataObjectMapper serializes NSDate objects.  However, you can use this extension to override how NSDate is serialized.  You might also provide serialization of CLLocation objects, which are currently ignored by the CDTDataObjectMapper.
 */
@protocol CDTPropertySerializer <NSObject>

/**
 Get the JSON representation for the property value.
 @param propertyValue The navtive property value to be serialized to a JSON dictionary.
 @param error Error that occurred during serilization or nil
 @return The JSON representation for the property value.
 */
-(id) propertyValueToJSONValue: (id) propertyValue error: (NSError**) error;

/**
 Get the property value from the JSON representation
 @param jsonValue The input JSON representation
 @param error Error that occurred during deserilization or nil
 @return The native property value
 */
-(id) jsonValueToPropertyValue: (id) jsonValue error: (NSError**) error;

@end
