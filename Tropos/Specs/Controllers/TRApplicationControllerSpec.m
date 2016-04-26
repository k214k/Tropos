@import CoreLocation;
@import TroposCore;
@import Quick;
@import Nimble;
#import <OCMock/OCMock.h>
#import "TRApplicationController.h"
#import "TRWeatherController.h"

@interface TRApplicationController (Tests)

@property (nonatomic) TRWeatherController *weatherController;
@property (nonatomic) TRLocationController *locationController;

@end

QuickSpecBegin(TRApplicationControllerSpec)

TRLocationController* (^locationControllerWithAuthorizationStatusAuthorizedAlwaysEqualTo) (BOOL) = ^TRLocationController* (BOOL enabled){
    TRLocationController *locationController = OCMPartialMock([[TRLocationController alloc] init]);
    OCMStub([locationController authorizationStatusEqualTo:kCLAuthorizationStatusAuthorizedAlways]).andReturn(enabled);
    return locationController;
};

describe(@"TRApplicationController", ^{
    describe(@"setMinimimBackgroundFetchIntervalForApplication:", ^{
        it(@"sets the interval to minimum when authorization is always", ^{
            UIApplication *application = OCMClassMock([UIApplication class]);
            TRApplicationController *applicationController = [TRApplicationController new];
            applicationController.locationController = locationControllerWithAuthorizationStatusAuthorizedAlwaysEqualTo(YES);

            [applicationController setMinimumBackgroundFetchIntervalForApplication:application];

            OCMVerify([application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum]);
        });

        it(@"sets the interval to never when authorization is not always", ^{
            UIApplication *application = OCMClassMock([UIApplication class]);
            TRApplicationController *applicationController = [TRApplicationController new];
            applicationController.locationController = locationControllerWithAuthorizationStatusAuthorizedAlwaysEqualTo(NO);

            [applicationController setMinimumBackgroundFetchIntervalForApplication:application];

            OCMVerify([application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalNever]);
        });
    });
});

QuickSpecEnd