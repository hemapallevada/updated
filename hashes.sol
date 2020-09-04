pragma solidity ^0.6;
contract hashes{
    struct hash{
        address hashaddress;
        string hash;
        bool verified;
    }
    mapping(string=>hash) public allHashes;
    string[]  public availablehashes;
    
    function addAHash(string memory _hash) public{
        availablehashes.push(_hash);
        allHashes[_hash]=hash(msg.sender,_hash,false);
        
    }  
    
     function getallHashesLength() public view returns (uint){
        return availablehashes.length;
    }
    function verified(string memory _hash) public{
        require(msg.sender==0xFe4Ae9EE6ff6ef78d895B2ca3F971dCa47e693A5 || msg.sender==0xfe63Cae2841EE6C2b3BF05A2EeCF1aB619C88cfc,"Sorry you ar not verifier");
        allHashes[_hash].verified=true;
    }
}
