public class DynamicSearchController {
	
    public static string  nameKey ='';
    public static string  fieldValue ='';
    
    public class ObjLabelAndAPIWrapper{
        @AuraEnabled public String Name {get; set;}
        @AuraEnabled public String APIName {get; set;}
        @AuraEnabled public list<FldsLabelAndAPIWrapper> srchfldsLst {get; set;}
        @AuraEnabled public list<FldsLabelAndAPIWrapper> rstfldsLst {get; set;}
    }
    
    public class FldsLabelAndAPIWrapper{
        @AuraEnabled public String Name {get; set;}
        @AuraEnabled public String APIName {get; set;}
    }
    
    public class SobjectAndFieldWrapper{
         @AuraEnabled public list<String> fieldlbls {get; set;}
         @AuraEnabled public list<String> fieldApis {get; set;}
         @AuraEnabled public list<SObject> sObjectData {get; set;}
        
    }
    
    
    
     @AuraEnabled
    public static List<ObjLabelAndAPIWrapper> getObjectNames(){
        List<ObjLabelAndAPIWrapper> objWrapperList = new List<ObjLabelAndAPIWrapper>();
        List<string> objSearchflds = new List<string>();
        List<string> objResultflds = new List<string>();
        for(Base_Object__c obj : [select Name,Sobject_Name__c,Sobject_API_Name__c,Search_Fields__c,Search_Results__c from Base_Object__c LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())])
        { 	
            ObjLabelAndAPIWrapper objWrap = new ObjLabelAndAPIWrapper();
            List<FldsLabelAndAPIWrapper> fldWrapperList = new List<FldsLabelAndAPIWrapper>();
             List<FldsLabelAndAPIWrapper> rstfldWrapperList = new List<FldsLabelAndAPIWrapper>();
            if(obj.Search_Fields__c!= NULL){
        	objSearchflds = obj.Search_Fields__c.split(',');
            }
            if(obj.Search_Results__c!= NULL){
        	objResultflds = obj.Search_Results__c.split(',');
            }
            objWrap.Name = obj.Sobject_Name__c;
            objWrap.APIName = obj.Sobject_API_Name__c;
            system.debug('obj'+obj);
            
          	
            if(!objSearchflds.isempty()){
         	Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType ObjectSchema = schemaMap.get(obj.Sobject_API_Name__c);
            Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();
            set<string> allfieldnames =  fieldMap.keySet();
            system.debug('allfieldnames '+allfieldnames);
            list<string> Allfields=new list<string>();
            Allfields.addall(allfieldnames);
            system.debug('Allfields'+Allfields);
            
            
            system.debug('objSearchflds'+objSearchflds);
            for(integer inx=0;inx<Allfields.size();inx++) {
                
                for(integer inx1=0;inx1<objSearchflds.size();inx1++)
                {
                    FldsLabelAndAPIWrapper fldWrap = new FldsLabelAndAPIWrapper();
                    
                    if(objSearchflds[inx1].equalsIgnoreCase(string.valueof(Allfields[inx])))
                    {
                        
                        fldWrap.Name=fieldMap.get(Allfields[inx]).getDescribe().getLabel();
                        system.debug('Name '+fldWrap.Name);
                        fldWrap.APIName=Allfields[inx].capitalize();
                        system.debug('APIName '+fldWrap.APIName);
                        fldWrapperList.add(fldWrap);
                    }
                    else if(objSearchflds[inx1].contains('.')){
                       
                        fldWrap.Name=objSearchflds[inx1];
                        system.debug('Name '+fldWrap.Name);
                        fldWrap.APIName=objSearchflds[inx1];
                        system.debug('APIName '+fldWrap.APIName);
                        fldWrapperList.add(fldWrap);
                    }
                    
                 
                }
            }
            objWrap.srchfldsLst = fldWrapperList;
            }
            else{
              objWrap.srchfldsLst = NULL;  
            }
            
            if(!objResultflds.isempty()){
         	Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType ObjectSchema = schemaMap.get(obj.Sobject_API_Name__c);
            Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();
            set<string> allfieldnames =  fieldMap.keySet();
            system.debug('allfieldnames '+allfieldnames);
            list<string> Allfields=new list<string>();
            Allfields.addall(allfieldnames);
            system.debug('Allfields'+Allfields);
            
            
            system.debug('objResultflds'+objResultflds);
            for(integer inx=0;inx<objResultflds.size();inx++) {
                Boolean exists = false;
                for(integer inx1=0;inx1<Allfields.size();inx1++)
                {
                     FldsLabelAndAPIWrapper fldWrap = new FldsLabelAndAPIWrapper(); 
                    if(objResultflds[inx].equalsIgnoreCase(string.valueof(Allfields[inx1])))
                    {
                        exists = true;
                        fldWrap.Name=fieldMap.get(Allfields[inx1]).getDescribe().getLabel();
                        system.debug('Name '+fldWrap.Name);
                        if(!Allfields[inx1].contains('__c')){
                            fldWrap.APIName=Allfields[inx1].capitalize();
                        }
                        else{
                           fldWrap.APIName=Allfields[inx1]; 
                        }
                        system.debug('APIName '+fldWrap.APIName);
                        rstfldWrapperList.add(fldWrap);
                    }
                    
                }
                
                if(!exists){
                    FldsLabelAndAPIWrapper fldWrap = new FldsLabelAndAPIWrapper(); 
                       system.debug('objResultflds[inx1] '+objResultflds[inx]);
                        fldWrap.Name=objResultflds[inx];
                      //  system.debug('Name '+fldWrap.Name);
                        fldWrap.APIName=objResultflds[inx];
                       // system.debug('APIName '+fldWrap.APIName);
                        rstfldWrapperList.add(fldWrap);
                    
                }
            }
            objWrap.rstfldsLst = rstfldWrapperList;
            }
            else{
              objWrap.rstfldsLst = NULL;  
           }
            
            objWrapperList.add(objWrap);
        }
        
        
        system.debug('objWrapperList'+objWrapperList);
        return objWrapperList;
    }
    
    
      @AuraEnabled
     public static  Map<String,String> fetchFieldNameMap(string keyName, string valueField,map<string,string> prevMap)
      {    
         
           nameKey = keyName;
           fieldValue=valueField;
         
         /* fieldmap.put(nameKey,fieldValue);
          fieldmap.put(prevMap.key(),prevMap.value());*/
         
          prevMap.put(nameKey,fieldValue);
           system.debug('prevMap'+prevMap);
         return prevMap;
           
      }
    
     @AuraEnabled
     public static SobjectAndFieldWrapper fetchQuery(string selobject,Map<string,string> fieldsandvalues,list<FldsLabelAndAPIWrapper> rstFldVals)
      {    
          system.debug('selobject'+selobject);
          system.debug('fieldsandvalues'+fieldsandvalues);
          system.debug('rstFldVals'+rstFldVals);
          string query;
          Integer cnt=1;
          
          list<string> rstfldslst = new list<string>();
         
          list<string> fieldlabellst = new list<string>();
         
         
          
          SobjectAndFieldWrapper sobjFieldRst = new SobjectAndFieldWrapper();
              
          for(FldsLabelAndAPIWrapper fld: rstFldVals){
              fieldlabellst.add(fld.Name);
              rstfldslst.add(fld.APIName);
          }
           system.debug('rstfldslst'+rstfldslst);
          String searchflds='';

          for(String str : rstfldslst)
          {
              searchflds += str + ',' ;
          }
          searchflds = searchflds.removeEnd(',');
          system.debug('searchflds'+searchflds);
          
          for(String key:fieldsandvalues.keySet()){
              
                //fieldlabels.add(key);
                if(cnt==1 && fieldsandvalues.get(key)!='')
                 {
                     system.debug('Entered If');
              	     query='select '+searchflds+' from '+selobject+' where '+key+' LIKE '+'\'%' +fieldsandvalues.get(key)+ '%\'';
                
                  }
                 else if(fieldsandvalues.get(key)!='')
                 {
                     system.debug('Entered Else');
            		 query+= ' and ' + key+' LIKE '+'\'%' +fieldsandvalues.get(key)+ '%\'';
                 }
                cnt++;
          }
      
          system.debug('query'+query);
          
          sobjFieldRst.fieldlbls = fieldlabellst;
          sobjFieldRst.fieldApis = rstfldslst; 
          sobjFieldRst.sObjectData = Database.query(query);
          
          system.debug('sobjFieldRst'+sobjFieldRst);
          
        return sobjFieldRst;
          
      }
    
}