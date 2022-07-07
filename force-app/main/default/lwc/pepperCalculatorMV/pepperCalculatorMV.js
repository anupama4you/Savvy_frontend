import { LightningElement } from 'lwc';

export default class PepperCalculatorMV extends LightningElement {
    value = 'inProgress';

    get options() {
        return [
            { label: 'Purchase', value: 'purchase' },
            { label: 'Refinance', value: 'refinance' },
            { label: 'Sales & Lease Back', value: 'saleandleashback' },
        ];
    }

    handleChange(event) {
        this.value = event.detail.value;
    }
}