// SPDX-License-Identifier: MIT
pragma solidity 0.8.20; // Do not change the solidity version as it negatively impacts submission grading

import "./FundingRecipient.sol";

contract CrowdFund {
    /////////////////
    /// Errors //////
    /////////////////

    error NotOpenToWithdraw();
    error WithdrawTransferFailed(address to, uint256 amount);
    error TooEarly(uint256 deadline, uint256 currentTimestamp);

    //////////////////////
    /// State Variables //
    //////////////////////

    FundingRecipient public fundingRecipient;
    mapping(address => uint256) public balances;
    bool public openToWithdraw = false; //no withdraw till timeline reached
    uint256 public constant threshold = 1 ether;
    uint256 public deadline = block.timestamp + 2 hours; // will be executed when contract executes

    ////////////////
    /// Events /////
    ////////////////

    event Contribution(address, uint256);

    ///////////////////
    /// Modifiers /////
    ///////////////////

    modifier notCompleted() {
        _;
    }

    ///////////////////
    /// Constructor ///
    ///////////////////

    constructor(address fundingRecipientAddress) {
        fundingRecipient = FundingRecipient(fundingRecipientAddress);
    }

    ///////////////////
    /// Functions /////
    ///////////////////

    function contribute() public payable {
        balances[msg.sender] += msg.value;
        emit Contribution(msg.sender, msg.value);
    }

    function withdraw() public {
        if (!openToWithdraw) {
            revert NotOpenToWithdraw();
        }

        uint256 moneymoneymoney = balances[msg.sender];

        balances[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: moneymoneymoney}("");

        if (!success)
            revert WithdrawTransferFailed(msg.sender, moneymoneymoney);
    }

    function execute() public {
        uint tl = timeLeft();
        if (tl != 0) revert TooEarly(deadline, tl);
        if (address(this).balance >= threshold) {
            fundingRecipient.complete{value: address(this).balance}();
        } else {
            openToWithdraw = true;
        }
    }

    receive() external payable {
        contribute();
    }

    ////////////////////////
    /// View Functions /////
    ////////////////////////

    function timeLeft() public view returns (uint256) {
        if (block.timestamp >= deadline) return 0;
        return deadline - block.timestamp;
    }
}
