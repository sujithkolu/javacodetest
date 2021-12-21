@isTest
public class TestFactory {

    public static list<Base_Object__c> createBaseObjRecord(){
       
       list<Base_Object__c> baseObjLst = new list<Base_Object__c>();
       Base_Object__c baseObj1 = new Base_Object__c();
       baseObj1.Name = 'Object 1';
       baseObj1.Sobject_Name__c = 'Contact';
       baseObj1.Sobject_API_Name__c = 'Contact';
       baseObj1.Search_Fields__c = 'Name,Email';
       baseObj1.Search_Results__c = 'Name,Account.Industry,Email,Phone';
       baseObjLst.add(baseObj1);
        
       Base_Object__c baseObj2 = new Base_Object__c();
       baseObj2.Name = 'Object 2';
       baseObj2.Sobject_Name__c = 'Account';
       baseObj2.Sobject_API_Name__c = 'Account';
       baseObj2.Search_Fields__c = 'Name,Type,CustomerPriority__c';
       baseObj2.Search_Results__c = 'Name,primary_email__c,Type';
       baseObjLst.add(baseObj2);
       insert baseObjLst;
        
       return baseObjLst;
    }
}