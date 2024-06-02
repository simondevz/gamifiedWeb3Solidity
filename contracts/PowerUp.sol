// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract PowerUpNFT is ERC721 {

    // CEO Address set to the deployer.
    address CEO;

    // Base URI for token URI
    string private baseURI;

    // Mapping of power up NFT IDs to their corresponding metadata
    mapping(uint256 => powerUpNFT) public powerUpNFTs;

    // Mapping of player addresses to their power up NFT IDs
    mapping(address => uint256[]) public playerPowerUpNFTs;

    // Event triggered when a power up NFT is minted
    event powerUpNFTMinted(uint256 indexed tokenId, address indexed player, uint256 indexed expirationDate); // uint256 indexed tokenId, uint256 powerUpId, uint256 expiration

    // Event triggered when a power up NFT is traded
    event powerUpNFTTraded(uint256 indexed powerUpNFTId, address indexed from, address indexed to);

    // Event triggered when a power up NFT's expiration is extended
    event powerUpNFTExpirationExtended(uint256 indexed powerUpNFTId, uint256 newExpiration);

    // Struct to store power up NFT metadata
    struct powerUpNFT {
        uint256 id;
        address owner;
        uint256 expiration; // timestamp in seconds
    }

    // For power up NFT IDs
    uint256 public powerUpNFTIdCounter;

    constructor(string memory _name, string memory _symbol, string memory _baseURL) ERC721(_name, _symbol) {
        baseURI = _baseURL;
        CEO = msg.sender;
        powerUpNFTIdCounter = 0;
    }

    // modifier to check that the caller is the CEO
    modifier onlyCEO() {
        require(msg.sender == CEO, "Only the CEO is allowed to change the baseURI");
        _;
    }

    // Modifier to check if the caller is the owner of the power up NFT
    modifier onlyOwner(uint256 _powerUpNFTId) {
        require(powerUpNFTs[_powerUpNFTId].owner == msg.sender, "Only the owner can perform this action");
        _;
    }

    function _baseURI() internal view override returns (string memory) { return baseURI;}

    // Function to update the base url can only be called by the CEO
    function updateBaseURL(string memory _baseURL) external onlyCEO { baseURI = _baseURL;}

    // Function to get a power up NFT's metadata
    function getpowerUpNFTMetadata(uint256 _powerUpNFTId) public view returns (powerUpNFT memory) {
        return powerUpNFTs[_powerUpNFTId];
    }

    // Function to get a player's power up NFTs
    function getPlayerpowerUpNFTs(address _player) public view returns (uint256[] memory) {
        return playerPowerUpNFTs[_player];
    }

    function mintNFT(uint256 expiration) public {
        powerUpNFTIdCounter += 1;
        uint256 newTokenId = powerUpNFTIdCounter;
        _safeMint(msg.sender, newTokenId);
        powerUpNFTs[newTokenId] = powerUpNFT(newTokenId, msg.sender, expiration);
        emit powerUpNFTMinted(newTokenId, msg.sender, expiration);
    }

    function extendExpiration(uint256 tokenId, uint256 newExpiration) public {
        require(block.timestamp < powerUpNFTs[tokenId].expiration, "Expiration has already passed");
        powerUpNFTs[tokenId].expiration = newExpiration;
    }

    function isValid(uint256 tokenId) public view returns (bool) {
        return block.timestamp < powerUpNFTs[tokenId].expiration;
    }

    function getExpiration(uint256 tokenId) public view returns (uint256) {
        return powerUpNFTs[tokenId].expiration;
    }
}