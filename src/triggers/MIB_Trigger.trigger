trigger MIB_Trigger on MIB__c (before insert, before update) {
    System.debug('@@@ MIB_Trigger');
    
    List<MIB__c> unLinkedMIBList = new List<MIB__c>();
    for ( Integer i=0; i<Trigger.New.size(); i++ ){
        if(Trigger.New[i].Node__c == null || Trigger.New[i].MIBBefore__c == null){
            unLinkedMIBList.add(Trigger.New[i]);
        }
    }
    if(!unLinkedMIBList.isEmpty()){
        MIB_Helper.linkingMIB(unLinkedMIBList);
    }
    
}