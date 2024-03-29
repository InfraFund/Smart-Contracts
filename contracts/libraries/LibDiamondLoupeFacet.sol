// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { LibDiamond } from  "../libraries/LibDiamond.sol";

library LibDiamondLoupeFacet {


    function facetFunctionSelectors(address _facet) internal view returns (bytes4[] memory facetFunctionSelectors_) {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        facetFunctionSelectors_ = ds.facetFunctionSelectors[_facet].functionSelectors;
    }


    function facetAddress(bytes4 _functionSelector) internal view returns (address facetAddress_) {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        facetAddress_ = ds.selectorToFacetAndPosition[_functionSelector].facetAddress;
    }

}
