pragma solidity ^0.8.0;

contract approvals{
    struct employee{
        uint id;
        bool isAdmin;
        bool isSuperAdmin;
        address empAddress;
    }
    enum status{pendingbyadmin, pendingbysuperadmin, acceptedbyadmin, acceptedbysuperadmin, rejectedbyadmin, rejectedbysuperadmin}
    
    struct document{
        string hash;
        status st;
        uint idOfApprover;
        uint timeAdminApproved;
        uint timeSuperAdminApproved;
    }
    
    mapping(uint => employee) emps;
    mapping(string => document) docs;
    
    event adminApproved(string _hash, uint _empId, uint timeAdminApproved);
    event adminRejected(string _hash, uint _empId, uint timeAdminRejected);
    event superAdminApproved(string _hash, uint _empId, uint timeSuperAdminApproved);
    event superAdminRejected(string _hash, uint _empId, uint timeSuperAdminRejected);
    
    function addAdmin(uint _id) public {
        emps[_id].isAdmin = true;
    }
    
    function addSuperAdmin(uint _id) public {
        emps[_id].isSuperAdmin = true;
    }
    
    function removeAdmin(uint _id) public {
        emps[_id].isAdmin = false;
    }
    
    function removeSuperAdmin(uint _id) public {
        emps[_id].isSuperAdmin = false;
    }
    
    function approvedByAdmin(string memory _hash, uint _empId, bool ifAcceptedByAdmin) public{
        require(emps[_empId].isAdmin == true, "Approver is not an admin");
        if(ifAcceptedByAdmin){
            docs[_hash].st = status.acceptedbyadmin;
            docs[_hash].timeAdminApproved = block.timestamp;
            emit adminApproved(_hash, _empId, block.timestamp);
            
        }
        else{
            docs[_hash].st = status.rejectedbyadmin;
            emit adminRejected(_hash,_empId, block.timestamp);
        }
    }
    
    function approvedBySuperAdmin(string memory _hash, uint _empId, bool ifAcceptedBySuperAdmin) public{
        require(emps[_empId].isSuperAdmin == true, "Approver is not an suoer admin");
        if(ifAcceptedBySuperAdmin){
            docs[_hash].st = status.acceptedbysuperadmin;
            docs[_hash].timeSuperAdminApproved = block.timestamp;
            emit superAdminApproved(_hash, _empId, block.timestamp);
        }
        else{
            docs[_hash].st = status.rejectedbysuperadmin;
            emit superAdminRejected(_hash, _empId, block.timestamp);
        }
    }
    
    function getApprovals(string memory _hash, uint _empId, bool ifAccepted) public {
        
        approvedByAdmin(_hash, _empId, ifAccepted);
        approvedBySuperAdmin(_hash, _empId, ifAccepted);
        
    }
    
}