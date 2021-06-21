pragma solidity ^0.8.0;

contract auction{
    
    struct bid{
        address bidder;
        uint amount;
    }
    
    mapping(address => bid) bids;
    uint prevHighestAmount;
    address prevHighestBidder;
    address highestBidder;
    uint highestAmount;
    uint startTime;
    uint endTime;
    address payable beneficiaryAddress;
    mapping(address => uint) highestBidderBalance;
    
    constructor(address payable _beneficiaryAddress) {
        startTime = 1623900930;
        endTime = 1623910000;
        beneficiaryAddress = _beneficiaryAddress;
    }
    
    modifier bidBetween(){
        require(block.timestamp >= startTime && block.timestamp <= endTime, "You tried to bid before/after bidding period");
        _;
    }
    
    function makeBid(uint _bidamount) public bidBetween{
        bids[msg.sender] = bid(msg.sender, _bidamount);
        if(_bidamount > highestAmount){
            prevHighestAmount = highestAmount;
            highestAmount = _bidamount;
            prevHighestBidder = highestBidder;
            highestBidder = msg.sender;
            //if statement to avoid same bidder withdrawing bid after submittinh highest bid
            if(msg.sender != prevHighestBidder){
                _withdrawBid(prevHighestAmount, prevHighestBidder);
            }
        }
    }
    
    function _withdrawBid(uint _refAmount, address _refAddress) private bidBetween{
        bids[_refAddress].amount -= _refAmount;
    }
    
    function endAuction() public payable{
        //manually call the function with highest bid amount after looking up bids mapping
        beneficiaryAddress.transfer(msg.value);
        highestBidderBalance[highestBidder]++;
        
    }
    
    function getHighestBidder() public view returns(address, uint){
        return (highestBidder, highestAmount);
    }
    
    function getAccountDetails(address _addr) public view returns (address, uint) {
        return (bids[_addr].bidder, bids[_addr].amount);
    }
    
    function getHighestBidderBal() public view returns(address, uint){
        return (highestBidder, highestBidderBalance[highestBidder]);
    }
    
}