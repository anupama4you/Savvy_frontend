import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import createTask from "@salesforce/apex/PartnerCommunityController.createTask";

export default class PartnerNewTaskForm extends LightningElement {
  @api recordId;
  @api showModal;
  
  formData;
  
  connectedCallback() {
    this.resetFormData();
    // console.log(
    //   `connectedCallback... => ${(JSON.stringify(this.formData, null, 2))}`
    // );
  }

  resetFormData() {
    this.formData = {
      whatId: "",
      subject: "",
      comments: "",
      priority: "Normal",
      status: "Not Started",
      dueDate: null
    };
  }

  handleClose() {
    this.resetFormData();
    this.dispatchEvent(new CustomEvent("close"));
  }

  handleSuccess(event) {
    // const rec = event.detail.fields;
    // console.log(JSON.stringify(payload));
    const evt = new ShowToastEvent({
      title: "Task created",
      message:
        "Record created successfully!",
      variant: "success"
    });
    this.dispatchEvent(evt);
    this.handleClose();
  }

  isValidForm() {
    let r = true;
    // Subject
    if (!this.formData.subject || this.formData.subject.trim().length === 0) {
      r = false;
      let fld = this.template.querySelector(`[data-id="subject-field"]`);
      fld.reportValidity();
    }
    // Due Date
    if (!this.formData.dueDate || this.formData.dueDate.length > 0) {
      let fld = this.template.querySelector(`[data-id="comments-field"]`);
      if(!fld.checkValidity()) {
        r = false;
      }
    }

    if (!this.formData.comments || this.formData.comments.trim().length === 0) {
      r = false;
      let fld = this.template.querySelector(`[data-id="comments-field"]`);
      fld.reportValidity();
    }
    console.log(`Validation => ${r}`);
    return r;
  }

  handleSubmit(event){
    event.preventDefault();       // stop the form from submitting
    console.log(`submit => ${JSON.stringify(this.formData,null,2)}`);
    if (this.isValidForm() === true) {
      this.formData.whatId = this.recordId;
      createTask({task: this.formData})
        .then((data) => {
          console.log(`result => ${JSON.stringify(data)}`);
          this.dispatchEvent(
            new ShowToastEvent({
              title: "Task created!",
              variant: "success"
            })
          );
          this.handleClose();
        })
        .catch((error) => {
          console.log(`error => ${JSON.stringify(error)}`);
          this.dispatchEvent(
            new ShowToastEvent({
              title: "Error in displaying data!!",
              message: error.message,
              variant: "error"
            })
          );
          this.handleClose();
        });
    }
  }

  handleSubjectChange(event) {
    this.formData.subject = event.detail? event.detail.value : "";
  }

  handleCommentsChange(event) {
    this.formData.comments = event.detail? event.detail.value : "";
  }

  handlePriorityChange(event) {
    this.formData.priority = event.detail? event.detail.value : "";
  }

  handleStatusChange(event) {
    this.formData.status = event.detail? event.detail.value : "";
  }

  handleDueDateChange(event) {
    this.formData.dueDate = event.detail? event.detail.value : "";
  }

  get statusOptions() {
    return [
      { label: "Not Started", value: "Not Started" },
      { label: "In Progress", value: "In Progress" },
      { label: "Completed", value: "Completed" },
      { label: "Deferred", value: "Deferred" }
    ];
  }

  get priorityOptions() {
    return [
      { label: "High", value: "High" },
      { label: "Normal", value: "Normal" },
      { label: "Low", value: "Low" }
    ];
  }

  get subjectOptions() {
    return [
      { label: "Call", value: "Call" },
      { label: "Send Letter", value: "Send Letter" },
      { label: "Send Quote", value: "Send Quote" },
      { label: "Other", value: "Other" }
    ];
  }

}