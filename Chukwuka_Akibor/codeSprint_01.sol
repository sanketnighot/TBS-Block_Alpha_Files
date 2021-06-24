// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.0;

// Define a contract 'Land Transfer'
contract PropertyTransfer {
    
    // Variable: Owner: who deployed the contract
    address ownerOfContract;
    
    // Variable: Land Identification Unit (propertyId) count
    uint propertyIdCount;
    
    // Event: 'State' with value 'ForSale'
    // enum State { ForSale, Sold };
    
   // Struct: Land. geographic_address, propertyId, price, state, seller, buyer
    struct Property {
        uint  propertyId;
        string  geographicAddress;
        // uint  price;
        // State  state;
        address  currOwner;
        address[]  prevOwner;
    }
     

    // Define a public mapping 'properties' that maps the properties (a number) to a Property.
    mapping (uint => Property) public properties;
    // mapping (uint => address[]) public prevOwner;
    
    // Events
    
    // Modifier: Only Owner see if msg.sender == owner of the contract
    modifier onlyOwner(uint _propertyId) {
        require(msg.sender == properties[_propertyId].currOwner);
        _;
    }
    
    // Initializing the User Contract: can only be called once
    constructor() public {
        ownerOfContract = msg.sender;
        propertyIdCount = 0;
    }
      // no previous owner so we create an empty array to store owners
    // create a new property
    function createProperty(uint _propertyId, string memory _geographicAddress, address _currOwner) public returns (bool) {
        propertyIdCount++;
        address[] memory prevOwner;
        properties[_propertyId] = Property(_propertyId, _geographicAddress, _currOwner, prevOwner);
        return true;
    }
      
    // change of ownership without using modifiers
    function changeOwnership(uint _propertyId, address _newOwner) public returns (bool) {
        
        require(properties[_propertyId].currOwner == msg.sender, "You are not the owner, Owner required for change!!");
        require(properties[_propertyId].currOwner != _newOwner);
        properties[_propertyId].prevOwner.push(properties[_propertyId].currOwner);
        properties[_propertyId].currOwner = _newOwner;
        return true;
    }
    
    // get prooperty details
    function getOwners(uint _propertyId) public view returns (string memory geographicAddress, address currOwner) {
        return (properties[_propertyId].geographicAddress, properties[_propertyId].currOwner);
    }
    
    function getPreviousOwners(uint _propertyId) public view returns (address[] memory) {
        return (properties[_propertyId].prevOwner);
    }
}