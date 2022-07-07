public with sharing class ipSCAPEDTOs {
    
    public virtual class BasicResult {
        public String resultCode {set;get;}
        public String errorCode {set;get;}
        public String errorDescription {set;get;}
        public List<ErrorDetail> errorDetails {set;get;}
        public String interactionId {set;get;}
    }

    public class ErrorDetail {
        public String name {set;get;}
        public String description {set;get;}
        public String debuggingInfo {set;get;}
    }

    public class ErrorSingleDetail {
        public String OrgId {set;get;}
        public String customerKey {set;get;}
        public Integer leadId {set;get;}
    }

    // Results

    public class LoginResult extends BasicResult {
        public LoginDTO result {set;get;}
    }

    public class UserListResult extends BasicResult {
        public UserListDTO result {set;get;}
    }

    public class CreateLeadResult extends BasicResult {
        public LeadResultDTO result {set;get;}
        public String errorDetails {set;get;}
    }

    public class ActivityListResult extends BasicResult {
        public ActivityListResultDTO result {set;get;}
    }

    public class CallListResult extends BasicResult {
        public CallListResultDTO result {set;get;}
    }

    // DTOs
    public virtual class ListDTO {
        public Integer pageNo {set;get;}
        public Integer inPage {set;get;}
        public Integer perPage {set;get;}
        public Integer previousPage {set;get;}
        public String nextPage {set;get;}
    }

    public class LoginDTO {
        public String orgId {set;get;}
        public String client {set;get;}
        public Integer userId {set;get;}
        public String username {set;get;}
        public Integer numOfFailedLoginAttempts {set;get;}
        public String lastLoginDt {set;get;}
    }
    public class UserListDTO extends ListDTO {
        public List<UserDTO> data {set;get;}
    }
    public class UserDTO {
        public Integer userId {set;get;}
        public String userTimezone {set;get;}
        public String firstName {set;get;}
        public String lastName {set;get;}
        public String username {set;get;}
        public Boolean isLoggedIn {set;get;}
        public String userType {set;get;}
        public String displayName {set;get;}
        public Boolean receiveTransferInPauseEnabled {set;get;}
        public Boolean availableForTransfer {set;get;}
    }
    public class LeadResultDTO {
        public Integer leadId {set;get;}
        public Integer isDialling {set;get;}
    }
    public class ActivityListResultDTO extends ListDTO {
        public List<ActivityDTO> data {set;get;}
    }
    public class CallListResultDTO extends ListDTO {
        public List<CallDTO> data {set;get;}
    }
    public class ActivityDTO {
        public Integer activityId {set;get;}
        public Integer parentActivityId {set;get;}
        public Integer campaignId {set;get;}
        public String campaignTitle {set;get;}
        public Integer leadId {set;get;}
        public String activitySource {set;get;}
        public String activityStart {set;get;}
        public String activityEnd {set;get;}
        public String activityResultTimestamp {set;get;}
        public String activityAnsweredTimestamp {set;get;}
        public String queueEntryTimestamp {set;get;}
        public String activityDestination {set;get;}
        public String activityType {set;get;}
        public String resultType {set;get;}
        public Integer secondsInQueue {set;get;}
        public String callDirection {set;get;}
        public Integer dialSeconds {set;get;}
        public Integer voicerecordingId {set;get;}
        public String customData {set;get;}
        public String customText {set;get;}
        public String activityStatus {set;get;}
        public String sourceType {set;get;}
        public Integer isTransferred {set;get;}
        public Integer talkSeconds {set;get;}
        public Integer recordingSeconds {set;get;}
        public Integer totalSeconds {set;get;}
        public Integer agentId {set;get;}
        public Integer interactionId {set;get;}
        public Integer surveyInitiated {set;get;}
        public String surveyWorkflowName {set;get;}
        public String surveyWorkflowTimestamp {set;get;}
        public String mediaType {set;get;}
    }
    public class CallDTO {
        public Integer activityId {set;get;}
        public Integer parentActivityId {set;get;}
        public Integer interactionId {set;get;}
        public String startTimestamp {set;get;}
        public String endTimestamp {set;get;}
        public Integer duration {set;get;}
        public Integer talkSeconds {set;get;}
        public Integer campaignId {set;get;}
        public String campaignTitle {set;get;}
        public String wrapCode {set;get;}
        public Integer wrapId {set;get;}
        public Integer agentId {set;get;}
        public String agentName {set;get;}
        public Integer leadId {set;get;}
        public String callerNumber {set;get;}
        public String calledNumber {set;get;}
        public String activityStatus {set;get;}
        public Boolean isTransferred {set;get;}
        public Boolean isEncrypted {set;get;}
        public Boolean isDeleted {set;get;}
        public String deletedTimestamp {set;get;}
        public String deletedBy {set;get;}
        public String deletionReason {set;get;}
    }
}