// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract codeSprint01 {
    
    address public contractCreator;
    constructor() {
        contractCreator = msg.sender;
        ticketNumber = 0;
    }
    
    // Employee Struct
    struct Employee{
        address employee;
        uint id;
        designation empDesignation;
    }
    
    // Enum to set document
    enum action{PENDING, ACCEPTED, REJECTED}
    enum designation {EMPLOYEE, ADMIN, SUPERADMIN}
    
    // Document ticket number and Struct
    uint ticketNumber;
    struct Document{
        uint docTicket;
        string hash;
        uint empId;
        uint assignId;
        action adminAction;
        action superAdminAction;
        uint adminActionTime;
        uint superAdminActionTime;
    }
    
    // Mapping to store Employees and Documents
    mapping (uint => Employee) public Employees;
    mapping (uint => Document) public Documents;
    
    // Modifiers to distribute access across different users
    modifier onlyAdmin(uint _id) {
        require(Employees[_id].empDesignation == designation.ADMIN, "Only Admins can access the function");
        _;
    }
    modifier onlySuperAdmin(uint _id) {
        require(Employees[_id].empDesignation == designation.SUPERADMIN, "Only Super Admins can access the function");
        _;
    }
    modifier checkUser(uint _id) {
        require(Employees[_id].employee == msg.sender, "Incorrect Employee Id");
        _;
    }
    modifier onlyContractCreator() {
        require(msg.sender == contractCreator, "This address does not have acceess to this function");
        _;
    }
    
    
    // Events to record logs of all events in the contract 
    event documentCreated(uint creatorId,uint assignedId, string docHash, uint timestamp);
    event documentAction(uint actionBy, uint ticketId, string DocHash, action actionTaken, uint timestamp);
    
    // Function to create Employees and Documents
    function createEmployee(uint _id) public {
        Employees[_id] = Employee(msg.sender, _id, designation.EMPLOYEE);
    }
    function createDocument(uint _id, string memory _hash) checkUser(_id) public {
        ticketNumber++;
        Documents[ticketNumber] = Document(ticketNumber, _hash, _id, 0, action.PENDING, action.PENDING, block.timestamp, block.timestamp);
        emit documentCreated(_id, 0, _hash, block.timestamp);
    }
    function createDocument(uint _id, uint _assignId, string memory _hash) checkUser(_id) public {
        ticketNumber++;
        Documents[ticketNumber] = Document(ticketNumber, _hash, _id, _assignId, action.PENDING, action.PENDING, block.timestamp, block.timestamp);
        emit documentCreated(_id, _assignId, _hash, block.timestamp);
    }
    
    // Function to handle Admin's and Super Admin's actions on documents
    function adminAction(uint _id, uint _ticketId, bool isApproved) checkUser(_id) onlyAdmin(_id) public {
        require((Documents[_ticketId].assignId == _id) || (Documents[_ticketId].assignId == 0), "This user can't take action on this document");
        if(isApproved) {
            Documents[_ticketId].adminAction = action.ACCEPTED; 
            Documents[_ticketId].adminActionTime = block.timestamp;
            emit documentAction(_id, _ticketId, Documents[_ticketId].hash, action.ACCEPTED, block.timestamp);
        } else {
            Documents[_ticketId].adminAction = action.REJECTED;
            Documents[_ticketId].adminActionTime = block.timestamp;
            emit documentAction(_id, _ticketId, Documents[_ticketId].hash, action.REJECTED, block.timestamp);
        }
    }
    function superAdminAction(uint _id, uint _ticketId, bool isApproved) checkUser(_id) onlySuperAdmin(_id) public {
        require(Documents[_ticketId].adminAction == action.ACCEPTED, "Admin has not approved the document yet");
        require((Documents[_ticketId].assignId == _id) || (Documents[_ticketId].assignId == 0), "This user can't take action on this document");
        if(isApproved) {
            Documents[_ticketId].superAdminAction = action.ACCEPTED; 
            Documents[_ticketId].superAdminActionTime = block.timestamp;
            emit documentAction(_id, _ticketId, Documents[_ticketId].hash, action.ACCEPTED, block.timestamp);
        } else {
            Documents[_ticketId].superAdminAction = action.REJECTED;
            Documents[_ticketId].superAdminActionTime = block.timestamp;
            emit documentAction(_id, _ticketId, Documents[_ticketId].hash, action.REJECTED, block.timestamp);
        }
    }
    
    // Assigning and Revoking Admin and Super Admin roles
    function addAdmin(uint _id) public onlyContractCreator{
        Employees[_id].empDesignation = designation.ADMIN;
    }
    function addSuperAdmin(uint _id) public onlyContractCreator{
        Employees[_id].empDesignation = designation.SUPERADMIN;
    }
    function removeAdmin(uint _id) public onlyContractCreator{
        Employees[_id].empDesignation = designation.EMPLOYEE;
    }
    function removeSuperAdmin(uint _id) public onlyContractCreator{
        Employees[_id].empDesignation = designation.EMPLOYEE;
    }

}
