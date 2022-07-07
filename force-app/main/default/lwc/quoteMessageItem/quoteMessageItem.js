import { LightningElement, api } from "lwc";

export default class QuoteMessageItem extends LightningElement {
  @api title;
  @api messages;
  @api iconName = "";
  @api variant = "error";

  get textStyle() {
    return `slds-text-color_${this.variant}`;
  }

  get borderStyle() {
    return `slds-m-bottom_x-small slds-box slds-box_x-small ${this.variant}`;
  }

  handleAlertClose(event) {
    const name = event.target.name;
    let msg = [].concat(this.messages);
    for (const key in msg) {
      if (msg[key].field == name) {
        console.log(JSON.stringify(msg, null, 2));
        msg.splice(key, 1);
        console.log("msg: ", JSON.stringify(msg, null, 2));
      }
    }
    this.messages = msg;
  }
}