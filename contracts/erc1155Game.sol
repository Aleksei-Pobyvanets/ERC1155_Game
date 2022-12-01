// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ERC1155Game is ERC1155, Ownable, Pausable, ERC1155Supply {
    uint public pyblicPrice = 0.01 ether;
    uint public maxSupply = 10;


    constructor() ERC1155("") {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint( uint256 id, uint256 amount, bytes memory data)
        public
        payable
    {
        require(id < 3, "Wrong ID!");
        require(msg.value == pyblicPrice * amount, "insufficient funds!");
        require(totalSupply(id) + amount <= maxSupply, "Sorry we have ninted out!");
        _mint(msg.sender, id, amount, data);
    }

    function uri(uint _id)public view virtual override returns(string memory){
        require(exists(_id), "URI: nonexisten token!");

        return string(abi.encodePacked(super.uri(_id), Strings.toString(_id), ".json"));
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    function withdraw(address _addr) external onlyOwner{
        uint balance = address(this).balance;
        payable(_addr).transfer(balance);
    }
}
