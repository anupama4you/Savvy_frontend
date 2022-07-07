import { LightningElement } from 'lwc';

export default class QuoteInsuranceForm extends LightningElement {
    value = '--None--';

    get options() {
        return [
            { label: '--None--', value: 'none' },
            { label: 'Epic', value: 'epic' },
        ];
    }

    handleChange(event) {
        this.value = event.detail.value;
    }
    
}