// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Food Secure
 * @dev A blockchain-based platform for tracking and funding food security initiatives.
 */
contract Project {
    address public owner;

    struct Donation {
        address donor;
        uint256 amount;
        uint256 timestamp;
    }

    struct FoodDistribution {
        string location;
        uint256 foodQuantity; // e.g., in kilograms
        uint256 timestamp;
    }

    Donation[] public donations;
    FoodDistribution[] public distributions;

    uint256 public totalFunds;

    event Donated(address indexed donor, uint256 amount);
    event FoodDistributed(string location, uint256 foodQuantity);

    constructor() {
        owner = msg.sender;
    }

    /// @notice Allows users to donate funds to support food security
    function donate() external payable {
        require(msg.value > 0, "Donation must be greater than zero");

        donations.push(Donation(msg.sender, msg.value, block.timestamp));
        totalFunds += msg.value;

        emit Donated(msg.sender, msg.value);
    }

    /// @notice Records a food distribution event (only owner)
    function recordDistribution(string calldata _location, uint256 _foodQuantity) external onlyOwner {
        require(_foodQuantity > 0, "Quantity must be greater than zero");

        distributions.push(FoodDistribution(_location, _foodQuantity, block.timestamp));
        emit FoodDistributed(_location, _foodQuantity);
    }

    /// @notice Withdraw funds (only owner)
    function withdraw(uint256 amount) external onlyOwner {
        require(amount <= totalFunds, "Insufficient funds");
        totalFunds -= amount;
        payable(owner).transfer(amount);
    }

    /// @dev Modifier restricting access to contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }
}
