// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8; 

/// @notice a smart contract to vest the tokens of founders for a period of time before they can withdraw
contract Vesting{


    struct Founder {
        uint256 amount;
        uint256 maturity;
        bool paid; //true or false if founder has been paid or not
    }
    //@notice things we have to save
    mapping(address => Founder) public founders;
    address public admin;

     // event Transfer(address indexed from, address indexed to, uint256 value);
     // event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(){
        admin = msg.sender;
    }

    /// @notice add new founder
    function addFounder(address _founder, uint256 _timeToMaturity) external payable{
        require(msg.sender == admin, 'only admin allowed'); //check if spender is admin
        require(founders[_founder].amount == 0, 'founder already exists'); // check if founder already exists

        founders[_founder] = Founder(msg.value, block.timestamp + _timeToMaturity, false);

    }

    function withdraw() external returns (bool) {
        Founder storage founder = founders[msg.sender];
        require(founder.maturity <= block.timestamp, 'too early'); //the date for withdrawal must have passed
        require(founder.amount > 0, 'only admin can withdraw' );
        require(founder.paid == false, 'paid already');
        founder.paid = true;
        payable(msg.sender).transfer(founder.amount);
        return true;
    }

}
