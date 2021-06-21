// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract practiceSprint {
    address payable public contractCreator;
    uint public bidId;
    constructor()  {
        contractCreator = payable(msg.sender);
        bidId = 0;
    }
    
    struct Object {
        uint id;
        string name;
        address payable owner;
        address payable highestBidder;
        uint highestBid;
        bool auctionStatus;
    }
    
    mapping(uint => Object) public Objects;
    mapping(uint => mapping(address => uint)) BidAmount;
    
    
    modifier checkHighestBidAndStatus(uint _id) {
        require(Objects[_id].highestBid <= msg.value, "Bid higher amount then the highest bidder");
        require(Objects[_id].auctionStatus == true, "The Auction is closed now");
        _;
    }
    
    modifier onlyObjectOwner(uint _id) {
        require(Objects[_id].owner == msg.sender);
        _;
    }
    
    event objectCreated(uint objectId, string objectName, address owner);
    event bidUpdated(uint objectId, uint highestBid, address highestBidder);
    event auctionEnded(uint objectId, uint finalPrice, address newOwner);
    
    function createObject(string memory _name, uint _initialAmount) public payable returns(uint _bidId){
        require(msg.value == _initialAmount);
        bidId++;
        Objects[bidId] = Object(bidId, _name, payable(msg.sender), payable(msg.sender), _initialAmount, true);
        emit objectCreated(bidId, _name, msg.sender);
        return bidId;
    }
    
    function bidObject(uint _id) public checkHighestBidAndStatus(_id) payable {
        if (Objects[_id].owner != Objects[_id].highestBidder) {
            (Objects[_id].highestBidder).transfer(Objects[_id].highestBid);
        }
        Objects[_id].highestBidder = payable(msg.sender);
        Objects[_id].highestBid = msg.value;
        contractCreator.transfer(msg.value);
        emit bidUpdated(_id, Objects[_id].highestBid, msg.sender);
    }
    
    function endAuction(uint _id) onlyObjectOwner(_id) public {
        (payable(msg.sender)).transfer(Objects[_id].highestBid);
        Objects[_id].owner = Objects[_id].highestBidder;
        Objects[_id].auctionStatus = false;
        emit auctionEnded(_id, Objects[_id].highestBid, Objects[_id].highestBidder);
    }
    
}
