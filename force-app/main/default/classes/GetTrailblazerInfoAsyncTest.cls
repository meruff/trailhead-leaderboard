/**
* @author meruff
* @date 5/29/20
*
* Unit Tests for GetTrailblazerInfoAsyncTest
*/
@IsTest
private class GetTrailblazerInfoAsyncTest {
    @TestSetup
    static void setUpData() {
        insert new List<Trailblazer__c>{
            new Trailblazer__c(
                Name = 'mat ruff',
                Profile_Handle__c = 'matruff'
            ),
            new Trailblazer__c(
                Name = 'Test 1',
                Profile_Handle__c = 'test1'
            ),
            new Trailblazer__c(
                Name = 'Test 2',
                Profile_Handle__c = 'test2'
            ),
            new Trailblazer__c(
                Name = 'Test 3',
                Profile_Handle__c = 'test3'
            ),
            new Trailblazer__c(
                Name = 'Test 4',
                Profile_Handle__c = 'test4'
            ),
            new Trailblazer__c(
                Name = 'Test 5',
                Profile_Handle__c = 'test5'
            )
        };
    }

    @IsTest
    static void testBehavior() {
        // Arrange


        // Act 
        Test.startTest();

        Test.stopTest();

        // Assert
        System.assert(true);
    }
}