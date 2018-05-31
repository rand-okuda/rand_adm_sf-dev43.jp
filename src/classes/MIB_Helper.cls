public class MIB_Helper {
    
    public static void linkingMIB(List<MIB__c> MIBList){
        System.debug('@@@ createNodeMIB()');
        
        Set<String> mibIpAddressSet = new Set<String>();
        for(MIB__c mib :MIBList){
            mibIpAddressSet.add(mib.IPAddress__c);
            System.debug('*** mib.IPAddress__c ' + mib.IPAddress__c);
        }
        List<Node__c> existNodeList = [SELECT Id, IPAddress__c FROM Node__c WHERE IPAddress__c=:mibIpAddressSet];

        Map<String,Id> nodeIdIPAddressMap = new Map<String,Id>();
        for(Node__c node :[SELECT Id, IPAddress__c FROM Node__c WHERE IPAddress__c=:mibIpAddressSet]){
            nodeIdIPAddressMap.put(node.IPAddress__c, node.Id);
        }
        
        List<Node__c> nodeList = new List<Node__c>();
        for(MIB__c mib :MIBList){
            if(!nodeIdIPAddressMap.containsKey(mib.IPAddress__c)){
                Node__c node = new Node__c();
                node.IPAddress__c = mib.IPAddress__c;
                nodeList.add(node);
                nodeIdIPAddressMap.put(node.IPAddress__c, node.Id);
                System.debug('*** node ' + node);
            }
        }
        insert nodeList;
        
        for(Node__c node :[SELECT Id, IPAddress__c FROM Node__c WHERE IPAddress__c=:mibIpAddressSet]){
            nodeIdIPAddressMap.put(node.IPAddress__c, node.Id);
        }
        
        Map<String,MIB__c> ifPhysAddMap = new Map<String,MIB__c>();
        for(MIB__c mib :[SELECT ID, IPAddress__c, ifPhysAddress__c, DateTime__c FROM MIB__c WHERE IPAddress__c=:mibIpAddressSet]){
            if(!ifPhysAddMap.containsKey(mib.ifPhysAddress__c)){
                ifPhysAddMap.put(mib.ifPhysAddress__c,mib);
                System.debug('*** mib ' + mib);
            }else if(mib.DateTime__c > ifPhysAddMap.get(mib.ifPhysAddress__c).DateTime__c){
                ifPhysAddMap.remove(mib.ifPhysAddress__c);
                ifPhysAddMap.put(mib.ifPhysAddress__c,mib);
                System.debug('*** mib ' + mib);
            }
        }

        for(MIB__c mib :MIBList){
            if(mib.Node__c == null){
                mib.Node__c = nodeIdIPAddressMap.get(mib.IPAddress__c);
                System.debug('*** mib ' + mib);
            }
            if(mib.MIBBefore__c == null){
                mib.MIBBefore__c = ifPhysAddMap.get(mib.ifPhysAddress__c).Id;
                System.debug('*** mib ' + mib);
            }
        }
        
    }
        
}