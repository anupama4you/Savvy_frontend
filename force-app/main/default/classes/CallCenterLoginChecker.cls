global class CallCenterLoginChecker implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        // try {
            System.debug('Executing CallCenterLoginChecker...');
            ipSCAPEService.autologin();
            System.debug('CallCenterLoginChecker end.');
        // } catch (Exception e)  {}

    }

}