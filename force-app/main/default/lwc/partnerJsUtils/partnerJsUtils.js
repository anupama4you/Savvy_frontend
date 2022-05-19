import { ShowToastEvent } from "lightning/platformShowToastEvent";

const buildErrorMessage = (err) => {
  console.log(`buildErrorMessage...`);
  let m = "";
  if (err) {
    if (err.body) {
      m += err.body.message ? `${err.body.message}` : "";
      m += err.body.exceptionType ? `<hr/>${err.body.exceptionType}: ` : "";
      m += err.body.stackTrace ? `<p><i>${err.body.stackTrace}</i><p>` : "";
    }
    m += err.status ? `[Status: ${err.status}] ` : "";
  }
  return m;
};

const displayToast = (comp, title, message, variant) => {
  const evt = new ShowToastEvent({
    title: `${title}`,
    message: `${message}`,
    variant: `${variant ? variant : "info"}`
  });
  comp.dispatchEvent(evt);
}

export { buildErrorMessage, displayToast };