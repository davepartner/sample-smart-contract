// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8;

contract Vesting{

    struct Founder {
        uint256 amount;
        uint256 maturity;
        bool paid; //true or false if founder has been paid or not
    }
    //@notice things we have to save
    mapping(address => Founder) public founders;
    address public admin;
    uint256 public transactionValue;

    event addFounderEvent(address _founderEvent, uint256 _timeToMaturityEvent, string _messageEvent);

    constructor() payable{
        admin = msg.sender;
        transactionValue = msg.value;
    }

    /// @notice add new founder
    /// @param _founder: address of the founder to be added
    /// @param _timeToMaturity : integer of time
    function addFounder(address _founder, uint256 _timeToMaturity) external payable{
        require(_founder == admin, 'only admin allowed'); //check if spender is admin
        require(founders[_founder].amount == 0, 'founder already exists'); // check if founder already exists

        founders[_founder] = Founder(transactionValue, block.timestamp + _timeToMaturity, false);

        emit addFounderEvent(_founder, transactionValue, 'addFounder event message');
    }

    /// @notice withdrawal function
    function withdraw() external payable{
        Founder storage founder = founders[msg.sender];
        require(founder.maturity <= block.timestamp, 'too early'); //the date for withdrawal must have passed
        require(founder.amount > 0, 'only admin can withdraw' );
        require(founder.paid == false, 'paid already');
        founder.paid = true;
        payable(msg.sender).transfer(founder.amount);

        emit addFounderEvent(msg.sender, founder.amount, 'withdrawal event message');
    }

}
