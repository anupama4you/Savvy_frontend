import LightningDatatable from "lightning/datatable";
import CustomPicklistTemplate from "./customPickListTemplate.html";

export default class CustomLightningDatatable extends LightningDatatable {
  static customTypes = {
    picklist: {
      template: CustomPicklistTemplate,
      typeAttributes: ["label", "placeholder", "options", "value"]
    }
  };
}