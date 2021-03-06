//
//  TestValidations.m
//  ManagementSDK
//
//  Created by Boris Bügling on 18/11/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

//
//  TestEntries.m
//  ManagementSDK
//
//  Created by Boris Bügling on 23/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <Keys/ContentfulSDKKeys.h>
#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

#import "CMASpace+Private.h"

#import <VCRURLConnection/VCR.h>
#import "TestHelpers.h"

static CMASpace* space;

void _itTestWithValidation(id self, int lineNumber, const char *fileName, NSString *name,
                           Class specClass, CMAValidation* validation, CDAFieldType type, CDAFieldType itemType) {

    it(name, ^{
        [TestHelpers startRecordingOrLoadCassetteForTestNamed:name
                                                     forClass:specClass];
        waitUntil(^(DoneCallback done) {

            CMAField* field = [CMAField fieldWithName:@"test" type:type];
            [field addValidation:validation];

            if (itemType != CDAFieldTypeNone) {
                field.itemType = itemType;
            }

            NSCAssert(space, @"Test space could not be found.");
            [space createContentTypeWithName:@"test" fields:@[ field ] success:^(CDAResponse *response, CMAContentType *contentType) {
                expect(contentType).toNot.beNil();
                expect([contentType.fields.firstObject validations].firstObject).to.equal(validation);

                [contentType publishWithSuccess:^{
                    [contentType unpublishWithSuccess:^{
                        [contentType deleteWithSuccess:^{
                            done();
                        } failure:^(CDAResponse *response, NSError *error) {
                            XCTFail(@"Error: %@", error);

                            done();
                        }];
                    } failure:^(CDAResponse *response, NSError *error) {
                        XCTFail(@"Error: %@", error);

                        done();
                    }];
                } failure:^(CDAResponse *response, NSError *error) {
                    XCTFail(@"Error: %@", error);

                    done();
                }];
            } failure:^(CDAResponse *response, NSError *error) {
                XCTFail(@"Error: %@", error);

                done();
            }];
        });
        [TestHelpers endRecordingAndSaveWithName:name
                                        forClass:specClass];
    });
}

SpecBegin(Validation)

describe(@"CMA", ^{
    __block CMAClient* client;
    __block CMAContentType* contentType;

    beforeAll(^{

        NSString *beforeEachTestName = @"fetch-space-before-each";
        [TestHelpers startRecordingOrLoadCassetteForTestNamed:beforeEachTestName
                                                     forClass:self.class];
        waitUntil(^(DoneCallback done) {
            NSString* token = [ContentfulSDKKeys new].managementAPIAccessToken;

            client = [[CMAClient alloc] initWithAccessToken:token];

            [client fetchSpaceWithIdentifier:@"hvjkfbzcwrfn"
                                     success:^(CDAResponse *response, CMASpace *mySpace) {
                                         expect(mySpace).toNot.beNil();
                                         space = mySpace;

                                         [space fetchContentTypesWithSuccess:^(CDAResponse *response,
                                                                               CDAArray *array) {
                                             expect(array).toNot.beNil();

                                             for (CMAContentType* ct in array.items) {
                                                 if ([ct.identifier isEqualToString:@"6FxqhReTPUuYAYW8gqOwS"]) {
                                                     contentType = ct;
                                                     break;
                                                 }
                                             }

                                             expect(contentType.identifier).toNot.beNil();

                                             done();
                                         } failure:^(CDAResponse *response, NSError *error) {
                                             XCTFail(@"Error: %@", error);

                                             done();
                                         }];
                                     } failure:^(CDAResponse *response, NSError *error) {
                                         XCTFail(@"Error: %@", error);

                                         done();
                                     }];
        });
        [TestHelpers endRecordingAndSaveWithName:beforeEachTestName
                                        forClass:self.class];
    });

    _itTestWithValidation(self, __LINE__, __FILE__, @"can_create_ContentType_with_size_validation", self.class, [CMAValidation validationOfArraySizeWithMinimumValue:@5 maximumValue:@10], CDAFieldTypeArray, CDAFieldTypeEntry);

    _itTestWithValidation(self, __LINE__, __FILE__, @"can_create_ContentType_with_size_validation_without_max_value", self.class, [CMAValidation validationOfArraySizeWithMinimumValue:@3 maximumValue:nil], CDAFieldTypeArray, CDAFieldTypeEntry);

    _itTestWithValidation(self, __LINE__, __FILE__, @"can_create_ContentType_with_content_type_validation", self.class, [CMAValidation validationOfLinksAgainstContentTypeIdentifiers:@[@"6FxqhReTPUuYAYW8gqOwS"]], CDAFieldTypeEntry, CDAFieldTypeNone);

    _itTestWithValidation(self, __LINE__, __FILE__, @"can_create_ContentType_with_content_type_validation_on_array", self.class, [CMAValidation validationOfLinksAgainstContentTypeIdentifiers:@[@"6FxqhReTPUuYAYW8gqOwS"]], CDAFieldTypeArray, CDAFieldTypeEntry);

    _itTestWithValidation(self, __LINE__, __FILE__, @"can_create_ContentType_with_mime_type_group_validation", self.class, [CMAValidation validationOfLinksAgainstMimeTypeGroup:@"image"], CDAFieldTypeLink,CDAFieldTypeAsset);

    _itTestWithValidation(self, __LINE__, __FILE__, @"can_create_ContentType_with_regex_validation", self.class, [CMAValidation validationOfRegularExpression:@"[A-Z]*" flags:@""], CDAFieldTypeSymbol, CDAFieldTypeNone);

    _itTestWithValidation(self, __LINE__, __FILE__, @"can_create_ContentType_with_value_validation", self.class, [CMAValidation validationOfValueInArray:@[@"a", @"b"]], CDAFieldTypeSymbol, CDAFieldTypeNone);

    _itTestWithValidation(self, __LINE__, __FILE__, @"can_create_ContentType_with_range_validation", self.class, [CMAValidation validationOfValueRangeWithMinimumValue:@3 maximumValue:@5], CDAFieldTypeInteger, CDAFieldTypeNone);

    it(@"implements -hash for validations", ^{
        CMAValidation* v1 = [CMAValidation validationOfValueInArray:@[@"a", @"b"]];
        CMAValidation* v2 = [CMAValidation validationOfValueInArray:@[@"a", @"b"]];

        expect(v1.hash).to.equal(v2.hash);
    });

    it(@"implements -isEqual for validations", ^{
        CMAValidation* v1 = [CMAValidation validationOfValueInArray:@[@"a", @"b"]];
        CMAValidation* v2 = [CMAValidation validationOfValueInArray:@[@"a", @"b"]];

        expect([v1 isEqual:v2]).to.beTruthy();
    });
});

SpecEnd
