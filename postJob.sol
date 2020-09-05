pragma solidity >=0.4.22 <0.7.0;
contract MyToken{
    function getMinter() public view returns(address) {}
    function approve(address a,uint amount) public{}
    function transferFrom(address send,address reciever, uint amount) public{}
    function balanceOf(address ad) public view returns (uint){}
}

contract company{
function getCompany(address a) public view returns(string memory){}

}
contract Employee{
   function getCompanyId(address referee) public view returns(address){}
   function onSelection(address selectedCan,address companyId,string memory Company,string memory rolename,uint salary) public {}
}

contract projectPost {
    address CompanyAddress;
    address TokenAddress;
    address EmployeeAddress;
    address minter ;
    uint no_of_posts;
     MyToken TokenObj;
     company CompanyObj;
     Employee EmployeeObject;
     address owner;
   
    struct post{
        uint postId;
        uint no_of_available_posts;
        string roleName;
        uint Salary;
        string companyName;
        address companyId;
        string qualificationRequired;
	mapping(address => address[]) referers;
        bool Status;
    } post cur_post;
    
mapping(uint => post) public postAll;
   uint[] public allAvailableposts;
    
  constructor(address Tokenadd,address Companyadd,address Employeeadd) public{
   
   no_of_posts=0;
   instantiateContractMyToken( Tokenadd);
   instantiateCompany(Companyadd);
   instantiateEmployee(Employeeadd);
   minter=callMinter();
  }
 
  function instantiateContractMyToken(address Tokenobj) public{
TokenAddress=Tokenobj;  
TokenObj=MyToken(TokenAddress);
    }  
    function instantiateCompany(address Companyadd) public{
  CompanyAddress=Companyadd;
  CompanyObj=company(CompanyAddress);
    }  
    function instantiateEmployee(address Empobj) public{
EmployeeAddress=Empobj;  
EmployeeObject=Employee(EmployeeAddress);
    }
   
    function callMinter() public view returns(address){
       return TokenObj.getMinter();
    }
    struct postsOfCompany{
        address companyAddress;
        uint[] postsofthiscompany;
    }
mapping(address=>postsOfCompany) public allPostsOfCompany;
    
function postJob(string memory RoleName,uint salary,string memory qualificationRequired,uint number_of_available_posts) public payable{
        owner=msg.sender;
        string memory Company_name=CompanyObj.getCompany(msg.sender);
        uint cur_posts_no=no_of_posts+1;
        setPostId(cur_posts_no);
        setPostName(RoleName);
        setCompany(Company_name);
        setCompanyId(msg.sender);
        setSalary(salary);
        setAvailablePosts(number_of_available_posts);
        setRequiredQualification(qualificationRequired);
       setStatus(false);
        uint totalAmount=TokenObj.balanceOf(owner);
        require(totalAmount>=(number_of_available_posts*100),"No enough balance to post a project");
       
       
postAll[cur_post.postId]=cur_post;
TokenObj.approve(owner,number_of_available_posts*100);
TokenObj.transferFrom(msg.sender,minter,number_of_available_posts*100);
 allAvailableposts.push(cur_posts_no);
 allPostsOfCompany[msg.sender].companyAddress=msg.sender;
 allPostsOfCompany[msg.sender].postsofthiscompany.push(cur_posts_no);
no_of_posts+=1;
    } 
    function getAllpostsofthisCompany(address company_address) public view returns(uint[] memory){
        return allPostsOfCompany[company_address].postsofthiscompany;
        
    }
    function setPostId(uint postId) private{
        cur_post.postId=postId;
    }
  
  function setPostName(string memory name) private{
        cur_post.roleName=name;
    }
    function setStatus(bool status) private{
        cur_post.Status=status;
    }
    function setSalary(uint salary) private{
        cur_post.Salary=salary;
    }
    function setAvailablePosts(uint AvailablePosts) private{
        cur_post.no_of_available_posts=AvailablePosts;
    }
     function setCompany(string memory company_name) public{
         cur_post.companyName=company_name;
     }
     function setCompanyId(address companyadd) public{
         cur_post.companyId=companyadd;
     }
     function setRequiredQualification (string memory qualification) private{
         cur_post.qualificationRequired=qualification;
     }
     function addAReferer(address referer,address referee,uint id) public {
         require(postAll[id].no_of_available_posts!=0,"Post either doesn't exists or filled");
         address req_id=getCompanyIdByPostId(id);
         require(EmployeeObject.getCompanyId(referer)== req_id,"You should be an Employee of that company");
         postAll[id].referers[referer].push(referee);
     }
  function current_postId() public view returns(uint)  {
      return  cur_post.postId;
    }
  function  getRoleName() public view returns(string memory){
       return cur_post.roleName;
    }
    function getNoOfAvailablePosts() public view returns(uint){
    return   cur_post.no_of_available_posts;
    }
  function getotalPosts() public view returns(uint){
      return no_of_posts;
  }
  function getStatus() public view returns(bool){
      return cur_post.Status;
  }
   function  getRoleNameById(uint id) public view returns(string memory){
       require(postAll[id].no_of_available_posts!=0,"Post either doesn't exists or filled");
       return postAll[id].roleName;
    }
     function getNoOfAvailablePostsById(uint id) public view returns(uint){
         require(postAll[id].no_of_available_posts!=0,"Post either doesn't exists or filled");
    return postAll[id].no_of_available_posts;
    }
    function getStatusById(uint id) public view returns(bool){
        require(postAll[id].no_of_available_posts!=0,"Post either doesn't exists or filled");
      return postAll[id].Status;
  }
  
function getReferredPerson(uint postId,address selectedCan) public view returns (address[] memory){
    return postAll[postId].referers[selectedCan];
}
    function getSalary(uint postId) public view returns (uint){
        return postAll[postId].Salary;
        
    }
    function getCompany(uint postId) public view returns(string memory){
        return postAll[postId].companyName;
    } 
function getCompanyIdByPostId(uint postId) public view returns(address){
return postAll[postId].companyId;    }
    function createDummyPosts(uint postId,string memory roleName,uint Salary,string memory companyName,string memory qualificationRequired,bool Status,uint no_of_available_posts)public{
    postAll[postId].postId=postId;
    postAll[postId].roleName=roleName;
    postAll[postId].Salary=Salary;
    postAll[postId].companyName=companyName;
    postAll[postId].qualificationRequired=qualificationRequired;
    postAll[postId].Status=Status;
    postAll[postId].no_of_available_posts=no_of_available_posts;
}

function onCandidateSelect(address CandidateId,uint postId) public payable{
    address[] memory arr=getReferredPerson(postId,CandidateId);
    uint totalReferers=arr.length;
    require(postAll[postId].no_of_available_posts>0,"No posts left to select candidate");
    postAll[postId].no_of_available_posts=postAll[postId].no_of_available_posts-1;
   EmployeeObject.onSelection(CandidateId,msg.sender,CompanyObj.getCompany(msg.sender),getRoleNameById(postId),getSalary(postId));
    if(postAll[postId].no_of_available_posts==0){
       for (uint i=0;i<allAvailableposts.length;i++){
           if(allAvailableposts[i]==postId){
postAll[postId].Status=true;
break;
           }
       }
    }
    uint insAmount=20;
    for(uint i=0;i<totalReferers;i++){
        TokenObj.transferFrom(minter,arr[i],insAmount);
    }
}
}
