@isTest
public class DynamicSearchControllerTest {
    
     @isTest
    public static void testMethod1()
    {    
        list<Base_Object__c> baseObjLst = TestFactory.createBaseObjRecord();
        DynamicSearchController.getObjectNames();
        Map<string,string> fieldsandvalues = new Map<string,string>();
        fieldsandvalues.put('Name','Krishna');
        list<DynamicSearchController.FldsLabelAndAPIWrapper> rstFldValslst = new list<DynamicSearchController.FldsLabelAndAPIWrapper> ();
        DynamicSearchController.FldsLabelAndAPIWrapper rstFldVals = new DynamicSearchController.FldsLabelAndAPIWrapper ();
        rstFldVals.APIName='Name';
        rstFldVals.Name='Full Name';
        rstFldValslst.add(rstFldVals);
        DynamicSearchController.SobjectAndFieldWrapper  testData= DynamicSearchController.fetchQuery('Contact',fieldsandvalues,rstFldValslst);
        
        Map<String,String> resultVal = DynamicSearchController.fetchFieldNameMap ('Name','Test',fieldsandvalues);
    }

}