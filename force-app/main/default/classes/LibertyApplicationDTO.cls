public class LibertyApplicationDTO {
    
    public static final String SAVVY_NAME = 'Savvy';
    public ApplicationBatch ApplicationBatch  {set; get;}//https://cs6.salesforce.com/_ui/common/apex/debug/ApexCSIPage#
    
    public class ApplicationBatch extends XMLElement{
        public DocumentHeader documentHeader {set; get;} //Yes	See the DocumentHeader for more information
        public Identifier identifier {set; get;} //Yes	A BrokerAssigned Identifier element used to identify the request
        public Submission submission {set; get;} //Yes	See the Submission for more information 
        public Application application {set; get;} //Yes	Only a single Application element is supported
        
        public String getXmlApplicationBacth (){
            Dom.Document doc = new Dom.Document();
            String namespace = null;
        	String prefix = null; //Always null for this process
            Dom.XmlNode rootNode = doc.createRootElement('ApplicationBatch', namespace, prefix);
            parent = rootNode;
            rootNode.setAttribute('xmlns:xsd', 'htt://www.w3.org/2001/XMLSchema');
            rootNode.setAttribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
            documentHeader.parent = rootNode;
            rootNode.getChildElements().add(documentHeader.getNode());
            identifier.parent = rootNode;
            rootNode.getChildElements().add(identifier.getNode());
            submission.parent = rootNode;
            rootNode.getChildElements().add(submission.getNode());
            application.parent = rootNode;
            rootNode.getChildElements().add(application.getNode());
            String xml = doc.toXmlString().replaceAll('"', '\'');
            return xml;
        }
    }
    
    public class DocumentHeader extends XMLElement implements XmlELementInterface{
        
        public SchemaName schemaName {set; get;}
        public SchemaVersion schemaVersion {set; get;}
        
        public Dom.XmlNode getNode(){
            String namespace = null;
            String prefix = null; //Always null for this process
            Dom.XmlNode documentHeader = createNode(parent, 'DocumentHeader', null);
            if (schemaName != null){
                schemaName.parent = documentHeader;
            	documentHeader.getChildElements().add(schemaName.getNode());
            }
            if (schemaVersion != null){
                schemaVersion.parent = documentHeader;
            	documentHeader.getChildElements().add(schemaVersion.getNode());
            }
            return documentHeader;
        }
    }
    
    public class SchemaName extends XMLElement implements XmlElementInterface{
        public String attb_Type {set; get;}
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_Type != null){
                attributes.put('xsi:type', StringUtils.convertToString(attb_Type));
            }
            return createNode(parent, 'SchemaName', value, attributes);
        }
    }
    
    public class SchemaVersion extends XMLElement implements XmlElementInterface{
        public String attb_Type {set; get;}
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_Type != null){
                attributes.put('xsi:type', StringUtils.convertToString(attb_Type));
            }
            return createNode(parent, 'SchemaVersion', value, attributes);
        }
    }
    
    public class Identifier extends XMLElement implements XmlElementInterface{
        public String attb_Type {set; get;} //Yes	One of LenderAssigned or BrokerAssigned
        public String attb_UniqueID	{set; get;} //Yes	An ID field that uniquely identifies the resource 
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            attributes.put('Type', StringUtils.convertToString(attb_Type));
            attributes.put('UniqueID', attb_UniqueID);
            return createNode(parent, 'Identifier', null, attributes);
        }
    }
    
    public class Submission extends XMLElement implements XmlElementInterface{
        public EDate eDate {set; get;}
        public ETime eTime {set; get;}
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode submission = createNode (parent, 'Submission', null);
            eDate.parent = submission;
            submission.getChildElements().add(eDate.getNode());
            eTime.parent = submission;
            submission.getChildElements().add(eTime.getNode());
            return submission;
        }
    }
    
    public class EDate extends XMLElement implements XmlElementInterface {
        public Dom.XmlNode getNode(){
            return createNode (parent, 'Date', StringUtils.convertToString(value));
        }
    }
    
    public class ETime extends XMLElement implements XmlElementInterface {
        public Dom.XmlNode getNode(){
            return createNode (parent, 'Time', StringUtils.convertToString(value));
        }
    }
    
    public class Application extends XMLElement implements XmlElementInterface {
        public String attb_DocType {set; get;}
        public String attb_Type {set; get;} 
        
        public AddressSegment addressSegment {set; get;} //Yes	See the AddressSegment for more information
        public Comment comment {set; get;} //No	One or more Comment elements
        public Country country {set; get;} //Yes	See Country element for more information
        public DeclarationSegment declarationSegment {set; get;} //Yes	See the DeclarationSegment for more information
        public Identifier identifier {set; get;} //Yes	The unique Identifier from the Broker system
        public FinancialSegment financialSegment {set; get;} //Yes	See the FinancialSegment for more information
        public LoanDetailSegment loanDetailSegment {set; get;} //Yes	See the LoanDetailSegment for more information
        public PartySegment partySegment {set; get;} //Yes	A collection of all Party defined in the request
        public RelatedPartySegment relatedPartySegment {set; get;} //Yes	See the RelatedPartySegment for more information
        public SalesChannel salesChannelBrokerGroup {set; get;} //Yes The first SalesChannel specifies the Broker Group
        public SalesChannel salesChannelBroker {set; get;} //Yes The second SalesChannel identifies the individual Broker within that Group
        public Submission submission {set; get;}
        public SummaryData summaryData {set; get;} //Yes See the SummaryData for more information
        
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            attributes.put('DocType', StringUtils.convertToString(attb_DocType));
            attributes.put('Type', StringUtils.convertToString(attb_Type));
            Dom.XmlNode application = createNode (parent, 'Application', null, attributes);
            //identifier.parent = application;
            //application.getChildElements().add(identifier.getNode());
            //submission.parent = application;
            //application.getChildElements().add(submission.getNode());
            //summaryData.parent = application;
            //application.getChildElements().add(summaryData.getNode());
            if (identifier != null){
                identifier.parent = application;
                application.getChildElements().add(identifier.getNode());
            }
            if (submission != null){
                submission.parent = application;
                application.getChildElements().add(submission.getNode());
            }
            if (country != null){
                country.parent = application;
                application.getChildElements().add(country.getNode());
            }
            if (salesChannelBrokerGroup != null){
                salesChannelBrokerGroup.parent = application;
                application.getChildElements().add(salesChannelBrokerGroup.getNode());
            }
            if (salesChannelBroker != null){
                salesChannelBroker.parent = application;
                application.getChildElements().add(salesChannelBroker.getNode());
            }
            if (summaryData != null){
                summaryData.parent = application;
                application.getChildElements().add(summaryData.getNode());
            }
            if (comment != null){
                comment.parent = application;
            	application.getChildElements().add(comment.getNode());
            }
            if (partySegment != null){
                partySegment.parent = application;
                application.getChildElements().add(partySegment.getNode());
            }
            if (addressSegment != null){
                addressSegment.parent = application;
                application.getChildElements().add(addressSegment.getNode());
            }
            if (financialSegment != null){
                financialSegment.parent = application;
                application.getChildElements().add(financialSegment.getNode());
            }
            if (relatedPartySegment != null){
                relatedPartySegment.parent = application;
                application.getChildElements().add(relatedPartySegment.getNode());
            }
            if (loanDetailSegment != null){
                loanDetailSegment.parent = application;
                application.getChildElements().add(loanDetailSegment.getNode());
            }
            if (declarationSegment != null){
                declarationSegment.parent = application;
                application.getChildElements().add(declarationSegment.getNode());
            }
            
            return application;
        }
    }
    
    public class AddressSegment extends XMLElement implements XmlElementInterface {
        
        public List<AddressWrapper> addressWrappers {set; get;} //Yes	One or more AddressWrapper elements
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode addressSegment = createNode (parent, 'AddressSegment', null);
            if (addressWrappers != null){
                for (AddressWrapper addressWrapper : addressWrappers){
                    if (addressWrapper != null){
                        addressWrapper.parent = addressSegment;
                		addressSegment.getChildElements().add(addressWrapper.getNode());
                    }
                }
            }
            return addressSegment;
        }
    }
    
    public class AddressWrapper extends XMLElement implements XmlElementInterface {
        
        public Identifier identifier {set; get;} //Yes	A BrokerAssigned Identifier to uniqely identify the address information
        public Address address {set; get;} //Yes	See Address element for more information
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode addressWrapper = createNode(parent, 'AddressWrapper', null);
            if (identifier != null){
                identifier.parent = addressWrapper;
                addressWrapper.getChildElements().add(identifier.getNode());
            }
            if (address != null){
                address.parent = addressWrapper;
                addressWrapper.getChildElements().add(address.getNode());
            }
            return addressWrapper;
        }
    }
    
    public class SummaryData extends XMLElement implements XmlELementInterface{
        public Decimal attb_NumberOfApplicants {set; get;} //Yes	The number of applicants captured
        public String attb_NumberOfLoans {set; get;} //Yes	The number of loans. Only one is supported at this time
        public String attb_NumberOfSecurities {set; get;} //Yes	The number of securities captured
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            attributes.put('NumberOfApplicants', StringUtils.convertToString(attb_NumberOfApplicants) );
            attributes.put('NumberOfLoans', StringUtils.convertToString(attb_NumberOfLoans));
            attributes.put('NumberOfSecurities', StringUtils.convertToString(attb_NumberOfSecurities));
            return createNode(parent, 'SummaryData', null, attributes);
        }
    }
    
    public class Comment extends XMLElement implements XmlElementInterface{
        
        public Dom.XmlNode getNode(){
            return createNode (parent, 'Comment', value);
        }
    }
    
    public class Country extends XMLElement implements XmlElementInterface {
        
        public String attb_ISO3166 {set; get;} //Yes	The ISO3166 code for the coutry of application AU or NZ
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            attributes.put('ISO3166', StringUtils.convertToString(attb_ISO3166));
            return createNode (parent, 'Country', null, attributes);
        }
    }
    
    public class SalesChannel extends XMLElement implements XmlElementInterface {
        
        public String attb_SalesChannelDescription {set; get;} //No	Must be set to your specific brokage name when providing Broker Group details
        public String attb_SalesChannelType {set; get;} //No	Must be set to Broker when providing Broker details
        public Identifier identifier {set; get;} //Yes	The Liberty (LenderAssigned) unique Identifier for the Broker or Broker Group.
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_salesChannelDescription != null){
                attributes.put('SalesChannelDescription', StringUtils.convertToString(attb_SalesChannelDescription));
            }
            if (attb_salesChannelType != null){
                attributes.put('SalesChannelType', StringUtils.convertToString(attb_SalesChannelType));
            }
            Dom.XmlNode salesChannel = createNode (parent, 'SalesChannel', null, attributes);
            if (identifier != null){
                identifier.parent = salesChannel;
            	salesChannel.getChildElements().add(identifier.getNode());
            }
            return salesChannel;
        }
    }
    
    public class PartySegment extends XMLElement implements XmlElementInterface{
        
        public List<Party> parties {set; get;} //Yes	A collection of all Party defined in the request
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode partySegment = createNode (parent, 'PartySegment', null);
            if (parties != null){
                for (Party party : parties){
                    if (party != null){
                        party.parent = partySegment;
                        partySegment.getChildElements().add(party.getNode());
                    }
                }
            }
            return partySegment;
        }
    }
    
    public class Party extends XMLElement implements XmlElementInterface {
        
        public String attb_Type {set; get;}
        public Identifier identifier {set; get;} //Yes	A single BrokerAssigned Identifier element
        public Person person {set; get;} //Yes	Either a Person or Company element
        public Company company {set; get;} //Yes	Either a Person or Company element
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_type != null){
                attributes.put('Type', StringUtils.convertToString(attb_Type));
            }
            Dom.XmlNode party = createNode (parent, 'Party', null, attributes);
            if (identifier != null){
                identifier.parent = party;
                party.getChildElements().add(identifier.getNode());
            }
            if (person != null){
                person.parent = party;
                party.getChildElements().add(person.getNode());
            }
            if (company != null){
                company.parent = party;
                party.getChildElements().add(company.getNode());
            }
            return party;
        }
    }
    
    public class Person extends XMLElement implements XmlElementInterface{
        
        public String attb_PreviousName {set; get;} //No	The applicant’s previous name if any
        public String attb_Sex {set; get;} //Yes	One of Male or Female
        public String attb_WorkingHours {set; get;} //No	Working hours per week. Required if the applicant has LPI insurance
        
        public ContactDetails contactDetails {set; get;} //Yes	See ContactDetails element for more information
        public DateOfBirth dateOfBirth {set; get;} //Yes	See DateOfBirth element for more information
        public List<Dependent> dependents {set; get;} //Yes	One or more dependent elements. See Dependent element for more information
        public DriversLicence driversLicence {set; get;} //Yes	See DriversLicence element for more information
        public List<Employment> employments {set; get;} //No	One or more Employment elements detailing applicant’s employment history
        public MaritalStatus maritalStatus {set; get;} //Yes	See MaritalStatus element for more information
        public List<PersonalReference> personalReferences {set; get;} //Yes	See PersonalReference element for more information
        public PersonName personName {set; get;} //Yes	See PersonName element for more information
        public Residency residency {set; get;} //Yes	See Residency element for more information
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_PreviousName != null){
                attributes.put('PreviousName', StringUtils.convertToString(attb_PreviousName));
            }
            if (attb_sex != null){
                attributes.put('Sex', StringUtils.convertToString(attb_Sex));
            }
            Dom.XmlNode person = createNode (parent, 'Person', null, attributes);
			if (personName != null){
                personName.parent = person;
                person.getChildElements().add(personName.getNode());
            }
            if (dateOfBirth != null){
                dateOfBirth.parent = person;
                person.getChildElements().add(dateOfBirth.getNode());
            }
            if (maritalStatus != null){
                maritalStatus.parent = person;
                person.getChildElements().add(maritalStatus.getNode());
            }
            
            if (dependents != null){
                for (Dependent dependent : dependents){
                    if (dependent != null){
                        dependent.parent = person;
                		person.getChildElements().add(dependent.getNode());
                    }
                }
            }
            if (driversLicence != null){
                driversLicence.parent = person;
                person.getChildElements().add(driversLicence.getNode());
            }
            if (residency != null){
                residency.parent = person;
                person.getChildElements().add(residency.getNode());
            }
            if (contactDetails != null){
                contactDetails.parent = person;
                person.getChildElements().add(contactDetails.getNode());
            }  
            if (employments != null){
                for (Employment employment : employments){
                    if (employment != null){
                        employment.parent = person;
                        person.getChildElements().add(employment.getNode());
                    }
                }
            }
            if (personalReferences != null){
                for (PersonalReference personalReference : personalReferences){
                    if (personalReference != null){
                        personalReference.parent = person;
                        person.getChildElements().add(personalReference.getNode());
                    }
                }
            }
            
            return person;
        }
    }
    
    public class ContactDetails extends XMLElement implements XmlElementInterface{
        
        public List<AddressDetails> addressDetails {set; get;} //Yes	One of the AddressDetails HomePhone WorkPhone or Email elements
        public HomePhone homePhone {set; get;} //Yes	One of the AddressDetails HomePhone WorkPhone or Email elements
        public WorkPhone workPhone {set; get;} //Yes	One of the AddressDetails HomePhone WorkPhone or Email elements
        public Email email {set; get;} //Yes	One of the AddressDetails HomePhone WorkPhone or Email elements
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode contactDetails = createNode (parent, 'ContactDetails', null);
            if (addressDetails != null){
                for (AddressDetails addDet : addressDetails){
                    if (addDet != null){
                        addDet.parent = contactDetails;
                        contactDetails.getChildElements().add(addDet.getNode());
                    }
                }
            }
            if (homePhone != null){
                homePhone.parent = contactDetails;
                contactDetails.getChildElements().add(homePhone.getNode());
            }
            if (workPhone != null){
                workPhone.parent = contactDetails;
                contactDetails.getChildElements().add (workPhone.getNode());
            }
            if (email != null){
                email.parent = contactDetails;
                contactDetails.getChildElements().add (email.getNode());
            }
            return contactDetails;
        }
    }
    
    public class AddressDetails extends XMLElement implements XmlElementInterface {
        
        public String attb_Mailing {set; get;} //Yes	Indicates the address as being used for postage purposes. Either Yes or No
        public String attb_Residential {set; get;} //Yes	Indicates the address as being residential in nature. Either Yes or No
        public String attb_RegisteredOffice {set; get;} //No	Used to flag a business entities address. Either Yes or No
        public String attb_PostSettlement {set; get;} //No	Used to flag an address to be used post settlement. Either Yes or No
        public String attb_PriorAddress {set; get;} //Yes	Indicates a previous address. Either Yes or No
        public String attb_HousingStatus {set; get;} //No	The residential address status. Either Boarding RentingRealEstateAgent RentingOther OwnHome OwnHomeMortgage WithParents FreeAccommodation or Other
        
        public Address address {set; get;} //Yes	A Address or RelatedEntityRef element referencing an Address
        public RelatedEntityRef relatedEntityRef {set; get;} // Yes	A Address or RelatedEntityRef element referencing an Address
        public StartAndEndDates startAndEndDates {set; get;} //No	See StartAndEndDates or Duration elements for more information
        public Duration duration {set; get;}
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_Mailing != null){
                attributes.put('Mailing', attb_Mailing);
            }
            if (attb_Residential != null){
                attributes.put('Residential', attb_Residential);
            }
            if (attb_RegisteredOffice != null){
                attributes.put('RegisteredOffice', attb_RegisteredOffice);
            }
            if (attb_PostSettlement != null){
                attributes.put('PostSettlement', attb_PostSettlement);
            }
            if (attb_PriorAddress != null){
                attributes.put('PriorAddress', attb_PriorAddress);
            }
            if (attb_HousingStatus != null){
                attributes.put('HousingStatus', attb_HousingStatus);
            }
            
            Dom.XmlNode addressDetails = createNode (parent, 'AddressDetails', null, attributes);
            if (address != null){
                address.parent = addressDetails;
                addressDetails.getChildElements().add(address.getNode());
            }
            if (relatedEntityRef != null){
                relatedEntityRef.parent = addressDetails;
                addressDetails.getChildElements().add(relatedEntityRef.getNode());
            }
            if (startAndEndDates != null){
                startAndEndDates.parent = addressDetails;
                addressDetails.getChildElements().add(startAndEndDates.getNode());
            }
            if (duration != null){
                duration.parent = addressDetails;
                addressDetails.getChildElements().add(duration.getNode());
            }
            return addressDetails;
        }
    }
    
    public class Address extends XMLElement implements XmlElementInterface{
        
        public State state		{set; get;} //Yes	See State element for more information
        public Postcode postcode	{set; get;} //Yes	See Postcode element for more information
        public UnitNo unitNo	{set; get;} //No	See UnitNo element for more information
		public StreetNo streetNo	{set; get;} //Yes	See StreetNo element for more information
		public Street street	{set; get;} //Yes	See Street element for more information
		public City city		{set; get;} //Yes	See City element for more information
		public Country country	{set; get;} //Yes	See Country element for more information
        public NonStdAddress nonStdAddress {set; get;} //Yes	See NonStdAddress element for more information
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode	address = createNode (parent, 'Address', null);
            if (unitNo != null){
                unitNo.parent = address;
                address.getChildElements().add(unitNo.getNode());
            }
            if (streetNo != null){
                streetNo.parent = address;
                address.getChildElements().add(streetNo.getNode());
            }
            if (street != null){
                street.parent = address;
                address.getChildElements().add(street.getNode());
            }
            if (city != null){
                city.parent = address;
                address.getChildElements().add(city.getNode());
            }
            if (state != null){
                state.parent = address;
                address.getChildElements().add(state.getNode());
            }
            if (postcode != null){
                postcode.parent = address;
                address.getChildElements().add(postcode.getNode());
            }
            if (country != null){
                country.parent = address;
                address.getChildElements().add(country.getNode());
            }
            if (nonStdAddress != null){
                nonStdAddress.parent = address;
                address.getChildElements().add(nonStdAddress.getNode());
            }
            return address;
        }
    }
    
    public class UnitNo extends XmlElement implements XmlElementInterface {
        
        public Dom.XmlNode getNode(){
            return createNode (parent, 'UnitNo', StringUtils.convertToString(value));
        }
    }
    
    public class StreetNo extends XmlElement implements XmlElementInterface {
        
        public Dom.XmlNode getNode(){
            return createNode (parent, 'StreetNo', StringUtils.convertToString(value));
        }
    }
    
    public class Street  extends XmlElement implements XmlElementInterface {
        
        public String attb_Type {set; get;} //Yes	The Street Type as a text value. e.g. RD ST etc
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_Type != null){
                attributes.put('Type', StringUtils.convertToString(attb_Type));
            }
            return createNode (parent, 'Street', StringUtils.convertToString(value), attributes);
        }
    }
    
    public class City extends XmlElement implements XmlElementInterface {
        
        public Dom.XmlNode getNode(){
            return createNode (parent, 'City', StringUtils.convertToString(value));
        }
    }
    
    public class Postcode  extends XmlElement implements XmlElementInterface {
        
        public Dom.XmlNode getNode(){
            return createNode (parent, 'Postcode', StringUtils.convertToString(value));
        }
    }
    
    public class State extends XmlElement implements XmlElementInterface {
        
        public String attb_Name {set; get;} //Yes	One of ACT NSW NT QLD SA TAS VIC or WA
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_Name != null){
                attributes.put('Name', StringUtils.convertToString(attb_Name));
            }
            return createNode (parent, 'State', StringUtils.convertToString(value), attributes);
        }
    }
    
    public class NonStdAddress extends XmlElement implements XmlElementInterface {
        
        public Dom.XmlNode getNode(){
            return createNode (parent, 'NonStdAddress', StringUtils.convertToString(value));
        }
    }
    
    public class RelatedEntityRef extends XMLElement implements XmlElementInterface {
        
        public String attb_RelatedID {set; get;} //Yes	The identifier for the related entity usually captured as the UniqueID on an Identifier element 
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_RelatedID != null){
                attributes.put('RelatedID', attb_RelatedID);
            }
            return createNode (parent, 'RelatedEntityRef ', null, attributes);
        }
    }
    
    public class Duration extends XMLElement implements XmlElementInterface {
        
        public String attb_Length {set; get;} //Yes	The duration length as an integer
        public String attb_Units {set; get;} //Yes	One of Months or Years
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            attributes.put('Length', attb_Length);
            attributes.put('Units', attb_Units);
            return createNode (parent, 'Duration', null, attributes);
        }
    }
    
    public class StartAndEndDates extends XMLElement implements XmlElementInterface {
        public StartDate startDate {set; get;}
        public EndDate endDate{set; get;}
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode startAndEndDates = createNode (parent, 'StartAndEndDates', null);
            if (startDate != null){
                startDate.parent = startAndEndDates;
                startAndEndDates.getChildElements().add(startDate.getNode());
            }
            if (endDate != null){
                endDate.parent = startAndEndDates;
                startAndEndDates.getChildElements().add(endDate.getNode());
            }else{
                Dom.XmlNode currentDate = createNode (startAndEndDates, 'CurrentDate', null);
                startAndEndDates.getChildElements().add(currentDate);
            }
            return startAndEndDates;
        }
    }
    
    public class StartDate  extends XMLElement implements XmlElementInterface{
        
        public DateE dateE {set; get;}

		public StartDate (DateE dateE){
            this.dateE = dateE;
        }        
        public Dom.XmlNode getNode(){
            Dom.XmlNode startDate  = createNode (parent, 'StartDate', null);
            if (dateE != null){
                dateE.parent = startDate;
                startDate.getChildElements().add(dateE.getNode());
            }
            return startDate;
        }
    }   
    
    public class EndDate  extends XMLElement implements XmlElementInterface{
        
        public DateE dateE {set; get;}
        
        public EndDate (DateE dateE){
            this.dateE = dateE;
        }
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode endDate = createNode (parent, 'EndDate', null);
            if (dateE != null){
                dateE.parent = endDate;
                endDate.getChildElements().add(dateE.getNode());
            }
            return endDate;
        }
    }
    
    public class DateE extends XMLElement implements XmlElementInterface{
        
        public DateE (String value){
            this.value = value;
        }
        
        public Dom.XmlNode getNode(){
            return createNode (parent, 'Date', value);
        }
    }
    
    public class HomePhone extends XMLElement implements XmlElementInterface {
        
        public Phone phone {set; get;}
        public String attb_PreferredContactMethod {set; get;}
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_PreferredContactMethod != null){
                attributes.put('PreferredContactMethod', attb_PreferredContactMethod);
            }
            Dom.XmlNode homePhone = createNode (parent, 'HomePhone', null, attributes);
            if (phone != null){
                phone.parent = homePhone;
                homePhone.getChildElements().add(phone.getNode());
            }
            return homePhone;
        }
    }
    
    public class WorkPhone extends XMLElement implements XmlElementInterface {
        
        public Phone phone {set; get;}
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode workPhone = createNode (parent, 'WorkPhone', null);
            if (phone != null){
                phone.parent = workPhone;
                workPhone.getChildElements().add(phone.getNode());
            }
            return workPhone;
        }
    }
    
    public class Phone extends XMLElement implements XmlElementInterface {
        public String mobile {set; get;}
        public String fixedPhone {set; get;}
        public String fax {set; get;}
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode phone = createNode (parent, 'Phone', null);
            if (mobile != null){
                createNode (phone, 'Mobile', value);
            }
            if (fixedPhone != null){
                createNode (phone, 'FixedPhone', value);
            }
            if (fax != null){
                createNode (phone, 'Fax', value);
            }
            return phone;
        }
    }
    
    public class Email extends XMLElement implements XmlElementInterface {
        
        public Dom.XmlNode getNode (){
            return createNode (parent, 'Email', value);
        }
    }
    
    public class DateOfBirth extends XMLElement implements XmlElementInterface {
        
        public DateE dateE {set; get;}
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode dateOfBirth = createNode (parent, 'DateOfBirth', null);
            if (dateE != null){
                dateE.parent = dateOfBirth;
                dateOfBirth.getChildElements().add(dateE.getNode());
            }
            return dateOfBirth;
        }
    }
    
    public class Dependent extends XMLElement implements XmlElementInterface {
        
        public String attb_Age {set; get;} //Yes	The age of the dependent in years
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_Age != null){
                attributes.put('Age', attb_Age);
            }
            return createNode (parent, 'Dependent', null, attributes);
        }
    }
    
    public class DriversLicence extends XMLElement implements XmlElementInterface {
        
        public String attb_DriversLicenceNumber {set; get;} //Yes	The drivers licence number
        public String attb_ExpiryDate {set; get;} //Yes	The licence expiry date in yyyy-mm-dd format
        public String attb_LicenceType {set; get;} //Yes	One of Full Provisional or Learners
        public State state {set; get;} //Yes	See State element for more information
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_DriversLicenceNumber != null){
                attributes.put('DriversLicenceNumber', attb_DriversLicenceNumber);
            }
            if (attb_ExpiryDate != null){
                attributes.put('ExpiryDate', attb_ExpiryDate);
            }
            if (attb_LicenceType != null){
                attributes.put('LicenceType', attb_LicenceType);
            }
            Dom.XmlNode driversLicence = createNode (parent, 'DriversLicence', null, attributes);
            if (state != null){
                state.parent = driversLicence;
                driversLicence.getChildElements().add(state.getNode());
            }
            return driversLicence;
        }
    }
    
    public class Employment extends XMLElement implements XmlELementInterface{
        
        public String attb_OnProbation {set; get;} //No	Indicates a paye employment probation period is in effect. Specify Yes or No
        public String attb_RoleFreeText {set; get;} //No	For payee employees, one of the Liberty defined Paye occupations defined below
        
        public RelatedEntityRef relatedEntityRef {set; get;} //Yes	See RelatedEntityRef element for more information
        public PAYE paye {set; get;} //Yes	See the PAYE SelfEmployed and Unemployed elements for more information
        public SelfEmployed selfEmployed {set; get;} //Yes	See the PAYE SelfEmployed and Unemployed elements for more information
        public Unemployed unemployed {set; get;} //Yes	See the PAYE SelfEmployed and Unemployed elements for more information
        public StartAndEndDates startAndEndDates {set; get;} //Yes	See StartAndEndDates element for more information
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_OnProbation != null){
                attributes.put('OnProbation', attb_OnProbation);
            }
            if (attb_RoleFreeText != null){
                attributes.put('RoleFreeText', attb_RoleFreeText);
            }
            Dom.XmlNode employment = createNode (parent, 'Employment', null, attributes);
            if (relatedEntityRef != null){
                relatedEntityRef.parent = employment;
                employment.getChildElements().add(relatedEntityRef.getNode());
            }
            if (paye != null){
                paye.parent = employment;
                employment.getChildElements().add(paye.getNode());
            }
            if (selfEmployed != null){
                selfEmployed.parent = employment;
                employment.getChildElements().add(selfEmployed.getNode());
            }
            if (unemployed != null){
                unemployed.parent = employment;
                employment.getChildElements().add(unemployed.getNode());
            }
            if (startAndEndDates != null){
                startAndEndDates.parent = employment;
                employment.getChildElements().add(startAndEndDates.getNode());
            }
            return employment;
        }
    }
    
    public class PAYE extends XMLElement implements XmlElementInterface {
        
        public String attb_Type {set; get;} //Yes	One of FullTime FullTime PartTime Contract or Casual
        public RelatedEntityRef relatedEntityRef {set; get;} //Yes	A RelatedEntityRef reference to a RelatedPartySegment Employer or PartySegment Company
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_Type != null){
                attributes.put('Type', attb_Type);
            }
            Dom.XmlNode paye = createNode (parent, 'PAYE', null, attributes);
            if (relatedEntityRef != null){
                relatedEntityRef.parent = paye;
                paye.getChildElements().add(relatedEntityRef.getNode());
            }
            return paye;
        }
    }
    
    public class SelfEmployed extends XMLElement implements XmlElementInterface {
        
        public RelatedEntityRef relatedEntityRef {set; get;} //Yes	A RelatedEntityRef reference to a RelatedPartySegment Employer or PartySegment Company
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode selfEmployed = createNode (parent, 'SelfEmployed', null);
            if (relatedEntityRef != null){
                relatedEntityRef.parent = selfEmployed;
                selfEmployed.getChildElements().add(relatedEntityRef.getNode());
            }
            return selfEmployed;
        }
    }
    
    public class Unemployed extends XMLElement implements XmlElementInterface {
        
        public Dom.XmlNode getNode(){
            return createNode (parent, 'Unemployed', null);
        }
    }
    
    public class MaritalStatus extends XMLElement implements XmlElementInterface {
        
        public String attb_Status {set; get;} //Yes	One of Single Married DeFacto Separated Divorced or Widowed
        public RelatedEntityRef relatedEntityRef {set; get;} //No	An optional RelatedEntityRef element
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_Status != null){
                attributes.put('Status', attb_Status);
            }
            Dom.XmlNode maritalStatus = createNode(parent, 'MaritalStatus', null, attributes);
            If (relatedEntityRef != null){
                relatedEntityRef.parent = maritalStatus;
                maritalStatus.getChildElements().add(relatedEntityRef.getNode());
            }
            return maritalStatus;
        }
    }
    
    public class PersonalReference extends XMLElement implements XmlElementInterface{
        
        public String attb_ReferenceType {set; get;} //Yes	The type of relationship captured. Personal Relative or Agent
        public String attb_Relationship {set; get;} //Yes	Text defining the relationship nature. e.g. Brother Spouse Real Estate etc.
        
        public RelatedEntityRef relatedEntityRef {set; get;} //Yes	An RelatedEntityRef element referencing the related party
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_ReferenceType != null){
                attributes.put('ReferenceType', attb_ReferenceType);
            }
            if (attb_Relationship != null){
                attributes.put('Relationship', attb_Relationship);
            }
            Dom.XmlNode personalReference = createNode (parent, 'PersonalReference', null, attributes);
            if (relatedEntityRef != null){
                relatedEntityRef.parent = personalReference;
                personalReference.getChildElements().add(relatedEntityRef.getNode());
            }
            return personalReference;
        }
    }
    
    public class PersonName extends XMLElement implements XmlElementInterface {
        
        public NameTitle nameTitle {set; get;} //Yes	One of Mr Mrs Miss Ms or Dr
        public FirstName firstName {set; get;}
        public OtherName otherName {set; get;}
        public Surname surname {set; get;}
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode personName = createNode (parent ,'PersonName', null);
            if (nameTitle != null){
                nameTitle.parent = personName;
                personName.getChildElements().add(nameTitle.getNode());
            }
            if (firstName != null){
                firstName.parent = personName;
                personName.getChildElements().add(firstName.getNode());
            }
            if (otherName != null){
                otherName.parent = personName;
                personName.getChildElements().add(otherName.getNode());
            }
            if (surname != null){
                surname.parent = personName;
                personName.getChildElements().add(surname.getNode());
            }
            return personName;
        }
    }
    
    public class NameTitle extends XMLElement implements XmlElementInterface{
        
        public String attb_Value {set; get;}
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_Value != null){
                attributes.put('Value', attb_Value);
            }
            return createNode (parent, 'NameTitle', null, attributes);
        }
    }
    
    public class FirstName extends XMLElement implements XmlElementInterface{
        public FirstName (String value){
            this.value = value;
        }
        public Dom.XmlNode getNode(){
            return createNode (parent, 'FirstName', value);
        }
    }
    
    public class OtherName extends XMLElement implements XmlElementInterface{
        public OtherName (String value){
            this.value = value;
        }
        public Dom.XmlNode getNode(){
            return createNode (parent, 'OtherName', value);
        }
    }
    
    public class Surname extends XMLElement implements XmlElementInterface{
        public Surname (String value){
            this.value = value;
        }
        public Dom.XmlNode getNode(){
            return createNode (parent, 'Surname', value);
        }
    }
    
    public class Residency extends XMLElement implements XmlElementInterface {
        
        public String attb_Status {set; get;} //Yes	One of PermanentResident Citizen or NonResident
        public Country country {set; get;} //Yes	See Country element for more information
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_Status != null){
                attributes.put('Status', attb_Status);
            }
            Dom.XmlNode residency = createNode (parent, 'Residency', null, attributes);
            if (country != null){
                country.parent = residency;
                residency.getChildElements().add(country.getNode());
            }
            return residency;
        }
    }
    
    public class Company extends XMLElement implements XmlElementInterface {
        
        public CompanyName companyName {set; get;} //Yes	See CompanyName element for more information
        public ContactDetails contactDetails {set; get;} //Yes	One or more ContactDetails elements
        public Director director {set; get;} //No	One or more Director elements
        public Shareholder shareholder {set; get;} //No	One or more Shareholder elements
        public CompanyType companyType {set; get;} //Yes	See CompanyType element for more information
        public CompanyNumber companyNumber {set; get;} //Yes	See CompanyNumber element for more information
        public Business business {set; get;} //Yes	See Business element for more information
        public RegisteredIn registeredIn {set; get;} //No	See RegisteredIn element for more information
        public CreditHistory creditHistory {set; get;} //No define
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode company = createNode(parent, 'Company', null);
            if (companyName != null){
                companyName.parent = company;
                company.getChildElements().add(companyName.getNode());
            }
            if (contactDetails != null){
                contactDetails.parent = company;
                company.getChildElements().add(contactDetails.getNode());
            }
            if (director != null){
                director.parent = company;
                company.getChildElements().add(director.getNode());
            }
            if (shareholder != null){
                shareholder.parent = company;
                company.getChildElements().add(shareholder.getNode());
            }
            if (companyType != null){
                companyType.parent = company;
                company.getChildElements().add(companyType.getNode());
            }
            if (companyNumber != null){
                companyNumber.parent = company;
                company.getChildElements().add(companyNumber.getNode());
            }
            if (registeredIn != null){
                registeredIn.parent = company;
                company.getChildElements().add(registeredIn.getNode());
            }
            if (business != null){
                business.parent = company;
                company.getChildElements().add(business.getNode());
            }
            /**
            if (creditHistory != null){
                creditHistory.parent = company;
                company.getChildElements().add(creditHistory.getNode());
            }**/
            return company;
        }
    }
    
    public class CreditHistory extends XMLElement implements XmlElementInterface {
        
        public String attb_CreditStatus {set; get;}
        public BorrowerProvHistory borrowerProvHistory {set; get;}
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_CreditStatus != null){
                attributes.put('CreditStatus', attb_CreditStatus);
            }
            Dom.XmlNode creditHistory = createNode (parent, 'CreditHistory', null, attributes);
            if (borrowerProvHistory != null){
                borrowerProvHistory.parent = creditHistory;
                creditHistory.getChildElements().add(borrowerProvHistory.getNode());
            }
            return creditHistory;
        }
    }
    
    public class BorrowerProvHistory extends XMLElement implements XmlElementInterface{
        
        public RelatedEntityRef relatedEntityRef {set; get;}
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode borrowerProvHistory = createNode (parent, 'BorrowerProvHistory', null);
            if (relatedEntityRef != null){
                relatedEntityRef.parent = borrowerProvHistory;
                borrowerProvHistory.getChildElements().add(relatedEntityRef.getNode());
            }
            return borrowerProvHistory;
        }
    }
    
    public class CompanyName extends XMLElement implements XmlElementInterface {
        
        public String attb_BusinessName {set; get;} //Yes	Defines the Business Name of the Company. Max length of 150 characters
        
        public Dom.XmlNode getNode(){
			Map<String, String> attributes = new Map<String, String>();
            //if (attb_BusinessName != null ){
                attributes.put('BusinessName', attb_BusinessName);
            //}     
            return createNode (parent, 'CompanyName', null, attributes);
        }
    }
    
    public class Director extends XMLElement implements XmlElementInterface {
        
        public RelatedEntityRef relatedEntityRef {set; get;} //Yes	An RelatedEntityRef element referencing the related party
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode director = createNode (parent, 'Director', null);
            if (relatedEntityRef != null){
                relatedEntityRef.parent = director;
                director.getChildElements().add(relatedEntityRef.getNode());
            }
            return director;
        }
    }
    
    public class Shareholder extends XMLElement implements XmlElementInterface {
        
        public RelatedEntityRef relatedEntityRef {set; get;} //Yes	An RelatedEntityRef element referencing the related party
        public String attb_OwnershipPercentage {set; get;} //Yes	The percentage ownership as an integer
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_OwnershipPercentage != null){
                attributes.put('OwnershipPercentage', attb_OwnershipPercentage);
            }
            Dom.XmlNode shareholder = createNode (parent, 'Shareholder', null, attributes);
            if (relatedEntityRef != null){
                relatedEntityRef.parent = shareholder;
                shareholder.getChildElements().add(relatedEntityRef.getNode());
            }
            return shareholder;
        }
    }
    
    public class CompanyType extends XMLElement implements XmlElementInterface {
        public String attb_Type {set; get;} //No	One of Ltd NL Inc or PtyLtd
        public String attb_Description {set; get;} //Yes	Specify SoleTrader Partnership or Company
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_Type != null){
                attributes.put('Type', attb_Type);
            }
            if (attb_Description != null){
                attributes.put('Description', attb_Description);
            }
            return createNode (parent, 'CompanyType', null, attributes);
        }
    }
    
    public class CompanyNumber extends XMLElement implements XmlElementInterface{
        
        public String attb_ACN {set; get;} //No	Australian Company Number. Max length of 9
        public String attb_ABN {set; get;} //No	Australian Business Number. Max length of 11
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_ACN != null){
                attributes.put('ACN', attb_ACN);
            }
            if (attb_ABN != null){
                attributes.put('ABN', attb_ABN);
            }
            return createNode(parent, 'CompanyNumber', null, attributes);
        }
    }
    
    public class Business extends XMLElement implements XmlElementInterface{
        
        public String attb_BusinessNatureFreeText {set; get;} //No	One of the Occupation Groups defined below
        public StartDate startDate {set; get;} //No	See StartDate element for more information
        public GSTRegistrationDate gstRegistrationDate {set; get;} //No	See GSTRegistrationDate element for more information
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_BusinessNatureFreeText != null){
                attributes.put('BusinessNatureFreeText', attb_BusinessNatureFreeText);
            }
            Dom.XmlNode business = createNode (parent, 'Business', null, attributes);
            if (startDate != null){
                startDate.parent = business;
                business.getChildElements().add(startDate.getNode());
            }
            if (gstRegistrationDate != null){
                gstRegistrationDate.parent = business;
                business.getChildElements().add(gstRegistrationDate.getNode());
            }
            return business;
        }
    }
    
    public class GSTRegistrationDate extends XMLElement implements XmlElementInterface{
       
        public DateE dateE {set; get;} //Yes	See Date element for more information
		
        public Dom.XmlNode getNode(){
            Dom.XmlNode gstRegistrationDate = createNode (parent, 'GSTRegistrationDate', null);
            if (dateE != null){
                dateE.parent = gstRegistrationDate;
                gstRegistrationDate.getChildElements().add(dateE.getNode());
            }
            return gstRegistrationDate;
        }        
    }
    
    public class RegisteredIn extends XMLElement implements XmlElementInterface {
        
        public DateE dateE {set; get;} //Yes	The company date of registration as text
        public State state {set; get;} //Yes	See State element for more information
        public Country country {set; get;} //Yes	See Country element for more information
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode registeredIn = createNode (parent, 'RegisteredIn', null);
            if (dateE != null){
                dateE.parent = registeredIn;
                registeredIn.getChildElements().add(dateE.getNode());
            }
            if (state != null){
                state.parent = registeredIn;
                registeredIn.getChildElements().add(state.getNode());
            }
            if (country != null){
                country.parent = registeredIn;
                registeredIn.getChildElements().add(country.getNode());
            }
            return registeredIn;
        }
    }
    
    public class DeclarationSegment extends XMLElement implements XmlElementInterface {
        
        public List<DeclarationAnswer> declarationAnswers {set; get;} //Yes	See DeclarationAnswer element for more information
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode declarationSegment = createNode (parent , 'DeclarationSegment', null);
            if (declarationAnswers != null){
                for (DeclarationAnswer declarationAnswer : declarationAnswers){
                    if (declarationAnswer != null){
                        declarationAnswer.parent = declarationSegment;
                        declarationSegment.getChildElements().add(declarationAnswer.getNode());
                    }
                }
            }
            return declarationSegment;
        }
    }
    
    public class DeclarationAnswer extends XMLElement implements XmlElementInterface {
        
        public String attb_QuestionIdentifier {set; get;} //Yes	One of MOTOR_PAYMENT MOTOR_BANKRUPTCY or MOTOR_CHANGES
        public Answer answer {set; get;} //Yes	See Answer element for more information
        public FreeText freeText {set; get;}  //Yes	See FreeText element for more information
        public RelatedEntityRef relatedEntityRef {set; get;} //Yes	A RelatedEntityRef element to the associated Party
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_QuestionIdentifier != null){
                attributes.put ('QuestionIdentifier', attb_QuestionIdentifier);
            }
            Dom.XmlNode declarationAnswer = createNode (parent, 'DeclarationAnswer', null, attributes);
            if (answer != null){
                answer.parent = declarationAnswer;
                declarationAnswer.getChildElements().add(answer.getNode());
            }
            if (freeText != null){
                freeText.parent = declarationAnswer;
                declarationAnswer.getChildElements().add(freeText.getNode());
            }
            if (relatedEntityRef != null){
                relatedEntityRef.parent = declarationAnswer;
                declarationAnswer.getChildElements().add(relatedEntityRef.getNode());
            }
            return declarationAnswer;
        }
    }
    
    public class Answer extends XMLElement implements XmlElementInterface {
        
        public Dom.XmlNode getNode(){
            return createNode (parent , 'Answer', value);
        }
    }
    
    public class FreeText  extends XMLElement implements XmlElementInterface {
        
        public Dom.XmlNode getNode(){
            return createNode (parent , 'FreeText', value);
        }
    }
    
    public class FinancialSegment extends XMLElement implements XmlElementInterface {
        
        public List<ValueItem> valueItems {set; get;} //Yes	One or more ValueItem elements
        
        public Dom.XmlNode getNode (){
            Dom.XmlNode financialSegment = createNode(parent, 'FinancialSegment', null);
            if (valueItems != null){
                for (LibertyApplicationDTO.ValueItem valueItem : valueItems){
                    if (valueItem != null){
                        valueItem.parent = financialSegment;
                        financialSegment.getChildElements().add(valueItem.getNode());
          		    }
                }
            }
            
            return financialSegment;
        }
    }
    
    public class ValueItem extends XMLElement implements XmlElementInterface {
        
        public String attb_Value {set; get;} //Yes	An decimal number showing the value of the Asset Income or Expense
        public Identifier identifier  {set; get;} //Yes	A BrokerAssigned Identifier to uniqely identify the Related Party
        public PercentOwned percentOwned {set; get;} //Yes	See PercentOwned element for more information
        public Asset asset {set; get;} //Yes	See the Asset Income Expense and Liability elements for more information
        public Income income {set; get;} //Yes	See the Asset Income Expense and Liability elements for more information
        public Expense expense {set;  get;} //Yes	See the Asset Income Expense and Liability elements for more information
        public Liability liability {set; get;} //Yes	See the Asset Income Expense and Liability elements for more information
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_Value != null){
                attributes.put('Value', attb_Value);
            }
            Dom.XmlNode valueItem = createNode (parent, 'ValueItem', null, attributes);
            if (identifier != null){
                identifier.parent = valueItem;
                valueItem.getChildElements().add(identifier.getNode());
            }
            if (percentOwned != null){
                percentOwned.parent = valueItem;
                valueItem.getChildElements().add(percentOwned.getNode());
            }
            if (asset != null){
                asset.parent = valueItem;
                valueItem.getChildElements().add(asset.getNode());
            }
            if (income != null){
                income.parent = valueItem;
                valueItem.getChildElements().add(income.getNode());
            }
            if (expense != null){
                expense.parent = valueItem;
                valueItem.getChildElements().add(expense.getNode());
            }
            if (liability != null){
                liability.parent = valueItem;
                valueItem.getChildElements().add(liability.getNode());
            }
            return valueItem;
        }
    }
    
    public class PercentOwned extends XMLElement implements XmlElementInterface  {
        
        public String attb_Percent {set; get;} //Yes	The percentage owned as an integer
        public RelatedEntityRef relatedEntityRef {set; get;} //Yes	A RelatedEntityRef element reference to a Party from the PartySegment
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_Percent != null){
                attributes.put('Percent', attb_Percent);
            }
            Dom.XmlNode percentOwned = createNode(parent, 'PercentOwned', null, attributes);
            if (relatedEntityRef != null){
                relatedEntityRef.parent = percentOwned;
                percentOwned.getChildElements().add(relatedEntityRef.getNode());
            }
            return percentOwned;
        }
    }
    
    public class Income extends XMLElement implements XmlElementInterface {
        
        public Period period {set; get;} //Yes	See Period element for more information
        public String attb_AddbackType {set; get;} //No	Depreciation InterestPaid NonRecurringExpenses or CarriedForwardLosses
        public String attb_Description {set; get;} //No	A text description for the income
        public String attb_GovernmentBenefitsType {set; get;} //Yes	One of the Government Benefits Types defined below. Mandatory for GovernmentBenefits IncomeType
        public String attb_IncomeType {set; get;} //Yes	One of the Income Types defined below
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_AddbackType != null){
                attributes.put('AddbackType', attb_AddbackType);
            }
            if (attb_Description != null){
                attributes.put('Description', attb_Description);
            }
            if (attb_GovernmentBenefitsType != null){
                attributes.put('GovernmentBenefitsType', attb_GovernmentBenefitsType);
            }
            if (attb_IncomeType != null){
                attributes.put('Type', attb_IncomeType);
            }
            Dom.XmlNode income = createNode (parent, 'Income', null, attributes);
            if (period != null){
                period.parent = income;
                income.getChildElements().add(period.getNode());
            }
            return income;
        }
    }
    
    public class Expense extends XMLElement implements XmlElementInterface {
        
        public String attb_Type {set; get;} //Yes	One of the Expense Types defined below
        public Period period {set; get;} //Yes	See Period element for more information
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_Type != null){
                attributes.put('Type', attb_Type.trim());
            }
            Dom.XmlNode expense = createNode (parent, 'Expense', null, attributes);
            if (period != null){
                period.parent = expense;
                expense.getChildElements().add(period.getNode());
            }
            return expense;
        }
    }
    
    public class Liability extends XMLElement implements XmlElementInterface {
        
        public RelatedEntityRef relatedEntityRef {set; get;} //Yes	A RelatedEntityRef element to a Lender defined within the RelatedPartySegment
        public ExistingLoan existingLoan {set; get;} //No	See ExistingLoan element for more information
        public AccountNumber accountNumber {set; get;} //Yes	See the AccountNumber or DepositAccount elements for more information
        public DepositAccount depositAccount {set; get;} //Yes	See the AccountNumber or DepositAccount elements for more information
        public String attb_Type {set; get;} //Yes	One of the Liability Types defined below
        public String attb_UnpaidBalance {set; get;} //No	The unpaid balance of the liability as an integer
        
        public Dom.XmlNode getNode (){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_Type != null){
                attributes.put('Type', attb_Type);
            }
            if (attb_UnpaidBalance != null){
                attributes.put('UnpaidBalance', attb_UnpaidBalance);
            }
            Dom.XmlNode liability = createNode (parent, 'Liability', null, attributes);
            if (relatedEntityRef != null){
                relatedEntityRef.parent = liability;
                liability.getChildElements().add(relatedEntityRef.getNode());
            }
            if (existingLoan != null){
                existingLoan.parent = liability;
                liability.getChildElements().add(existingLoan.getNode());
            }
            if (accountNumber != null){
                accountNumber.parent = liability;
                liability.getChildElements().add(accountNumber.getNode());
            }
            if (depositAccount != null){
                depositAccount.parent = liability;
                liability.getChildElements().add(depositAccount.getNode());
            }
            return liability;
        }
    }
    
    public class ExistingLoan extends XMLElement implements XmlElementInterface {
        
        public RelatedEntityRef relatedEntityRef {set; get;} //Yes	A RelatedEntityRef element to the Expense payment
        public List<LoanTerm> loanTerms {set; get;} //Yes	One or more LoanTerm elements
        public String attb_MonthsLeft {set; get;} //Yes	The number of repayment months left as an integer
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_MonthsLeft != null){
                attributes.put('MonthsLeft', attb_MonthsLeft);
            }
            Dom.XmlNode existingLoan = createNode (parent, 'ExistingLoan', null, attributes);
            if (relatedEntityRef != null){
                relatedEntityRef.parent = existingLoan;
                existingLoan.getChildElements().add(relatedEntityRef.getNode());
            }
            if (loanTerms != null){
                for (LoanTerm loanTerm : loanTerms){
                    if (loanTerm != null){
                        loanTerm.parent = existingLoan;
                		existingLoan.getChildElements().add(loanTerm.getNode());
                    }
                }
            }
            return existingLoan;
        }
    }
    
    public class LoanTerm extends XMLElement implements XmlElementInterface {
        
        public String attb_Type {set; get;} //No	Specify FixedRate Variable or TotalTerm
        public String attb_PaymentType {set; get;} //No	Specify InterestOnly or PrincipleAndInterest
        public String attb_Units {set; get;} //No	Months or Years. Defaults to Years
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_Type !=  null){
                attributes.put('Type', attb_Type);
            }
            if (attb_PaymentType !=  null){
                attributes.put('PaymentType', attb_PaymentType);
            }
            if (attb_Units !=  null){
                attributes.put('Units', attb_Units);
            }
            return createNode (parent, 'LoanTerm', value, attributes);
        }
    }
    
    public class AccountNumber extends XMLElement implements XmlElementInterface{
        
        public String attb_AcctNbr {set; get;} //Yes	The actual account number
        
        public Dom.XmlNode getNode (){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_AcctNbr !=  null){
                attributes.put('AcctNbr', attb_AcctNbr);
            }
            return createNode (parent, 'AccountNumber', null, attributes);
        }
    }
    
    public class Asset extends XMLElement implements XmlElementInterface{
        
        public String attb_Class {set; get;} //Yes	Specify from CurrentAsset CurrentSecurity or FutureSecurity
        public RealEstate realEstate {set; get;} //Yes	See the RealEstate and NonRealEstate elements for more information
        public NonRealEstate nonRealEstate {set; get;} //Yes	See the RealEstate and NonRealEstate elements for more information
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_Class != null){
                attributes.put('Class', attb_Class);
            }
            Dom.XmlNode asset = createNode (parent, 'Asset', null, attributes);
            if (realEstate != null){
                realEstate.parent = asset;
                asset.getChildElements().add(realEstate.getNode());
            }
            if (nonRealEstate != null){
                nonRealEstate.parent = asset;
                asset.getChildElements().add(nonRealEstate.getNode());
            }
            return asset;
        }
    }
    
    public class RealEstate extends XMLElement implements XmlElementInterface{
        
        public EstimatedValue estimatedValue {set; get;} //See EstimatedValue element for more information
        public ExistMortgage existMortgage {set; get;} //No	See ExistMortgage element for more information
        public Location location {set; get;} //Yes	See Location element for more information
        public RentalIncome rentalIncome {set; get;} //No	See RentalIncome element for more information
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode realEstate = createNode (parent, 'RealEstate', null);
            if (estimatedValue != null){
                estimatedValue.parent = realEstate;
                realEstate.getChildElements().add(estimatedValue.getNode());
            }
            if (location != null){
                location.parent = realEstate;
                realEstate.getChildElements().add(location.getNode());
            }
            if (rentalIncome != null){
                rentalIncome.parent = realEstate;
                realEstate.getChildElements().add(rentalIncome.getNode());
            }
            if (existMortgage != null){
                existMortgage.parent = realEstate;
                realEstate.getChildElements().add(existMortgage.getNode());
            }
            return realEstate;
        }
    }
    
    public class EstimatedValue extends XMLElement implements XmlElementInterface {
        
        public String attb_EstimateBasis {set; get;} //No	ApplicantEstimate or CertifiedValuation
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_EstimateBasis != null){
                attributes.put('EstimateBasis', attb_EstimateBasis); 
            }
            return createNode (parent, 'EstimatedValue', value, attributes);
        }
    }
    
    public class ExistMortgage  extends XMLELement implements XmlElementInterface {
        
        public RelatedEntityRef  relatedEntityRef  {set; get;} //Yes	A RelatedEntityRef element to link this to a Liability defined elsewhere in the Request
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode existMortgage = createNode (parent, 'ExistMortgage', null);
            if (relatedEntityRef != null){
                relatedEntityRef.parent = existMortgage;
                existMortgage.getChildElements().add(relatedEntityRef.getNode());
            }
            return existMortgage;
        }
    }
    
    public class Location extends XMLElement implements XmlElementInterface {

        public String attb_TitleType {set; get;}  //No	One of the Title Types defined below 
        public Address address {set; get;} //Yes	The Address or a RelatedEntityRef element reference
        public RelatedEntityRef  relatedEntityRef  {set; get;} //Yes	The Address or a RelatedEntityRef element reference
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_TitleType != null){
                attributes.put('TitleType', attb_TitleType );
            }
            Dom.XmlNode location = createNode (parent, 'Location', null, attributes);
            if (address != null){
                address.parent = location;
                location.getChildElements().add(address.getNode());
            }
            if (relatedEntityRef != null){
                relatedEntityRef.parent = location;
                location.getChildElements().add(relatedEntityRef.getNode());
            }
            return location;
        }
    }
    
    public class RentalIncome extends XMLElement implements XmlElementInterface {
        
        public Period period {set; get;} //Yes	See Period element for more information
        public String attb_RentalAmount {set; get;} //Yes	The value of the RentalAmount as a decimal
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_RentalAmount != null){
                attributes.put('RentalAmount', attb_RentalAmount );
            }
            Dom.XmlNode rentalIncome = createNode (parent, 'RentalIncome', null, attributes);
            if (period != null){
                period.parent = rentalIncome;
                rentalIncome.getChildElements().add(period.getNode());
            }
            return rentalIncome;
        }
    }
    
    public class Period extends XMLElement implements XmlElementInterface {
        public String attb_Unit {set; get;} //No	One of Weekly Fortnightly Monthly Yearly or OneOff
        public String attb_PreviousFinancialYear {set; get;} //No	One of Yes or No
        public String attb_MonthsInYear {set; get;} //No	The months in the year for the period as an integer
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_Unit != null){
                attributes.put('Unit', attb_Unit );
            }
            if (attb_PreviousFinancialYear != null){
                attributes.put('PreviousFinancialYear', attb_PreviousFinancialYear );
            }
            if (attb_MonthsInYear != null){
                attributes.put('MonthsInYear', attb_MonthsInYear );
            }
            return createNode (parent, 'Period', null, attributes);
        }
    }
    
    public class NonRealEstate extends XMLElement implements XmlElementInterface {
        
        public ExistMortgage existMortgage {set; get;} //No	See ExistMortgage element for more information
        public OtherAsset otherAsset {set; get;} //Yes	One of OtherAsset or DepositAccount elements
        public DepositAccount depositAccount {set; get;} //Yes	One of OtherAsset or DepositAccount elements
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode nonRealEstate = createNode (parent, 'NonRealEstate', null);
            if (otherAsset != null){
                otherAsset.parent = nonRealEstate;
                nonRealEstate.getChildElements().add(otherAsset.getNode());
            }
            if (depositAccount != null){
                depositAccount.parent = nonRealEstate;
                nonRealEstate.getChildElements().add(depositAccount.getNode());
            }
            if (existMortgage != null){
                existMortgage.parent = nonRealEstate;
                nonRealEstate.getChildElements().add(existMortgage.getNode());
            }
            return nonRealEstate;
        }
    }
    
    public class OtherAsset extends XMLElement implements XmlElementInterface {
        
        public String attb_OtherAssetType {set; get;} //Yes	One of the Other Asset Types defined below
        public MotorVehicle motorVehicle {set; get;} //No	Used to capture MotorVehicle details for MotorVehicle Asset Types
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_OtherAssetType != null){
                attributes.put('OtherAssetType', attb_OtherAssetType);
            }
            Dom.XmlNode otherAsset = createNode (parent, 'OtherAsset', null, attributes);
            if (motorVehicle != null){
                motorVehicle.parent = otherAsset;
                otherAsset.getChildElements().add(motorVehicle.getNode());
            }
            return otherAsset;
        }
        
    }
    
    public class MotorVehicle extends XMLElement implements XmlElementInterface {
        
        public String attb_BodyType {set; get;} //Yes	Specify the vehicle body type. wagon sedan etc.
        public String attb_EngineNumber  {set; get;} //No	Specify the vehicle engine number
        public String attb_Make  {set; get;} //Yes	Specify the make of vehicle. For example Peugeot
        public String attb_Model  {set; get;} //Yes	Specify the model of vehicle. For example 307
        public String attb_NVIC  {set; get;} //Yes	Mandatory for purchase vehicles
        public String attb_Odometer  {set; get;} //No	Specify Automatic or Manual
        public String attb_RegistrationNumber  {set; get;} //No	Specify the vehicle registration number
        public String attb_TransmissionType  {set; get;} //Yes	Mandatory for purchase vehicles. Specify Automatic or Manual
        public String attb_Used  {set; get;} //Yes	Mandatory for purchase vehicles. Specify Yes or No
        public String attb_VIN  {set; get;} //No	Specify the vehicle identification number
        public String attb_Year  {set; get;} //Yes	Specify the year of manufacter
        
        public Dom.XmlNode getNode(){
            MAp<String, String> attributes = new Map<String, String>();
            if (attb_BodyType != null){
                attributes.put ('BodyType',attb_BodyType);
            }
            if (attb_EngineNumber != null){
                attributes.put ('EngineNumber',attb_EngineNumber);
            }
            if (attb_Make != null){
                attributes.put ('Make',attb_Make);
            }
            if (attb_Model != null){
                attributes.put ('Model',attb_Model);
            }
            if (attb_NVIC != null){
                attributes.put ('NVIC',attb_NVIC);
            }
            if (attb_Odometer != null){
                attributes.put ('Odometer',attb_Odometer);
            }
            if (attb_RegistrationNumber != null){
                attributes.put ('RegistrationNumber',attb_RegistrationNumber);
            }
            if (attb_TransmissionType != null){
                attributes.put ('TransmissionType',attb_TransmissionType);
            }
            if (attb_Used != null){
                attributes.put ('Used',attb_Used);
            }
            if (attb_VIN != null){
                attributes.put ('VIN',attb_VIN);
            }
            if (attb_Year != null){
                attributes.put ('Year',attb_Year);
            }
            Dom.XmlNode motorVehicle = createNode (parent, 'MotorVehicle', null, attributes);
            return motorVehicle;
        }
    }
    
    public class DepositAccount extends XMLElement implements XmlElementInterface {
        
        public String attb_DepositAccountType {set; get;} //Yes	One of the Deposit Account Types defined below
        public String attb_Description {set; get;} //No	An optional text description of the deposit account
        
        public Dom.XmlNode getNode (){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_DepositAccountType != null){
                attributes.put('DepositAccountType', attb_DepositAccountType);
            }
            if (attb_Description != null){
                attributes.put('Description', attb_Description);
            }
            return createNode (parent, 'DepositAccount', null, attributes);
        }
    }
    
    public class RelatedPartySegment extends XMLElement implements XmlElementInterface {
        public List<RelatedParty>  relatedParties {set; get;}
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode relatedPartySegment = createNode(parent, 'RelatedPartySegment', null);
           	if (relatedParties != null){
                for (RelatedParty relatedParty : relatedParties){
                    if (relatedParty != null){
                        relatedParty.parent = relatedPartySegment;
                        relatedPartySegment.getChildElements().add(relatedParty.getNode());
                    }
                }
            }
            return relatedPartySegment;
        }
    }
    
    public class RelatedParty extends XMLElement implements XmlElementInterface {
        
        public Identifier identifier {set; get;} //Yes	A BrokerAssigned Identifier to uniqely identify the Related Party
        public Company company {set; get;} //No	A Company element providing information about the Related Part
        public CompanyName companyName {set; get;} //No	A CompanyName element providing information about the Related Party
        public PersonName personName {set; get;}  //No	A PersonName element providing information about the Related Party
        public Address address {set; get;} //Yes	The Related Party address or a RelatedEntityRef element reference to one
        public RelatedEntityRef relatedEntityRef {set; get;} //Yes	The Related Party address or a RelatedEntityRef element reference to one
        public WorkPhone workPhone {set; get;} //No	See WorkPhone element for more information
        public HomePhone homePhone {set; get;} //No	See HomePhone element for more information
        public Email email {set; get;} //No	See Email element for more information
        public String attb_RelPartyType {set; get;} //Yes	One of the Related Party Types defined below.
        
        public Dom.XmlNode getNode (){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_RelPartyType != null){
                attributes.put('RelPartyType', attb_RelPartyType);
            }
            Dom.XmlNode relatedParty = createNode (parent, 'RelatedParty', null, attributes);
            if (identifier != null){
                identifier.parent = relatedParty;
                relatedParty.getChildElements().add(identifier.getNode());
            }
            if (companyName != null){
                companyName.parent = relatedParty;
                relatedParty.getChildElements().add(companyName.getNode());
            }
            /**
            if (company != null){
                company.parent = relatedParty;
                relatedParty.getChildElements().add(company.getNode());
            }
**/
            if (personName != null){
                personName.parent = relatedParty;
                relatedParty.getChildElements().add(personName.getNode());
            }
            if (relatedEntityRef != null){
                relatedEntityRef.parent = relatedParty;
                relatedParty.getChildElements().add(relatedEntityRef.getNode());
            }
            if (address != null){
                address.parent = relatedParty;
                relatedParty.getChildElements().add(address.getNode());
            }
            if (workPhone != null){
                workPhone.parent = relatedParty;
                relatedParty.getChildElements().add(workPhone.getNode());
            }
            if (homePhone != null){
                homePhone.parent = relatedParty;
                relatedParty.getChildElements().add(homePhone.getNode());
            }
            if (email != null){
                email.parent = relatedParty;
                relatedParty.getChildElements().add(email.getNode());
            }
            return relatedParty;
        }
    }
    
    public class LoanDetailSegment extends XMLElement implements XmlElementInterface {
        
        public DocumentationInstructions documentationInstructions {set; get;} //No	See the DocumentationInstructions for more information
        public LoanDetails loanDetails {set; get;} //Yes	See the LoanDetails for more information
        public Representation representation {set; get;} //No	See the Representation for more information
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode loanDetailSegment = createNode(parent, 'LoanDetailSegment', null);
            if (documentationInstructions != null){
                documentationInstructions.parent = loanDetailSegment;
                loanDetailSegment.getChildElements().add(documentationInstructions.getNode());
            }
            if (loanDetails != null){
                loanDetails.parent = loanDetailSegment;
                loanDetailSegment.getChildElements().add(loanDetails.getNode());
            }
            if (representation != null){
                representation.parent = loanDetailSegment;
                loanDetailSegment.getChildElements().add(representation.getNode());
            }
            return loanDetailSegment;
        }
    }
    
    public class DocumentationInstructions extends XMLElement implements XmlElementInterface {
        
        public NominatedAuthority nominatedAuthority {set; get;} //Yes	See the NominatedAuthority for more information
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode documentationInstructions = createNode (parent , 'DocumentationInstructions', null);
            if (nominatedAuthority != null){
                nominatedAuthority.parent = documentationInstructions;
                documentationInstructions.getChildElements().add(nominatedAuthority.getNode());
            }
            return documentationInstructions;
        }
    }
    
    public class NominatedAuthority extends XMLElement implements XmlElementInterface {
        
        public RelatedEntityRef relatedEntityRef {set; get;} //Yes	A RelatedEntityRef reference
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode nominatedAuthority = createNode (parent, 'NominatedAuthority', null);
            if (relatedEntityRef != null){
                relatedEntityRef.parent = nominatedAuthority;
                nominatedAuthority.getChildElements().add(relatedEntityRef.getNode());
            }
            return nominatedAuthority;
        }
    }
    
    public class LoanDetails extends XMLElement implements XmlElementInterface {
        
        public Identifier identifier {set; get;} //Yes	A BrokerAssigned unique Identifier
        public LoanPurpose loanPurpose {set; get;} //Yes	See LoanPurpose for more information
        public LoanSplit loanSplit {set; get;} // Yes	See LoanSplit for more information
        public Security security {set; get;} //Yes	See Security for more information
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode loanDetails = createNode (parent, 'LoanDetails', null);
            if (identifier != null){
                identifier.parent = loanDetails;
                loanDetails.getChildElements().add(identifier.getNode());
            }
            if (security != null){
                security.parent = loanDetails;
                loanDetails.getChildElements().add(security.getNode());
            }
            if (loanPurpose != null){
                loanPurpose.parent = loanDetails;
                loanDetails.getChildElements().add(loanPurpose.getNode());
            }
            if (loanSplit != null){
                loanSplit.parent = loanDetails;
                loanDetails.getChildElements().add(loanSplit.getNode());
            }
            
            return loanDetails;
        }
    }
    
    public class LoanPurpose extends XMLElement implements XmlElementInterface {
        
        public LendingPurposeCode lendingPurposeCode {set; get;} //Yes	One or more LendingPurposeCode elements
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode loanPurpose = createNode (parent, 'LoanPurpose', null);
            if (lendingPurposeCode != null){
                lendingPurposeCode.parent = loanPurpose;
                loanPurpose.getChildElements().add(lendingPurposeCode.getNode());
            }
            return loanPurpose;
        }
    }
    
    public class LendingPurposeCode extends XMLElement implements XmlElementInterface {
        
        public VehiclePurpose vehiclePurpose {set; get;} //Yes	One of the VehiclePurpose or VehiclePurpose elements
        public InsurancePurpose insurancePurpose {set; get;} //Yes	One of the VehiclePurpose or VehiclePurpose elements
        public String attb_LoanPortion {set; get;} //Yes	Decimal number containing the Loan Portion
        public String attb_PurposeAmount {set; get;} //Yes	Decimal number containing the Purpose Amount
        public String attb_Description {set; get;} //No	An optional description
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_LoanPortion != null){
                attributes.put('LoanPortion', attb_LoanPortion);
            }
            if (attb_PurposeAmount != null){
                attributes.put('PurposeAmount', attb_PurposeAmount);
            }
            if (attb_Description != null){
                attributes.put('Description', attb_Description);
            }
            Dom.XmlNode lendingPurposeCode = createNode (parent, 'LendingPurposeCode', null, attributes);
            if (vehiclePurpose != null){
                vehiclePurpose.parent = lendingPurposeCode;
                lendingPurposeCode.getChildElements().add(vehiclePurpose.getNode());
            }
            if (insurancePurpose != null){
                insurancePurpose.parent = lendingPurposeCode;
                lendingPurposeCode.getChildElements().add(insurancePurpose.getNode());
            }
            return lendingPurposeCode;
        }
    }
    
    public class VehiclePurpose extends XMLElement implements XmlElementInterface {
        
        public VehicleTradeIn vehicleTradeIn {set; get;} //No	See VehicleTradeIn element for more information
        public String attb_CashDeposit  {set; get;} //No	A decimal number indicating the Cash Deposit amount
        public String attb_LenderFee {set; get;} //No	This value is fixed
        public String attb_ApplicationFee {set; get;} //No	Must be $1000 or less
        public String attb_ComprehensiveInsurance {set; get;} //No	A decimal number indicating the coverage amount
        public String attb_ExtendedWarranty {set; get;} //No	The extended warranty cover amount
        public String attb_FPAAmount {set; get;} //No	Optional. Librerty Motor Loan Flexible Payment Arrangement
        public String attb_ISPAmount {set; get;} //No	Optional. Insurance Shortfall Protection amount
        public String attb_OtherCost {set; get;} //No	A decimal number showing other costs
        public String attb_RateReduction {set; get;} //No	Optional. Introducer Commission Reduction as a decimal number
        public String attb_BalloonResidual {set; get;} //No	Optional. The balloon residual amount as a decimal number
        public String attb_GSTAmount {set; get;} //No	Optional. GST amount as a decimal number
        public String attb_PersonalUse {set; get;} //Yes	Specify Yes or No
        public String attb_RepaymentInArrears {set; get;} //No	Specify Yes or No. Defaults to No
        public String attb_LodgementFee {set; get;} //Yes	The Lodgement Fee as a decimal amount
        public String attb_VendorType {set; get;} //Yes	Either LMCT or Private
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_CashDeposit != null){
                attributes.put('CashDeposit', attb_CashDeposit);
            }
            if (attb_LenderFee != null){
                attributes.put('LenderFee', attb_LenderFee);
            }
            if (attb_ApplicationFee != null){
                attributes.put('ApplicationFee', attb_ApplicationFee);
            }
            if (attb_ComprehensiveInsurance != null){
                attributes.put('ComprehensiveInsurance', attb_ComprehensiveInsurance);
            }
            if (attb_ExtendedWarranty != null){
                attributes.put('ExtendedWarranty', attb_ExtendedWarranty);
            }
            if (attb_FPAAmount != null){
                attributes.put('FPAAmount', attb_FPAAmount);
            }
            if (attb_ISPAmount != null){
                attributes.put('ISPAmount', attb_ISPAmount);
            }
            if (attb_OtherCost != null){
                attributes.put('OtherCost', attb_OtherCost);
            }
            if (attb_RateReduction != null){
                attributes.put('RateReduction', attb_RateReduction);
            }
            if (attb_BalloonResidual != null){
                attributes.put('BalloonResidual', attb_BalloonResidual);
            }
            if (attb_GSTAmount != null){
                attributes.put('GSTAmount', attb_GSTAmount);
            }
            if (attb_PersonalUse != null){
                attributes.put('PersonalUse', attb_PersonalUse);
            }
            if (attb_RepaymentInArrears != null){
                attributes.put('RepaymentInArrears', attb_RepaymentInArrears);
            }
            if (attb_LodgementFee != null){
                attributes.put('LodgementFee', attb_LodgementFee);
            }
            if (attb_VendorType != null){
                attributes.put('VendorType', attb_VendorType);
            }
            Dom.XmlNode vehiclePurpose = createNode (parent, 'VehiclePurpose', null, attributes);
            if (vehicleTradeIn != null){
                vehicleTradeIn.parent = vehiclePurpose;
                vehiclePurpose.getChildElements().add(vehicleTradeIn.getNode());
            }
            return vehiclePurpose;
        }
    }
    
    public class VehicleTradeIn extends XMLElement implements XmlElementInterface {
        
        public Vehicle vehicle {set; get;} //No	Optional. Vehicle element for more information_
        public Loan loan {set; get;} //No	Optional. Loan element for more information_
        public String attb_TradeInAmount {set; get;} //Yes	The net trade in amount as a decimal number
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_TradeInAmount != null){
                attributes.put('TradeInAmount', attb_TradeInAmount);
            }
            Dom.XmlNode vehicleTradeIn = createNode (parent, 'VehicleTradeIn', null, attributes);
            if (vehicle != null){
                vehicle.parent = vehicleTradeIn;
                vehicleTradeIn.getChildElements().add(vehicle.getNode());
            }
            if (loan != null){
                loan.parent = vehicleTradeIn;
                vehicleTradeIn.getChildElements().add(loan.getNode());
            }
            return vehicleTradeIn;
        }
    }
    
    public class Vehicle extends XMLElement implements XmlElementInterface {
        
        public RelatedEntityRef relatedEntityRef {set; get;} //Yes	A RelatedEntityRef element to the associated Asset
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode vehicle = createNode (parent, 'Vehicle', null);
            if (relatedEntityRef != null){
                relatedEntityRef.parent = vehicle;
                vehicle.getChildElements().add(relatedEntityRef.getNode());
            }
            return vehicle;
        }
    }
    
    public class Loan extends XMLElement implements XmlElementInterface {
        
        public RelatedEntityRef relatedEntityRef {set; get;} //Yes	A RelatedEntityRef element to the associated Asset
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode loan = createNode (parent, 'Loan', null);
            if (relatedEntityRef != null){
                relatedEntityRef.parent = loan;
                loan.getChildElements().add(relatedEntityRef.getNode());
            }
            return loan;
        }
    }
    
    public class InsurancePurpose extends XMLElement implements XmlElementInterface {
        
        public PolicyHolder policyHolder {set; get;} //Yes	See PolicyHolder element for more information
        public LPI lpi {set; get;} //Yes	One of LPI or VEI elements
        public VEI vei {set; get;} //Yes	One of LPI or VEI elements
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode insurancePurpose = createNode (parent, 'InsurancePurpose', null);
            if (policyHolder != null){
                policyHolder.parent = insurancePurpose;
                insurancePurpose.getChildElements().add(policyHolder.getNode());
            }
            if (lpi != null){
                lpi.parent = insurancePurpose;
                insurancePurpose.getChildElements().add(lpi.getNode());
            }
            if (vei != null){
                vei.parent = insurancePurpose;
                insurancePurpose.getChildElements().add(vei.getNode());
            }
            return insurancePurpose;
        }
    }
    
    public class PolicyHolder extends XMLElement implements XmlElementInterface {
        
        public RelatedEntityRef relatedEntityRef {set; get;}
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode policyHolder = createNode (parent, 'PolicyHolder', null);
            if (relatedEntityRef != null){
                relatedEntityRef.parent = policyHolder;
                policyHolder.getChildElements().add(relatedEntityRef.getNode());
            }
            return policyHolder;
        }
    }
    
    public class LPI extends XMLElement implements XmlElementInterface {
        
        public String attb_CoverOption {set; get;} //Yes	One of the VEI Cover Options below
        public String attb_LoanAmount {set; get;} //Yes	The LPI Loan Amount as a decimal number
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_CoverOption != null){
                attributes.put('CoverOption', attb_CoverOption);
            }
            if (attb_LoanAmount != null){
                attributes.put('LoanAmount', attb_LoanAmount);
            }
            return createNode (parent, 'LPI', null, attributes);
        }
    }
    
    public class VEI extends XMLElement implements XmlElementInterface {
        public String attb_CoverOption {set; get;} //Yes	One of the VEI Cover Options below
        public String attb_LoanAmount {set; get;} //Yes	The LPI Loan Amount as a decimal number
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_CoverOption != null){
                attributes.put('CoverOption', attb_CoverOption);
            }
            if (attb_LoanAmount != null){
                attributes.put('LoanAmount', attb_LoanAmount);
            }
            return createNode (parent, 'VEI', null, attributes);
        }
    }
    
    public class LoanSplit extends XMLElement implements XmlElementInterface {
        
        public AmountRequested  amountRequested {set; get;} //Yes	See AmountRequested element for more information
        public List<LoanTerm> loanTerms {set; get;} //Yes	See LoanTerm element for more information
        public String attb_ProductCode {set; get;} //Yes	One of the Libery Product Codes defined below
        public string attb_ProductName {set; get;} //Yes	The matching Libery Product Names defined below
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_ProductCode != null){
                attributes.put('ProductCode', attb_ProductCode);
            }
            if (attb_ProductName != null){
                attributes.put('ProductName', attb_ProductName);
            }
            Dom.XmlNode loanSplit = createNode (parent, 'LoanSplit', null, attributes);
            if (amountRequested != null){
                amountRequested.parent = loanSplit;
                loanSplit.getChildElements().add(amountRequested.getNode());
            }
            if (loanTerms != null){
                for (LoanTerm loanTerm : loanTerms){
                    if (loanTerm != null){
                        loanTerm.parent = loanSplit;
                        loanSplit.getChildElements().add(loanTerm.getNode());
                    }
                }
            }
            
            return loanSplit;
        }
    }
    
    public class AmountRequested extends XMLElement implements XmlElementInterface {
        
        public String attb_Amount {set; get;} //Yes	A decimal number indicating the requested amount
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_Amount != null){
                attributes.put('Amount', attb_Amount);
            }
            return createNode (parent, 'AmountRequested', null, attributes);
        }
    }
    
    public class Security extends XMLElement implements XmlElementInterface {
        
        public RelatedEntityRef relatedEntityRef {set; get;} //Yes	A RelatedEntityRef element to the associated Asset
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode security = createNode (parent, 'Security', null);
            if (relatedEntityRef != null){
                relatedEntityRef.parent = security;
                security.getChildElements().add(relatedEntityRef.getNode());
            }
            return security;
        }
    }
    
    public class Representation extends XMLElement implements XmlElementInterface {
        
        public NominatedRepresentation nominatedRepresentation {set; get;} //Yes	See the NominatedRepresentation for more information
        public String attb_Self {set; get;} //? Specify Yes or No
        
        public Dom.XmlNode getNode(){
            Map<String, String> attributes = new Map<String, String>();
            if (attb_Self != null){
                attributes.put('Self', attb_Self);
            }
            Dom.XmlNode representation = createNode (parent , 'Representation', null, attributes);
            if (nominatedRepresentation != null){
                nominatedRepresentation.parent = representation;
                representation.getChildElements().add(nominatedRepresentation.getNode());
            }
            return representation;
        }
    }
    
    public class NominatedRepresentation extends XMLElement implements XmlElementInterface {
        
        public RelatedEntityRef relatedEntityRef {set; get;} //Yes	A RelatedEntityRef reference to a RelatedParty element
        
        public Dom.XmlNode getNode(){
            Dom.XmlNode nominatedRepresentation = createNode (parent, 'NominatedRepresentation', null);
            if (relatedEntityRef != null){
                relatedEntityRef.parent = nominatedRepresentation;
                nominatedRepresentation.getChildElements().add(relatedEntityRef.getNode());
            }
            return nominatedRepresentation;
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //--------------------------------------------------
    ////--------------------------------------------------
    ////--------------------------------------------------
    //
    /**
    public class Asset11 {
        public String attb_class {set; get;} //Yes Specify from CurrentAsset CurrentSecurity or FutureSecurity
        public NonRealEstate nonRealEstate {set; get;} //Yes	See the RealEstate and NonRealEstate elements for more information
        public RealEstate realEstate {set; get;} //Yes	See the RealEstate and NonRealEstate elements for more information
    }
    
    public class NonRealEstate {
        public OtherAsset otherAsset {set; get;} //Yes	One of OtherAsset or DepositAccount elements
        public DepositAccount depositAccount {set; get;}//Yes	One of OtherAsset or DepositAccount elements
        public ExistMortgage existMortgage {set; get;} //No	See ExistMortgage element for more information
    }
    
    public class OtherAsset {
        public String attb_otherAssetType {set; get;} //Shares-LifeInsurance-MotorVehicle-Superannuation-HomeContents-BusinessValue-StockAndMachinery
        public MotorVehicle motorVehicle {set; get;} //No	Used to capture MotorVehicle details for MotorVehicle Asset Types
    }
    
    public class MotorVehicle {
        public String bodyType {set; get;} //Yes	Specify the vehicle body type. wagon sedan etc.
        public String engineNumber {set; get;} //No	Specify the vehicle engine number
        public String make {set; get;} //Yes	Specify the make of vehicle. For example Peugeot
        public String model {set; get;} //Yes	Specify the model of vehicle. For example 307
        public String NVIC {set; get;} //Yes	Mandatory for purchase
        public String odometer {set; get;} //No	Specify Automatic or Manual
        public String registrationNumber {set; get;} //No	Specify the vehicle registration number
        public String transmissionType {set; get;} //Yes	Mandatory for purchase vehicles. Specify Automatic or Manual
        public String used {set; get;} //Yes	Mandatory for purchase vehicles. Specify Yes or No
        public String VIN {set; get;} //No	Specify the vehicle identification number
        public String year {set; get;} //Yes	Specify the year of manufacter
    }
    
    public class DepositAccount {
        public String attb_depositAccountType {set; get;} //Yes ChequeAccount-SavingsAccount-TermDeposit-InvestmentSavings-CashManagement-PensionAccount-OtherDepositAccount
        public String attb_description {set; get;} //No	An optional text description of the deposit account
    }
    
    public class ExistMortgage {
        public RelatedEntityRef relatedEntityRef {set; get;} //Yes	A RelatedEntityRef element to link this to a Liability defined elsewhere in the Request
    }
    
    
    
    public class RealEstate {
        public EstimatedValue estimatedValue  {set; get;} //Yes	See EstimatedValue element for more information
        public ExistMortgage existMortgage {set; get;} //No	See ExistMortgage element for more information
        public Location location {set; get;} //Yes See Location element for more information
    }
    
    public class EstimatedValue {
        public String attb_estimateBasis {set; get;} //No	ApplicantEstimate or CertifiedValuation 
    }
    
    public class Location {
        public String attb_titleType {set; get;} //No	One of the Title Types defined below
        //attb_titleType:BuildingUnitTitles- CommunityTitle-CompanyShare-CrownLease-OldLaw-Strata-Stratum-
        //TimeShare-Torrens-FeeSimple-Leasehold-UnitTitleLeasehold-UnitTitleFreehold-CrossLease
        
        public RelatedEntityRef relatedEntityRef {set; get;} //The Address or a RelatedEntityRef element reference
        public Address address {set; get;} //The Address or a RelatedEntityRef element reference
        public RentalIncome1 rentalIncome {set; get;} //No	See RentalIncome element for more information
    }
    
    public class RentalIncome1 {
        public String attb_rentalAmount  {set; get;} //Yes	The value of the RentalAmount as a decima
        public Period1 period {set; get;} //Yes	See Period element for more information
    }
    
    public class Period1 {
        public String attb_unit	{set; get;} //No	One of Weekly Fortnightly Monthly Yearly or OneOff
		public String attb_previousFinancialYear {set; get;} //No	One of Yes or No
		public String attb_monthsInYear	{set; get;} //No	The months in the year for the period as an integer
    }
    
    public class LibertyAddress {
        public Integer addressType {set; get;}
        public String state {set; get;}
        public String postcode {set; get;}
        public String country {set; get;}
        public String city {set; get;}
        public String streetType {set; get;}
        public String street {set; get;}
        public String unitNo {set; get;}
        public String streetNo {set; get;}
        public String sPOBoxType {set; get;}
        public String POBox {set; get;}
        public String nonStdAddress {set; get;}
        
    }
**/
}