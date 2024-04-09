/**
* The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
* It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
*
* This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
* a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
* records, and manage data volume using the LIMIT keyword.
* 
* Topics covered in this class include:
* - Understanding the structure of a SOQL query.
* - Crafting basic SELECT statements in SOQL.
* - Applying filters using the WHERE clause in SOQL.
* - Fetching related records using Relationship queries.
* - Controlling the amount of data retrieved using the LIMIT keyword.
* 
* Users of this class can expect to gain a solid understanding of SOQL in Apex and
* be prepared to handle data retrieval tasks in Salesforce development.
* 
* @author Sean Williams
*/

public with sharing class SOQL {
    
    /**
     * Question 1
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
       public static List<Lead> getLeads() {
     List<Lead> leadsList = [SELECT Id, LastName, Company, Phone, Email FROM Lead WITH SECURITY_ENFORCED];
     return leadsList;
    }

    /**
     * Question 2
     *Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */
    public static List<Contact> getContactFirstName() {
    List<Contact> contactsList = [SELECT Id, Name FROM Contact WHERE FirstName = 'John' WITH SECURITY_ENFORCED];
    return contactsList;
    }

    /**
     * Question 3
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
    
        public static List<Id> retrieveContactIds(String lastName1, String lastName2) {
            
           List<Id> contactIds = new List<Id>();
            List<Contact> gatherContacts = [SELECT Id FROM Contact WHERE LastName = :LastName1 OR LastName = :LastName2 WITH SECURITY_ENFORCED];
            for(Contact conId: gatherContacts){
                contactIds.add(conId.Id);
            }
            return contactIds;
    
    }


    /**
     * Question 4
     * Update/Uncomment the template code to create a method 
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
            public static List<Opportunity> retrieveOpportunityFields(Id accountId) {
                Opportunity[] opportunityQuery = [SELECT Name, StageName, Amount, Type, CloseDate, Opportunity.AccountId FROM Opportunity WHERE StageName = 'Closed Won' AND AccountId = :accountId WITH SECURITY_ENFORCED];
                    return opportunityQuery;
   }

    /**
     * Question 5
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
     */
    public static Integer accountCount() {
    Integer accCount = [SELECT count() FROM Account WITH SECURITY_ENFORCED];
    return accCount;
    }

    /**
     * Question 6
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map<Id, Task> taskRetrieval() {
    Map<Id, Task> taskMap = new Map<Id,Task>([SELECT ID, Subject, ActivityDate FROM Task WHERE ActivityDate = NEXT_N_DAYS:7 WITH SECURITY_ENFORCED]);
    return taskMap;
    }

    /**
     * Question 7
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
            public static List<Contact> contactEmailRetrieval(String emailSegment) {
                Contact[] contEmails = [SELECT Name, Email, Id FROM Contact WHERE Email LIKE :emailSegment WITH SECURITY_ENFORCED ];
                return contEmails;
    }

    /**
     * Question 8
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
        keyword = keyword + '%';
        String dynamicOppQuery = 'SELECT Name, StageName, Amount, Type, CloseDate, Opportunity.AccountId FROM Opportunity WHERE Name LIKE :keyword WITH SECURITY_ENFORCED';
        List<Opportunity> oppKeywords = Database.query(dynamicOppQuery);
        return oppKeywords; // Replace null with the variable you used to store the result
    }

    /**
     * Question 9
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List<Case> getFilterCaseOrigins() {
        
        Case[] caseList = [SELECT CaseNumber, Origin, Status FROM Case WHERE NOT (Origin IN ('Web', 'Email', null)) WITH SECURITY_ENFORCED ];
        return caseList; // Replace null with the variable you used to store the result
    }

    /**
     * Question 10
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
        public static List<Lead> leadRetrieval(String leadSource, String keyword) {
            keyword = '%'+keyword+'%';
            Lead[] leadList = [SELECT LastName, Phone, Company, Email, Title, Status FROM Lead WHERE LeadSource = :leadSource OR Title LIKE :keyword WITH SECURITY_ENFORCED ];
            return leadList;
        }
    /**
     * Question 11
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) {
        // Create a list to hold the Contact LastNames
        List<String> contLastNames = new List<String>();
        // Query the Contacts
        Contact[] contQuery = [SELECT LastName, Id, Email, AccountId FROM Contact WHERE AccountId = :accountId WITH SECURITY_ENFORCED];
        // Loop through each Contact and add the LastName to the list
        for (Contact cont : ContQuery) {
           contLastNames.add(cont.LastName);
        }

        // Return the list of Contact LastNames
        return contLastNames; // Replace null with the variable you used to store the result
    }

    /**
     * Question 12
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for all Opportunities in the 'Closed Won' Stage.
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) {
        // Use AggregateQuery to get the total revenue
        AggregateResult[] oppRevQuery = [SELECT SUM(Amount)amtSum FROM Opportunity WHERE StageName = :stage OR Amount > 10000 WITH SECURITY_ENFORCED];
        Decimal oppRev = (Decimal) oppRevQuery[0].get('amtSum');
        // Return the total revenue
        return oppRev; // Replace null with the variable you used to store the result
    }

    /**
     * Question 13
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() {
        List<Account> accList = [SELECT Name FROM Account WITH SECURITY_ENFORCED ORDER BY Name LIMIT 10];
        return accList; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 14
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() {
        Opportunity[] oppQuery = [SELECT Name, Amount, CloseDate FROM Opportunity WHERE Amount > 100000 WITH SECURITY_ENFORCED ORDER BY CloseDate LIMIT 5];
        return oppQuery; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 15
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() {
        Contact[] contBirthday = [SELECT Name, BirthDate FROM Contact WHERE BirthDate <= TODAY OR BirthDate >= TODAY WITH SECURITY_ENFORCED  ORDER BY BirthDate DESC LIMIT 3];
        return contBirthday; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 16
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus() {
        Case[] openCase = [SELECT Status,  Type, CreatedDate FROM Case WHERE Status = 'Open' WITH SECURITY_ENFORCED ORDER BY CreatedDate ASC LIMIT 10 OFFSET 5 ];
        return openCase; // Replace null with the variable you used to store the result
    }

    /**
     * Question 17
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) {
        // Create a set to hold the Case Ids
        Set<Id> caseId = new Set<Id>();
        // Query the Cases
        Case[] caseQuery = [SELECT Id FROM Case WHERE AccountId = :accountID WITH SECURITY_ENFORCED];
        // Loop through each Case and add the Id to the set
        for (Case cases : caseQuery) {
            caseId.add(cases.Id);
        }

        return caseId; // Replace null with the variable you used to store the result
    }

    /**
     * Question 18
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
        // Create a map to hold the Account Ids to Account Names
        Map<Id, String> accountIdsToNames = new Map<Id, String>();

        // Query the Accounts
        Account[] mapAcc = [SELECT ID, Name FROM Account WHERE NOT (BillingCountry IN (:country)) WITH SECURITY_ENFORCED ];
        // Loop through each Account and add the Id and Name to the map
        for(Account acc : mapAcc){
            accountIdsToNames.put(acc.Id, acc.Name);
        }
        return accountIdsToNames; // Replace null with the variable you used to store the result
    }

    /**
     * Question 19
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) {
        List<Contact> contAccName = [SELECT Account.Name FROM Contact WHERE Id = :contactId WITH SECURITY_ENFORCED];
        String accNAme = string.valueOf(contAccName[0].Account.Name);
        return accName; // Replace null with the variable you used to store the result
    }    

    /**
     * Question 20
     * Returns single Account that has related opportunities in the same query
     * Example: getOpportunityAndAccountNamesForLineItem('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */
    public static Account getOpportunityAndAccountNamesForLineItem(Id accountId) {
        List<Account> accountOppList = [SELECT Name, (SELECT ID, Name, StageName, CloseDate FROM Opportunities) FROM Account WHERE Id = :accountId WITH SECURITY_ENFORCED];
        Account accountRetrieval = accountOppList.get(0);
        return accountRetrieval; // Replace null with the variable you used to store the result
    }

    /**
     * Question 21
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) {
        // Query the Account
        Account[] accBillingStateQuery = [SELECT BillingState FROM Account WHERE Id = :accountId WITH SECURITY_ENFORCED];
        // Store the Account's BillingState
        String accBillingState = accBillingStateQuery[0].BillingState;
        // Query the Contacts
        Contact[] contMailingStateQuery = [SELECT ID, MailingState FROM Contact WHERE MailingState = :accBillingState WITH SECURITY_ENFORCED];
    
        return contMailingStateQuery; // Replace null with the variable you used to store the result
    }

    /**
     * Question 22
     * Extracts email domains from them leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findContactsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param A set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    public static List<Account> findContactsByLeadEmailDomains(Set<Id> leadIds) {
        // Query the Leads
        Lead[] leadQuery = [SELECT Email FROM Lead WHERE Id = :leadIds WITH SECURITY_ENFORCED];
        
        // Create a set of email domains from the Leads
        Set<String> leadDomains = new Set<String>();
        // Loop through each Lead
        // Get the email from the Lead
        // Check if the email is not null
        // Add the email domain to the set
            for(Lead leads:leadQuery){
                if(leads.Email != null){
                    //Integer index = leads.email.indexOf('@');
                    String leadEmailDomain = leads.Email.substring(leads.Email.indexOf('@')+ 1);
                    String leadDomLike = '%'+leadEmailDomain+'%';
                    leadDomains.add(leadDomLike);  
                }
                
            }
            
        
        // Query the Accounts
        Account[] accQuery = [SELECT ID, Name, Website FROM Account WHERE Website LIKE :leadDomains WITH SECURITY_ENFORCED];
        return accQuery; // Replace null with the variable you used to store the result
    }

    /**
     * Question 23
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
        // Query the original Opportunity Line Items
            List<OpportunityLineItem> opps = [SELECT Id, Quantity, OpportunityId, PriceBookEntryId, Name, UnitPrice FROM OpportunityLineItem WHERE OpportunityId = :origOppId WITH SECURITY_ENFORCED];
        // Create a list to hold the new line items
        List<OpportunityLineItem> newOpps = new List<OpportunityLineItem>();
        // Generate a random number between 1 and 3
        Integer randomNumber = (Integer) Math.roundToLong(Math.random()*2)+1;
        // Loop through each cloned Opportunity Id
        for(Id clonedOpp:cloneOppIds) {
            // Loop through each original line item
            for(OpportunityLineItem oppLineItem: opps){
                OpportunityLineItem cloneOppItem = oppLineItem.clone(false,true,false,false);
                cloneOppItem.Quantity = oppLineItem.Quantity + randomNumber;
                cloneOppItem.OpportunityId = clonedOpp;
                newOpps.Add(cloneOppItem);
            }
                // Clone the original line item and add the random number to the quantity

        // Insert the new line items
    }
    insert newOpps;
}
    
    /**
     * Question 24
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * Example: getOpportunityDetailsForClosedWon()
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() { 
        Opportunity[] oppDetailList = [SELECT Name, Account.Name, OwnerId FROM Opportunity WHERE StageName = 'Closed Won' WITH SECURITY_ENFORCED];       
        return oppDetailList; // Replace null with the variable you used to store the result
    }

    /**
     * Question 25
     * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to first Contact on the Account.
     * Example: setPrimaryContact() should set the 'Primary_Contact__c' field for every Opportunity in the org
     */
    public static void setPrimaryContact() {
        //Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
        List<Opportunity> oppList = getOpportunityDetailsForClosedWon();
        // Create a set of Account Ids from the Opportunities
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opp: oppList){
            accountIds.add(opp.AccountId);
        }
        // Query the Contacts
            Contact[] contactList = [SELECT Name, AccountId, Phone, Email FROM Contact WITH SECURITY_ENFORCED];
            Map<Id,Contact> contactMap = new Map<Id,Contact>();
        // Loop through each Contact and add the Account Id and Contact to the map
        for(Contact conts: contactList){
            contactMap.put(conts.AccountId, conts);
        }
        // Loop through each Opportunity
            for(Opportunity opps: oppList){
                opps.Primary_Contact__c = contactMap.get(opps.AccountId).Id;
            }
                // Update the Opportunity primary contact from accountToContactMap
            update oppList;
        // Update the Opportunities
    }
}