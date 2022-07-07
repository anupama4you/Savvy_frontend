public class RowWrapper {
    // the values (cells) making up this row
    public List <Decimal> values {get;set;}
    
    // constructor
    public RowWrapper () {
        values = new List <Decimal> ();
    }
    
    // append a value (cell) to the row
    public void addValue (Decimal value) {
        values.add(value);
    }
}