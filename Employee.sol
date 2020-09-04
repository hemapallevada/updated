pragma solidity >=0.4.22 <0.7.0;
//import 'MyToken.sol';
contract MyToken{
    function minter() public view returns(address) {}
    function approve(address a,uint amount) public{}
    function balanceOf(address add) public view returns(uint){}
    function transferFrom(address send,address reciever, uint amount) public{}
}
contract company{
    function isCompany(address companyAdd) public view returns(bool){}
    function getAddressByName(string memory name) public view returns(address ){}
    function CompanyWithName(string memory name) public view returns(bool){}
}
contract Employee{
    company companyObj;
    MyToken tokenObject;
    constructor(address add,address addressCom) public{
     instantiateMyToken(add);
     instantiateCompany(addressCom);
     
     }
struct profileEach{
string name;
address Personaddress;
address CompanyId;
string role;
uint Salary;
string Company;
bool CompanyVerified;
string[][] educationQualifications;
}
mapping(address=>profileEach) profile;
function createProfile(string memory name,string memory role,uint salary,string memory Company_name)  public{
    address personaddress=msg.sender;
    require(!isRegisteredUser(personaddress),"You are already registered");
    setName(name,personaddress);
    setRole(personaddress,role);
    setSalary(personaddress,salary);
    
    setCompany(personaddress,Company_name);
    if(companyObj.CompanyWithName(Company_name)){
   address CompanyId=companyObj.getAddressByName(Company_name);
   setCanCompanyId(CompanyId,personaddress);
    }
   
    setCompanyVerified(personaddress,false);
   
}
function isEmployee(address employeeId) public view returns(bool){
    if(profile[employeeId].CompanyId==0x0000000000000000000000000000000000000000){
        return false;
    }
    return true;
}
function isRegisteredUser(address employeeId) public view returns(bool){
    if(bytes(profile[employeeId].name).length==0)
    return false;
    return true;
}
function verifyAsCompany(address CompanyAdd,address employeeAddress) public{
    require(companyObj.isCompany(CompanyAdd),"You need be registered as a company to verify");
    require(getCompanyId(employeeAddress)==CompanyAdd,"You can verify only your company Employees");
    setCompanyVerified(employeeAddress,true);
    
}

function verifyCompanyOfEmployee(address add,address verifier) public {
    require(profile[add].CompanyId==profile[verifier].CompanyId,"You must be Employee of that company to verify");
    require(profile[verifier].CompanyVerified,"You need to be Verified first to verify others");
    setCompanyVerified(add,true);
}

function instantiateMyToken(address tokenobj) public{
 
tokenObject=MyToken(tokenobj);
    } 
    function instantiateCompany(address addCompany) public{
        companyObj=company(addCompany);
    }
function setName(string memory name,address add) private{
    profile[add].name=name;
}
function setCompanyVerified(address add, bool status) private{
    profile[add].CompanyVerified=status;
}
function setCanCompanyId(address CompanyId,address add) private{
    profile[add].CompanyId=CompanyId;
}
function setRole(address add,string memory RoleName) private{
    profile[add].role=RoleName;
}
function setCompany(address add,string memory CompanyName) public{
    profile[add].Company=CompanyName;
}
function setSalary(address add,uint salary) private{
    profile[add].Salary=salary;
}

function getName(address add) public view returns(string memory){
    return profile[add].name;
}
function getCompanyId(address add) public view returns (address CompanyId){
   return profile[add].CompanyId;
}
function getRole(address add) public view returns (string memory){
    return profile[add].role;
}
function getCompany(address add) public view returns(string memory ){
    return profile[add].Company;
}
function getSalary(address add) public view returns(uint){
    return profile[add].Salary;
}
function getCompanyVerified(address add)  public view returns(bool){
    
    return profile[add].CompanyVerified;
}
function onJobVerified(address CandidateId) public{
    setCompanyVerified(CandidateId,true);
}


struct aboutPostsandLogin{
   uint lastlogin;
   uint totalposts;
   uint conCoins;
}
function onSignUp(address UserId) payable public{
    //require(!isRegisteredUser(UserId),"You are already registered");
    tokenObject.approve(tokenObject.minter(),20);
    tokenObject.approve(UserId,20);
    tokenObject.transferFrom(tokenObject.minter(),UserId,20);
   
    PostsandLogin[UserId].lastlogin=now;
    PostsandLogin[UserId].totalposts=0;
    PostsandLogin[UserId].conCoins=0;
}

function onDocumentUpload() public{
    //Yet to implement
}
function getBalance (address ass) public view returns(uint){
    return tokenObject.balanceOf(ass);
}
mapping(address=>aboutPostsandLogin) PostsandLogin;

function onLogin(address userId) public{
  uint  x=now;
  address minteradd=tokenObject.minter();
    if(x-PostsandLogin[userId].lastlogin>86400 && x-PostsandLogin[userId].lastlogin<=172800){
        if(PostsandLogin[userId].conCoins<35){
            tokenObject.approve(tokenObject.minter(),35);
            tokenObject.approve(userId,35);
            tokenObject.transferFrom(minteradd,userId,PostsandLogin[userId].conCoins+5);
            PostsandLogin[userId].conCoins+=5;
        }
        else if(x-PostsandLogin[userId].lastlogin>86400){
            tokenObject.approve(tokenObject.minter(),5);
            tokenObject.approve(userId,5);
             tokenObject.transferFrom(minteradd,userId,5);
             PostsandLogin[userId].conCoins=5;
        }
    }
    PostsandLogin[userId].lastlogin=x;
}

function onAnyPost(address userId) public{
    PostsandLogin[userId].totalposts+=1;
    require(PostsandLogin[userId].totalposts<20,"Sorry!, We cannot credit tokens Since you have uploaded 20 posts:)");
    tokenObject.approve(tokenObject.minter(),5);
    tokenObject.approve(userId,5);
    tokenObject.transferFrom(tokenObject.minter(),userId,5);
}
function onSelection(address selectedCan,address companyId,string memory Company,string memory rolename,uint salary) public {
setCanCompanyId(companyId,selectedCan);
setCompany(selectedCan,Company);
setRole(selectedCan,rolename);
setSalary(selectedCan,salary);
}
function createDummyProfiles(string memory name,address personaddress,address CompanyId,string memory role,uint salary,string memory Company,bool verifiedStatus) public{
    setName(name,personaddress);
    setRole(personaddress,role);
    setSalary(personaddress,salary);
    setCompany(personaddress,Company);
   setCanCompanyId(CompanyId,personaddress);
    setCompanyVerified(personaddress,verifiedStatus);
}
function getProfile_Name(address candidateId) public view returns(string memory){
    return profile[candidateId].name;
}
function getProfile_Company(address candidateId) public view returns(string memory){
    return profile[candidateId].Company;
}

function getProfile_Salary(address candidateId) public view returns(uint){
    return profile[candidateId].Salary;
}
}
