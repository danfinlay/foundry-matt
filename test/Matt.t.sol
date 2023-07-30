pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../src/Matt.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MattTest is Test {
    Matt matt;
    IERC20 auctionCurrency;
    address[] buyers;
    uint256 price;

    function setUp() public {
        auctionCurrency = IERC20(address(this)); // You can replace with a proper mock ERC20
        matt = new Matt(address(auctionCurrency), "https://example.com/", "SimpleNFT", "SNFT");
        buyers = [address(1), address(2)]; // Replace with actual buyer addresses
        price = 100;

        // Assume the contract has enough balance of the auction currency
    }

    function test_TransfersAmountFromEachBuyer() public {
        uint256 initialBalance1 = auctionCurrency.balanceOf(buyers[0]);
        uint256 initialBalance2 = auctionCurrency.balanceOf(buyers[1]);

        matt.mint(price, buyers);

        assertEq(auctionCurrency.balanceOf(buyers[0]), initialBalance1 - price);
        assertEq(auctionCurrency.balanceOf(buyers[1]), initialBalance2 - price);
    }

    function test_MintsNFTToEachBuyer() public {
        matt.mint(price, buyers);

        assertEq(matt.ownerOf(1), buyers[0]);
        assertEq(matt.ownerOf(2), buyers[1]);
    }
}
