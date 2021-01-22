pragma solidity 0.6.0;

contract Nest_3_GetPrice {
    using SafeMath for uint256;
    using SafeERC20 for ERC20;

    // Voting contract
    Nest_3_VoteFactory _voteFactory;

    event price(uint256 ethAmount, uint256 tokenAmount, uint256 blockNum, uint256 ethMultiple, uint256 tokenForEth);
    event averagePrice(uint256 price);

    /**
     * @dev Initialization method
     * @param voteFactory Voting contract
     */
    constructor (address voteFactory) public {
        _voteFactory = Nest_3_VoteFactory(address(voteFactory));
    }

    /**
     * @dev Get a single price
     * @param token Token address of the price
     */
    function getSinglePrice(address token) public payable {
        // In consideration of future upgrades, the possibility of upgrading the price contract is not ruled out, and the voting contract must be used to query the price contract address.
        Nest_3_OfferPrice _offerPrice = Nest_3_OfferPrice(address(_voteFactory.checkAddress("nest.v3.offerPrice")));
        // Request the latest price, return the eth quantity, token quantity, and effective price block number. Tentative fee.
        (uint256 ethAmount, uint256 tokenAmount, uint256 blockNum) = _offerPrice.updateAndCheckPriceNow.value(0.001 ether)(token);
        uint256 ethMultiple = ethAmount.div(1 ether);
        uint256 tokenForEth = tokenAmount.div(ethMultiple);
        // If the eth paid for the price is left, it needs to be processed.
        // ........

        emit price(ethAmount, tokenAmount, blockNum, ethMultiple, tokenForEth);
    }

    /**
     * @dev Get multiple prices
     * @param token The token address of the price
     * @param priceNum Get the number of prices, sorted from the latest price
     */
    function getBatchPrice(address token, uint256 priceNum) public payable {
        // In consideration of future upgrades, the possibility of upgrading the price contract is not ruled out, and the voting contract must be used to query the price contract address.
        Nest_3_OfferPrice _offerPrice = Nest_3_OfferPrice(address(_voteFactory.checkAddress("nest.v3.offerPrice")));
        /**
         * The returned array is an integer multiple of 3, 3 data is a price data.
         * Corresponding respectively, eth quantity, token quantity, effective price block number.
         */
        uint256[] memory priceData = _offerPrice.updateAndCheckPriceList.value(0.01 ether)(token, priceNum);
        // Data processing
        uint256 allTokenForEth = 0;
        uint256 priceDataNum = priceData.length.div(3);
        for (uint256 i = 0; i < priceData.length;) {
            uint256 ethMultiple = priceData[i].div(1 ether);
            uint256 tokenForEth = priceData[i.add(1)].div(ethMultiple);
            allTokenForEth = allTokenForEth.add(tokenForEth);
            i = i.add(3);
        }
        // Average price
        uint256 calculationPrice = allTokenForEth.div(priceDataNum);
        // If the eth paid for the price is left, it needs to be processed.
        // ........


        emit averagePrice(calculationPrice);
    }

    /**
     * @dev Activate the price checking function
     * @param nestAddress NestToken address
     * @param nestAmount Destroy Nest quantity
     */
    function activation(address nestAddress, uint256 nestAmount) public {
        // In consideration of future upgrades, the possibility of upgrading the price contract is not ruled out, and the voting contract must be used to query the price contract address.
        Nest_3_OfferPrice _offerPrice = Nest_3_OfferPrice(address(_voteFactory.checkAddress("nest.v3.offerPrice")));
        // Authorize Nest to the price contract, the tentative quantity is 10,000
        ERC20(nestAddress).safeApprove(address(_offerPrice), nestAmount);
        // Activation
        _offerPrice.activation();
    }

    // Receive eth method, must be implemented.
    receive() external payable {

    }

}

// Voting contract
interface Nest_3_VoteFactory {
    // Check address
    function checkAddress(string calldata name) external view returns (address contractAddress);
}

// Pricing contract
interface Nest_3_OfferPrice {
    /**
    * @dev Activate the price checking function
    */
    function activation() external;

    /**
    * @dev Update and check the latest price
    * @param tokenAddress Token address
    * @return ethAmount ETH amount
    * @return erc20Amount Erc20 amount
    * @return blockNum Price block
    */
    function updateAndCheckPriceNow(address tokenAddress) external payable returns(uint256 ethAmount, uint256 erc20Amount, uint256 blockNum);
    /**
    * @dev Update and check the effective price list
    * @param tokenAddress Token address
    * @param num Number of prices to check
    * @return uint256[] price list
    */
    function updateAndCheckPriceList(address tokenAddress, uint256 num) external payable returns (uint256[] memory);
    /**
    * @dev Check the cost of obtaining the price
    */
    function checkPriceCost() public view returns (uint256);
}


library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(ERC20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(ERC20 token, address spender, uint256 value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(ERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(ERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }
    function callOptionalReturn(ERC20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeERC20: call to non-contract");
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

interface ERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}
