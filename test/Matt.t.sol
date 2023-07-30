pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../src/Matt.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor(address to, uint256 amount) ERC20("MockERC20", "M20") {
        _mint(to, amount);
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

contract MattTest is Test {
    Matt matt;
    MockERC20 auctionCurrency;
    address[] buyers;
    uint256 price;

    function setUp() public {
        auctionCurrency = new MockERC20(address(this), 10000);
        matt = new Matt(address(auctionCurrency), "https://example.com/", "SimpleNFT", "SNFT");
        buyers = [address(1), address(2)]; 
        price = 100;

        for (uint256 i = 0; i < buyers.length; i++) {
            auctionCurrency.mint(buyers[i], price + 100);
            
            // Prank to set the sender to the buyer's address
            vm.prank(buyers[i]);
            require(auctionCurrency.approve(address(matt), price + 100), "Approval failed");
        }
        
        // Resetting the sender after the loop
        vm.prank(address(0));
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

    function testFail_InsufficientAllowanceRevertsMint() public {
        // Reduce the allowance for the first buyer to less than the price
        vm.prank(buyers[0]);
        require(auctionCurrency.approve(address(matt), price - 1), "Approval failed");

        // Attempting to mint should now fail
        matt.mint(price, buyers);
    }

}
