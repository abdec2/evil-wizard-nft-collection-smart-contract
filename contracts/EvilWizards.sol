// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EvilWizards is ERC721, ERC721Enumerable, Pausable, Ownable {

    using Strings for uint256;

    string public baseExtension = ".json";
    uint256 public cost = 0.2 ether;
    uint256 public maxSupply = 400;
    bool public revealed = false;
    bool private startSale = false;
    string public notRevealedUri = "https://nfinit-digital-management.mypinata.cloud/ipfs/QmRb3pWcWrBbwyPH8FcHirhyShau5SN42YXifhryySxX2y";

    constructor() ERC721("Evill Wizards", "EWZ") {}


    fallback() external payable { }
    receive() external payable { }

    function _baseURI() internal pure override returns (string memory) {
        return "https://gateway.pinata.cloud/ipfs/QmYQ45oJ8TVibA3esZbr2AxKBEGf2dwGmHQcwuGsupfhZW";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}