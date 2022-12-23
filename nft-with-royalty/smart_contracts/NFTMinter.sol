// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import './MyNFT.sol';

contract NFTMinter {

    address public owner;
    uint256 public basePrice;
    address public MyNFTContractAddress;

    // modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        basePrice = 1000000000000000; // this is 0.001 CELO
    }

    // function to add or update nft smart contract address
    function updateMyNFTContractAddress(address _address) public onlyOwner {
        MyNFTContractAddress = _address;
    }

    // function that calls the mint function. Anyone can call this function.
    function mintNft(address _toAddress, string memory _uri) public payable {
        
        if(msg.sender != owner) {
            require(msg.value >= basePrice, "Not enought ETH sent");

            (bool sent, bytes memory data) = owner.call{value: msg.value}("");
            require(sent, "Failed to send CELO");
        }

        MyNFT my_nft = MyNFT(MyNFTContractAddress);
        my_nft.mintNFTWithRoyalty(_toAddress, _uri, owner, 2500);
    }
}

