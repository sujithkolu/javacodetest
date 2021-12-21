({
	doInit : function(component, event, helper) {
        
        var column=component.get("v.values")
		  var v;
       
        console.log('column'+ JSON.stringify(column));
          var x=component.get("v.columName");
        console.log('CN'+x);
           
        
        for (v in column) {
           console.log('column[x]',column[x]);
         component.set("v.cellvalue",column[x]);
            console.log('DV',component.get('v.cellvalue'));
           }
        
        
	}
})