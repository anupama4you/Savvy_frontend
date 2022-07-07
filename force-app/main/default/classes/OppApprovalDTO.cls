public class OppApprovalDTO implements Comparable {
    public Id oppId {set;get;}
    public Id ownerId {set;get;}
    public Id processInstanceWorkitemId {set;get;}
    public Id approverId {set;get;}
    
    public String name {set;get;}
    public String ownerName {set;get;}
    public String note {set;get;}
    public String approverName {set;get;}
    
    public Datetime submittedDate {set;get;}
    public String productLender {set;get;}

    public String approvalTemplate {set;get;}

    public String getSubmittedDateFormatted() {
    	if (submittedDate != null) {
    		return submittedDate.format('MMM d/yy,  HH:mm');
    	}
    	return null;
    }

    public Integer compareTo(Object o) {

        // Cast argument to OpportunityWrapper

        OppApprovalDTO a = (OppApprovalDTO)o;

        // The return value of 0 indicates that both elements are equal.

        Integer returnValue = 0;

        if (this.submittedDate != null && a.submittedDate == null)  {
            returnValue = -1;
        } else if (this.submittedDate == null && a.submittedDate != null)  {
            returnValue = 1;
        } else if (this.submittedDate != null && a.submittedDate != null)  {
            if (this.submittedDate.getTime() > a.submittedDate.getTime())  {
                returnValue = 1;
            } else {
                returnValue = -1;
            }
        }       

        return returnValue;      

    }


}