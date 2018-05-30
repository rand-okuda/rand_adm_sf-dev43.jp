public class MIB_Helper {
    
    public static void linkingMIB(List<MIB__c> MIBList){
        System.debug('@@@ createNodeMIB()');
        
        Set<String> mibIpAddressSet = new Set<String>();
        for(MIB__c mib :MIBList){
            mibIpAddressSet.add(mib.IPAddress__c);
            System.debug('*** mib.IPAddress__c ' + mib.IPAddress__c);
        }
        List<Node__c> existNodeList = [SELECT Id, IPAddress__c FROM Node__c WHERE IPAddress__c=:mibIpAddressSet];

        Map<Id,String> nodeIdIPAddressMap = new Map<Id,String>();
        for(Node__c node :[SELECT Id, IPAddress__c FROM Node__c WHERE IPAddress__c=:mibIpAddressSet]){
            nodeIdIPAddressMap.put(node.Id, node.IPAddress__c);
        }
        
        List<Node__c> nodeList = new List<Node__c>();
        for(MIB__c mib :MIBList){
            if(!nodeIdIPAddressMap.containsKey(mib.IPAddress__c)){
                Node__c node = new Node__c();
                node.IPAddress__c = mib.IPAddress__c;
                nodeList.add(node);
                System.debug('*** node ' + node);                
            }
        }
        insert nodeList;
        
        for(Node__c node :[SELECT Id, IPAddress__c FROM Node__c WHERE IPAddress__c=:mibIpAddressSet]){
            nodeIdIPAddressMap.put(node.Id, node.IPAddress__c);
        }
        
        for(MIB__c mib :MIBList){
            mib.Node__c = nodeIdIPAddressMap.get(mib.IPAddress__c);
        }
        
        //Todo
        //IPAddressが一致するMIBの中でDateTimeが最大のレコードをMIBBeforeに代入する。
        //MIBのSELECTでDateTimeでORDERBYしfor()で最初に一致した際にBreakする。
        
    }
        
}