public class DetailReportIterator implements Iterator<List<FollowingUpReportController.DetailReport>> {

    public List<FollowingUpReportController.DetailReport> fullList {get;set;}
    public List<FollowingUpReportController.DetailReport> partialList {get;set;}
    Integer index { get;set; }
    public Integer pageSize {get;set;}

    public DetailReportIterator(List<FollowingUpReportController.DetailReport> dataList) {
        this.index = 0;
        this.pageSize = 10;
        this.fullList = dataList;
        this.partialList = new List<FollowingUpReportController.DetailReport>();
    }

    public Boolean hasNext(){ 
        return this.getHasNext();
    }

    public Boolean getHasNext(){ 
        if(this.index >= fullList.size()) {
           return false; 
       } else {
           return true; 
       }
    }    

    public Boolean getHasPrevious() { 
        System.debug('I am in hasPrevious' + this.index);
        if(this.index <= this.pageSize) {
            return false; 
        } else {
            return true; 
        }
    }

    public List<FollowingUpReportController.DetailReport> next() { 
        system.debug('idx(1): ' + this.index);
        this.partialList = new list<FollowingUpReportController.DetailReport >(); 
        Integer i;
        Integer size = this.fullList.size();
        if(this.getHasNext()) {  
            if(size <= (this.index + this.pageSize)) {
                i = this.index;
                this.index = size;
            } else {
                this.index = (this.index + this.pageSize);
                i = (this.index - this.pageSize);
            }
            System.debug('idx(2): ' + this.index);
            for(Integer x = i; x < this.index; x++) {
                this.partialList.add(this.fullList.get(x));
            }
        }
       return this.partialList;
    }

    public list<FollowingUpReportController.DetailReport > previous(){      
        this.partialList = new list<FollowingUpReportController.DetailReport >(); 
        System.debug('i value is previous before =====' + this.index);
        Integer size = this.fullList.size();
        if (this.getHasPrevious()) {
            if(this.index == size) {
                if(math.mod(size, this.pageSize) > 0) {    
                    this.index = size - math.mod(size, this.pageSize);
                } else {
                    this.index = (size - this.pageSize);
                }
            } else {
                this.index = (this.index - this.pageSize);
            }

            System.debug('i value is previous =====' + this.index);
            System.debug('i value is 2previous ==== ' + (this.index - this.pageSize));

            for(integer x = (this.index - this.pageSize); x < this.index; ++x) {
                this.partialList.add(this.fullList.get(x));
            }
        }
        return this.partialList;
    }

    public list<FollowingUpReportController.DetailReport > first(){
        this.index = 0;
        return this.next();
    }

    public list<FollowingUpReportController.DetailReport > last(){
        this.index = this.fullList.size();
        this.previous();
        return this.next();
    }

    public Integer getFullSize() {
        if (this.fullList != null) {
            return this.fullList.size();
        }
        return 0;
    }

    public Integer getCurrentPage() {
        if (this.pageSize == 0 || this.fullList.size() == 0) return 0;
        System.debug('CurrentPage: ' + this.index + '|' + this.pageSize);
        Decimal a = this.index / Decimal.valueOf(this.pageSize);
        return a.round(System.RoundingMode.CEILING).intValue();
    }

    public Integer getTotalPages() {
        if (this.pageSize == 0) return 0;
        Decimal a = this.fullList.size() / Decimal.valueOf(this.pageSize);
        return a.round(System.RoundingMode.CEILING).intValue();
    }

    public void reset() {
        this.index = 0;
    }
}