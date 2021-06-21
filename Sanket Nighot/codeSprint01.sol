// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract propertyManagement {
    
    
    address public contractCreator;     // Address of the contract creator
    uint propertyId;    // This will keep count of total properties and will give them unique id
    
    // Struct to create a property
    struct Property {
        uint propertyId;
        address owner;
        string propertyAddress;
    }
    
    
    mapping (uint => Property) public properites;           // This will help to map the struct of properties with property id
    mapping (uint => address[]) public previousOwners;      // This will help to map the array of previous owners with property id
    
    // This will run when contract gets deployed and store the address of contract creator
    constructor() {
        propertyId = 0;
        contractCreator = msg.sender;
    }
    
    // This will ensure that only the current owner can access the function wherever it will be used
    modifier propertyOwner(uint _id) {
        require(properites[_id].owner == msg.sender, "Only owner can transfer ownership");
        _;
    }
    
    function addProperty(string memory _propertyAddress) public returns(uint){
        propertyId++;       // Increment the counter
        properites[propertyId] = Property(propertyId, msg.sender, _propertyAddress);    // add property to the mapping
        previousOwners[propertyId] = [msg.sender];      // add array containing previous owners of property
        return propertyId;      // returns property id so user on frontend will get the id of property he created
    }
    
    function changeOwner(uint _id, address _owner) public propertyOwner(_id) {  //  propertyOwner will ensure to execute modifier
        require(properites[_id].owner != _owner, "No change in owner");         // owner with his own address will not be able to transfer the property to himself
        properites[_id].owner = _owner;     // change the owner of the property
        previousOwners[_id].push(_owner);   // add new owner to the array containing previous owners of property
    }
    
    function getProperty(uint _id) public view returns(Property memory property) {
        return properites[_id];     // returns the property details of the id in the parameters
    }
    
    function getPropertyOwners(uint _id) public view returns(address[] memory) {
        return previousOwners[_id];     // returns array of the previous owners of the property of id in the parameters
    }
    
    
}
