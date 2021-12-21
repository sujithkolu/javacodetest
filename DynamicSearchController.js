({
	doInit : function(component, event, helper) {
        var Action = component.get("c.getObjectNames");
        Action.setCallback(this, function(response) {
            var list = response.getReturnValue();
            component.set("v.picklistValues", list);
            alert('picklistValues'+ JSON.stringify(component.get("v.picklistValues")));
        })
        
        $A.enqueueAction(Action);
        
    },
    
     onSelectingSobj : function(component, event, helper){
         component.set("v.display",false);
          var selectedObject = component.get("v.selectedObject");
         //alert("selectedObject - "+selectedObject);  
         var picklistValues = component.get("v.picklistValues");
         
         for(var i=0; i < picklistValues.length; i++){
            var objectName = picklistValues[i].Name;
            if(picklistValues[i].Name  === selectedObject){
                console.log("selectedObject-"+selectedObject+" ---opt--"+picklistValues[i].Name);
                var fieldlist = picklistValues[i].srchfldsLst;
                var rstfieldlist = picklistValues[i].rstfldsLst;
                
                    component.set("v.sObjectfieldlist", fieldlist);
                	component.set("v.rstfieldlist", rstfieldlist);
                    
            }
        }
       
	},
    
     textChange: function(cmp, event,helper) {
        var target = event.target;
        var dataEle = target.getAttribute("data-selected-Index");
        var fieldapiname= target.name;
       
        var fieldvalue=target.value; 
    
       var prevMap =cmp.get("v.fieldsandvalue");
       var Action = cmp.get("c.fetchFieldNameMap");
        Action.setParams({
            "keyName":fieldapiname,
            "valueField":fieldvalue,
            "prevMap":prevMap
        });
        
        Action.setCallback(this, function(response) {
            //store response state 
            var state = response.getState();
            if (state === "SUCCESS") {
                // create a empty array for store map keys 
                var arrayOfMapKeys = [];
                // store the response of apex controller (return map)     
                var StoreResponse = response.getReturnValue();
                console.log('StoreResponse' + JSON.stringify(StoreResponse));
                // set the store response[map] to component attribute, which name is map and type is map.   
                cmp.set("v.fieldsandvalue", StoreResponse);
		   }
     }) 
        
        $A.enqueueAction(Action); 
    },
    
    onSearch : function(component, event, helper){
        
       component.set("v.display",true);
        var selobj = component.get("v.selectedObject");
        var fldsVals=component.get("v.fieldsandvalue");
        console.log('fldsVals '+JSON.stringify(component.get("v.fieldsandvalue")));
        var tmp=component.get("v.fieldsandvaluecmp")
        var fldscount = 0;
        var xcount = 0;
  		var itr;
   		  for (itr in fldsVals){
        if(fldsVals.hasOwnProperty(itr)){
           fldscount++;
          }
         }
        
        for (itr in tmp){
        if(tmp.hasOwnProperty(itr)){
           xcount++;
          }
         }
        console.log('xcount'+xcount);
        console.log('fldsVals'+fldscount);
        if(fldscount===xcount)
        {alert('Please enter some data to search the duplicates')}
        
        var Action = component.get("c.fetchQuery");
        Action.setParams({
            "selobject":selobj,
            "fieldsandvalues":fldsVals,
            "rstFldVals":component.get("v.rstfieldlist")
            
        });
        
        Action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var StoreResponse = response.getReturnValue();
                console.log('StoreResponse'+JSON.stringify(StoreResponse));
                
                component.set("v.mycolumns",StoreResponse.fieldlbls);
                component.set("v.apiNames",StoreResponse.fieldApis);
              /*var fieldlabels =  component.get("v.mycolumns");
                var fieldApis =  component.get("v.apiNames");
                for(var i=0; i < picklistValues.length; i++){
                    
                    
                }
                component.set('v.mycolumns', [
            {label: 'Account Name', fieldName: 'Name', type: 'text'},
                {label: 'Industry', fieldName: 'Industry', type: 'text'},
                {label: 'Type', fieldName: 'Type', type: 'Text'}
            ]);*/
                component.set("v.sobjlst",StoreResponse.sObjectData);
            }
            
        })
        
        $A.enqueueAction(Action);
        
    }
    
   
})