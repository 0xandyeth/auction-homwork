//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./Auction.sol";

contract AuctionFactory {
   // address[] public auctionAddresses;  // auctionAddresses will be declared in private than public
    address[] private auctionAddresses;
    address public admin;
   
   // declare the paymentToken
    IERC20 paymentToken;
    event AuctionCreated(
        address indexed _auctionAddress,
        address indexed _client
    );

    constructor(address _admin,address _token) {
        require(_admin != address(0),"The admin is not zero address."); // check if the admin adddress is zero.
        require(_token != address(0),"The token is not zero address."); //check if the token address is zero.
        admin = _admin;
        paymentToken = IERC20(_token);
    }

    function createAuction(
        IERC20 _paymentToken,
        uint256 _minPrice,
        int32 _noOfCopies,
        address _client,
        address _admin,
        uint256 _fixedPrice,
        uint256 _biddingTime, // unit s;
        AuctionType _type
    ) external onlyAdmin returns (address) {

        // checking the all parameters correctly in here.
       require(address(_paymentToken) == address(paymentToken),"The token is not correct payment currency.");
       require(_minPrice > 0, "The min price can't be less than zero."); 
       require(_noOfCopies >0,"The value can't be less than zero.");
       require(_client != address(0),"The client is not zero address");
       require(_admin != address(0),"The admin is not zero address");
       require(_fixedPrice > 0,"The value can't be less than zero.");
       require(_biddingTime >= block.timestamp,"The bidding time is not correct.");
       
        Auction auction = new Auction(
            _paymentToken,
            _minPrice,
            _noOfCopies,
            _client,
            _admin,
            _fixedPrice,
            _biddingTime,
            _type
        );

        auctionAddresses.push(address(auction));
        emit AuctionCreated(address(auction), _client);
        return address(auction);
    }

    function getAuctions() external view returns (address[] memory) {
        return auctionAddresses;
    }

    // Modifiers
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can create");
        _;
    }
}