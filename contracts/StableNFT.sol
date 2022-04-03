//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract StableNFT is ERC721, Ownable {
    
    string _baseURI;
    IERC20 cUSD;
    uint256 cost;

    constructor(address _cUSD, uint256 _cost) ERC712("STABLEMINT", "STM") {
        cUSD = IERC20(_cUSD);
        cost = _cost;
    }

    // public functions
    function mint(uint256 amount) {
        uint256 allowance = cUSD.allowance(msg.sender, address(this));
        uint256 balance = cUSD.balanceOf(msg.sender);
        uint totalCost = amount * cost;
        require(allowance >= totalCost && balance >= cost, "You have correct amount of cUSD");

        for (uint256 i = 0; i < amount; i++) {
            uint256 totalSupply = totalSupply();
            _mint(msg.sender, totalSupply + 1);
        }
    }

    // owner functions

    function setBaseURI (string calldata _uri) public onlyOwner {
        _baseURI = _uri;   
    }

    //internal functions

    function _baseURI() internal override returns(string) {
        return _baseURI;
    }
}
