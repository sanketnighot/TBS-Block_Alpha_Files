pragma solidity ^0.8.0;

contract landOwnershipContract {
    
    struct Property{
        address[] ownerAddresses;
        uint propertyID;
        string propertyAddress;
    }
    
    mapping(uint => Property) public properties;
    
    function upload(uint _propertyID, string memory _propertyAddress) public{
        properties[_propertyID].ownerAddresses.push(msg.sender);
        properties[_propertyID].propertyID = _propertyID;
        properties[_propertyID].propertyAddress = _propertyAddress;
    }
    
    function changeOwner(address _newOwnerAddr, uint _propertyID) public {
        uint ownersLength = properties[_propertyID].ownerAddresses.length;
        require(properties[_propertyID].ownerAddresses[ownersLength-1] == msg.sender, "You are not the owner.");
        require(properties[_propertyID].ownerAddresses[ownersLength-1] != _newOwnerAddr, "New owner is same as old owner.");
        properties[_propertyID].ownerAddresses.push(_newOwnerAddr);
    }
    
   function getPropDetails(uint _propertyID) view public returns(address[] memory, uint, string memory){
        return (properties[_propertyID].ownerAddresses, properties[_propertyID].propertyID, properties[_propertyID].propertyAddress);
    }
    
    function getAllOwners(uint _propertyID) public view returns(address[] memory){
        return properties[_propertyID].ownerAddresses;
    }
    
}