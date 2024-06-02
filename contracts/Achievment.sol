// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract AchievementNFT is ERC721 {
    // CEO Address set to the deployer.
    address CEO;

    // Base URI for token URI
    string private baseURI;

    // Mapping of achievement IDs to their corresponding metadata
    mapping(uint256 => Achievement) public achievements;

    // Mapping of player addresses to their achievement IDs
    mapping(address => uint256[]) public playerAchievements;

    // Event triggered when an achievement is minted
    event AchievementMinted(uint256 indexed achievementId, address indexed player);

    // Event triggered when an achievement is traded
    event AchievementTraded(uint256 indexed achievementId, address indexed from, address indexed to);

    // Struct to store achievement metadata
    struct Achievement {
        uint256 id;
        address owner;
        string name;
        uint256 rarity; // 0 = common, 1 = uncommon, 2 = rare, etc. Set only at time of mint
        bool isTransferable; // default = false. Set only at time of minting
    }

    // For achievement IDs
    uint256 public achievementIdCounter;

    constructor(string memory _name, string memory _symbol, string memory _baseURL) ERC721(_name, _symbol) {
        baseURI = _baseURL;
        CEO = msg.sender;
        achievementIdCounter = 0;
    }

    // modifier to check that the caller is the CEO
    modifier onlyCEO() {
        require(msg.sender == CEO, "Only the CEO is allowed to change the baseURI");
        _;
    }

    // Modifier to check if the caller is the owner of the achievement
    modifier onlyOwner(uint256 _achievementId) {
        require(achievements[_achievementId].owner == msg.sender, "Only the owner can perform this action");
        _;
    }

    
    function _baseURI() internal view override returns (string memory) { return baseURI;}

    // Function to update the base url can only be called by the CEO
    function updateBaseURL(string memory _baseURL) external onlyCEO { baseURI = _baseURL;}

    // Function to mint a new achievement
    function mintAchievement(address _player, string memory _name, uint256 _rarity, bool _transferable) public {
        uint256 newAchievementId = achievementIdCounter;
        achievements[newAchievementId] = Achievement(newAchievementId, msg.sender, _name, _rarity, _transferable);
        playerAchievements[_player].push(newAchievementId);
        _safeMint(msg.sender, newAchievementId);
        emit AchievementMinted(newAchievementId, _player);
        achievementIdCounter += 1;
    }

    // Function to get an achievement's metadata
    function getAchievementMetadata(uint256 _achievementId) public view returns (Achievement memory) {
        return achievements[_achievementId];
    }

    // Function to get a player's achievements
    function getPlayerAchievements(address _player) public view returns (uint256[] memory) {
        return playerAchievements[_player];
    }
}