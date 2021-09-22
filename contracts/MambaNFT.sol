// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/utils/Strings.sol";


contract MambaNFT is Ownable, ERC721 {
    
    uint public uid;

    struct MetaData {
        uint timestamp;
        uint id;
        string tokenURI;
    }

    constructor() ERC721("MambaNFT", "MAMBA") {
        uid = 1;
    }

    mapping(address => MetaData[]) public ownershipRecords;

    function mintToken() public returns (uint) {
        uint tid = uid;
        _safeMint(msg.sender, uid);

        MetaData memory newTokenData = MetaData({
            timestamp : block.timestamp,
            id : uid,
            tokenURI : "mambaURI"
        });
        ownershipRecords[msg.sender].push(newTokenData);
        uid++;
        return tid;
    }

    function burnToken(uint _id) public {
       require(msg.sender == ownerOf(_id), "Access denied. Not your token!");
        _burn(_id);
        removeToken(_id);
    }

    function removeToken(uint _id) private {
        for(uint i=0; i<ownershipRecords[msg.sender].length; i++){
            if  (ownershipRecords[msg.sender][i].id == _id) {
                delete ownershipRecords[msg.sender][i];
                break;
            }
        }
    }

}