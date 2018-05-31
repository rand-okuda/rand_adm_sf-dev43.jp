public class MIB_Helper {
    
    public static void linkingMIB(List<MIB__c> MIBList){
        System.debug('@@@ createNodeMIB()');
        
        Set<String> mibIpAddressSet = new Set<String>();
        for(MIB__c mib :MIBList){
            mibIpAddressSet.add(mib.IPAddress__c);
            System.debug('*** mib.IPAddress__c ' + mib.IPAddress__c);
        }
        
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
        
        for(MIB__c mib :MIBList){
            if(mib.Node__c == null){
                mib.Node__c = nodeIdIPAddressMap.get(mib.IPAddress__c);
            }
        }
        
        List<MIB__c> existMIBList = [SELECT ID, IPAddress__c, ifPhysAddress__c, DateTime__c FROM MIB__c WHERE IPAddress__c=:mibIpAddressSet ORDER BY DateTime__c DESC];
        for(MIB__c mib :MIBList){
            if(mib.MIBBefore__c == null){
                System.debug('*** mib.DateTime__c ' + mib.DateTime__c);
                for(MIB__c existMib :existMIBList){
                    if(mib.IPAddress__c == existMib.IPAddress__c && mib.ifPhysAddress__c == existMib.ifPhysAddress__c && mib.DateTime__c > existMib.DateTime__c){
                        System.debug('*** existMib.DateTime__c ' + existMib.DateTime__c);
                        mib.MIBBefore__c = existMib.Id;
                        break;
                    }
                }
            }
        }
        
    }
    
}