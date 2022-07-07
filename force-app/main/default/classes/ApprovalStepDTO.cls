//Approval Process Step that holds the Step Notes and Approver Comments and Details
public class ApprovalStepDTO {
	
	public ProcessInstanceStep instanceStep {get;set;}
	public ProcessNode nodeStep {get;set;}

	public ApprovalStepDTO(ProcessInstanceStep instanceStep,ProcessNode node) {
		this.instanceStep = instanceStep;
		this.nodeStep = node;
	}

}