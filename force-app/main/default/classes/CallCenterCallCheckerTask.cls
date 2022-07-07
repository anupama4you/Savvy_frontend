global class CallCenterCallCheckerTask implements Schedulable {
    global final Integer minutes;

    public CallCenterCallCheckerTask(Integer minutes) {
        this.minutes = minutes;
    }

    global void execute(SchedulableContext SC) {
        ipSCAPEService.checkCalls(this.minutes);
    }

}