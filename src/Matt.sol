// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Matt is ERC721Enumerable, Ownable {
    using SafeERC20 for IERC20;

    IERC20 public AUCTION_CURRENCY;
    bool private minted;
    string private baseTokenURI;

    constructor(
        address auctionCurrencyAddress,
        string memory _baseTokenURI,
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) {
        AUCTION_CURRENCY = IERC20(auctionCurrencyAddress);
        minted = false;
        baseTokenURI = _baseTokenURI;
    }

    function setBaseTokenURI(string calldata _baseTokenURI) external onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    function mint(uint256 price, address[] calldata buyers) external onlyOwner {
        require(!minted, "Minting already done");
        minted = true;

        for (uint256 i = 0; i < buyers.length; i++) {
            address buyer = buyers[i];

            // Perform ERC20 transfer for the price
            AUCTION_CURRENCY.safeTransferFrom(buyer, address(this), price);

            // Issue the NFT to the buyer
            uint256 tokenId = totalSupply() + 1;
            _mint(buyer, tokenId);
        }
    }

    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }
}
