//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import {Base64} from "./libraries/Base64.sol";

contract CryptoVan is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string svgPartOne =
        "<svg xmlns='http://www.w3.org/2000/svg' viewBox='-52 -53 100 100' stroke-width='2'><g fill='none'><ellipse stroke='#FF8C00' rx='6' ry='44'/><ellipse stroke='#";

    string svgPartTwo =
    "' rx='6' ry='44' transform='rotate(-66)'/><ellipse stroke='#";

    string svgPartThree =
    "' rx='6' ry='44' transform='rotate(66)'/><circle stroke='#";

    string svgPartFour =
    "' r='44'/></g><g fill='#";

    string svgPartFive =
    "' stroke='white'><circle fill='#";

    string svgPartSix = "' r='13'/><circle cy='-44' r='9'/><circle cx='-40' cy='18' r='9'/><circle cx='40' cy='18' r='9'/></g></svg>";


    string[] colors = ["6B8E23", "DB7093", "ADFF2F", "2F4F4F", "B22222", "008080", "FF1493", "7B68EE", "D2691E", "9400D3", "FFA07A", "B0E0E6"];

    event CryptoVanMinted(address sender, uint256 tokenId);

    constructor() ERC721("AtomNFT", "ATOM") {
        console.log("This is my NFT contract. Woah!");
    }

    // Same old stuff, pick a random color.
    function pickRandomColor(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("COLOR", Strings.toString(tokenId)))
        );
        rand = rand % colors.length;
        return colors[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function mintNFT() public {
        uint256 newItemId = _tokenIds.current();

        string memory randomColor = pickRandomColor(newItemId);

        string memory finalSvg = string(
            abi.encodePacked(
                svgPartOne,
                randomColor,
                svgPartTwo,
                randomColor,
                svgPartThree,
                randomColor,
                svgPartFour,
                randomColor,
                svgPartFive,
                randomColor,
                svgPartSix
            )
        );
        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "random", "description": "A collection of dynamic Vanessa", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(
            string(
                abi.encodePacked(
                    "https://nftpreview.0xdev.codes/?code=",
                    finalTokenUri
                )
            )
        );
        console.log("--------------------\n");

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);

        // Update your URI!!!
        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

        emit CryptoVanMinted(msg.sender, newItemId);
    }
}
