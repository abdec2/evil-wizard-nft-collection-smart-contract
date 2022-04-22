// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EvilWizards is ERC721, ERC721Enumerable, Pausable, Ownable {
    using Strings for uint256;

    string public baseURI =
        "https://gateway.pinata.cloud/ipfs/QmYQ45oJ8TVibA3esZbr2AxKBEGf2dwGmHQcwuGsupfhZW";
    string public baseExtension = ".json";
    uint256 public cost = 0.1 ether;
    uint256 public maxSupply = 400;
    bool public revealed = false;
    bool private startSale = false;
    string public notRevealedUri =
        "ipfs://QmVxBAqrJoTxYWmTEX4jaQJ8ESANjZLTvN3i4z4aqRwbYb";

    constructor() ERC721("Evil Wizards", "EWZ") {}

    fallback() external payable {}

    receive() external payable {}

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory _baseuri) external onlyOwner {
        baseURI = _baseuri;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        if (!revealed) {
            return notRevealedUri;
        }

        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        tokenId.toString(),
                        baseExtension
                    )
                )
                : "";
    }

    function reveal() public onlyOwner {
        revealed = true;
    }

    function setRevealed() external onlyOwner {
        revealed = !revealed;
    }

    function setNFTPrice(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    function getNFTPrice() external view returns(uint256) {
        return cost;
    }

    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }

    function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
        baseExtension = _newBaseExtension;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function withdraw() external onlyOwner whenNotPaused returns(uint256){
        uint balance = address(this).balance;
        require(balance > 0, "NFT: No ether left to withdraw");

        (bool success, ) = payable(owner()).call{ value: balance } ("");
        require(success, "NFT: Transfer failed.");
        return balance;
    }

    function lastTokenID() external view returns(uint256) {
        return totalSupply();
    }

    function contractBalance() external view returns(uint256) {
        return address(this).balance;
    }

    function mint(address _to, uint256 _mintAmount) public payable whenNotPaused {
      uint256 supply = totalSupply();
      require(_mintAmount > 0);
      require(supply + _mintAmount <= maxSupply);
      if (msg.sender != owner()) {
        require(msg.value >= cost * _mintAmount);
      }

      for (uint256 i = 1; i <= _mintAmount; i++) {
        _safeMint(_to, supply + i);
      }
    }

    function walletOfOwner(address _owner)
      public
      view
      returns (uint256[] memory)
    {
      uint256 ownerTokenCount = balanceOf(_owner);
      uint256[] memory tokenIds = new uint256[](ownerTokenCount);
      for (uint256 i; i < ownerTokenCount; i++) {
        tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
      }
      return tokenIds;
    }

    function _maxSupply() external view returns(uint256) {
        return maxSupply;
    }

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }

}
