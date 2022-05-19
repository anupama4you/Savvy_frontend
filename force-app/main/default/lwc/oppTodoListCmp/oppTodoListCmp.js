import { LightningElement, track } from 'lwc';

export default class OppTodoListCmp extends LightningElement {

    @track selectedItem = 'reports_recent';
    @track currentContent = 'reports_recent';

    handleSelect(event) {
        const selected = event.detail.name;

        if (selected === 'Application_Form') {
            console.log(':::: selected ::::' + selected);
        }

        this.currentContent = selected;
    }

}