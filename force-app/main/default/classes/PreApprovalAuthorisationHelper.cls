public with sharing class PreApprovalAuthorisationHelper {
    
    private static final String REPORT_MANAGER_GROUP = 'Pre-approval Authorisation Team';
    
    public static final String AUTHORISATION_SECTION = 'Authorisation Process';
    public static final String SETTLEMENT_SECTION = 'Settlement';
    public static final String PREAPPROVAL_SECTION = 'Pre-Approval';
    public static final String AMENDMENT_SECTION = 'Amendments';
    public static final String FORMALAPPROVAL_SECTION = 'Formal Approval';
    public static final String OTHERPROCESSES_SECTION = 'Other Status';

    public static final Set<String> authorisationList = new Set<String>{
        'Pre-approval Authorisation Submitted',
        'Pre-approval Authorisation Approved',
        'Pre-approval Authorisation Recalled'
    };
    // 'Pre-approval Authorisation Declined', --> Exluded

    public static final Set<String> settlementList = new Set<String>{
        'Internal Settlement',
        'Documents Sent',
        'Settlement Rejected',
        'Documents Received',
        'Sent to Lender for Settlement',
        'Settled'
    };

    public static final Set<String> preApprovalList = new Set<String>{
        'Submitted for Pre-Approval',
        'Sent to Lender for Pre-Approval',
        'Pre-Approved'
    };

    public static final Set<String> amendmentList = new Set<String>{
        'Submitted for Amendment',
        'Sent to Lender for Amendment'
    };

    public static final Set<String> formalApprovalList = new Set<String>{
        'Submitted for Formal Approval',
        'Sent to Lender for Formal Approval',
        'Formal Approved'
    };

    public static boolean isAuthoriser() {
        Id userId = UserInfo.getUserId();
        List<GroupMember> gm = [
            Select UserOrGroupId From GroupMember
            where GroupId in (select id from Group where (Name=:REPORT_MANAGER_GROUP))
            and UserOrGroupId = :userId
        ];
        if (!gm.isEmpty() || SOQLSingletonQueries.recs().isSavvyAdmin()) {
            return true;
        }
        return false;
    }

    public static String getSection(String oppStatus) {
        String r = OTHERPROCESSES_SECTION;
        if (String.isNotBlank(oppStatus)) {
            if (authorisationList.contains(oppStatus)) {
                r = AUTHORISATION_SECTION;
            } else if (settlementList.contains(oppStatus)) {
                r = SETTLEMENT_SECTION;
            } else if (preApprovalList.contains(oppStatus)) {
                r = PREAPPROVAL_SECTION;
            } else if (amendmentList.contains(oppStatus)) {
                r = AMENDMENT_SECTION;
            } else if (formalApprovalList.contains(oppStatus)) {
                r = FORMALAPPROVAL_SECTION;
            }
        }
        return r;
    }

    public static Set<String> getSectionStatuses(String section) {
        Set<String> r = new Set<String>();
        if (AUTHORISATION_SECTION.equals(section)) {
            r.addAll(authorisationList);
        } else if (SETTLEMENT_SECTION.equals(section)) {
            r.addAll(settlementList);
        } else if (FORMALAPPROVAL_SECTION.equals(section)) {
            r.addAll(formalApprovalList);
        } else if (AMENDMENT_SECTION.equals(section)) {
            r.addAll(amendmentList);
        } else if (PREAPPROVAL_SECTION.equals(section)) {
            r.addAll(preApprovalList);
        }
        return r;
    }

    public static Set<String> excludedStatuses() {
        return new Set<String>{
            'Closed Opportunity','Unresolved Opportunity','Pre-approval Authorisation Declined',
            'Settled','Settlement Rejected','Declined'
        };
    }
}