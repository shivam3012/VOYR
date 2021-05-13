pragma solidity 0.8.4;
// SPDX-License-Identifier: Unlicensed

/*
#VOYR features:
   2% fee auto add to the liquidity pool to locked forever when selling
   2% fee auto distribute to all holders
   1% fee to operations for continuation of platform
   1% fee goes to charity - check http://docs.voyr.me/
   50% Supply is burned at start.
*/

interface IERC20 {

    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whbnber the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whbnber the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this mbnbod brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/bnbereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whbnber the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/bnbereum/solidity/issues/2691
        return msg.data;
    }
}

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.bnbereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an BNB balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

     /**
     * @dev We have made a business decision to comment out the renounceOwnership
     * function due to the fact that we will need to be able to control the contract
     * as needed for the business of VOYR.
     */
    // function renounceOwnership() public virtual onlyOwner {
    //     emit OwnershipTransferred(_owner, address(0));
    //     _owner = address(0);
    // }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function geUnlockTime() public view returns (uint256) {
        return _lockTime;
    }

    //Locks the contract for owner for the amount of time provided
    function lock(uint256 time) public virtual onlyOwner {
        _previousOwner = _owner;
        _owner = address(0);
        _lockTime = block.timestamp + time;
        emit OwnershipTransferred(_owner, address(0));
    }

    //Unlocks the contract for owner when _lockTime is exceeds
    function unlock() public virtual {
        require(_previousOwner == msg.sender, "You don't have permission to unlock");
        require(block.timestamp > _lockTime , "Contract is locked until 7 days");
        emit OwnershipTransferred(_owner, _previousOwner);
        _owner = _previousOwner;
    }
}

// pragma solidity >=0.5.0;

interface IPancakeSwapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

// pragma solidity >=0.5.0;

interface IPancakeSwapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint256 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

// pragma solidity >=0.6.2;

interface IPancakeSwapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityBNB(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountBNBMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountBNB, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityBNB(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountBNBMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountBNB);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityBNBWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountBNBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountBNB);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactBNBForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactBNB(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForBNB(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapBNBForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

// pragma solidity >=0.6.2;

interface IPancakeSwapV2Router02 is IPancakeSwapV2Router01 {
    function removeLiquidityBNBSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountBNBMin,
        address to,
        uint deadline
    ) external returns (uint amountBNB);
    function removeLiquidityBNBWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountBNBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountBNB);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactBNBForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForBNBSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract VOYR_Token is Context, IERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _rOwned;
    mapping (address => uint256) private _tOwned;
    mapping (address => mapping (address => uint256)) private _allowances;

    //setting up SafeSale token locks
    mapping (address => TokenLocks) private tokenLocks;
    mapping (string => address[]) private tokenLockAddresses;
    struct TokenLocks {
        uint256 startTime;
        uint256 endTime;
        uint256 amount;
        string lockType; //presale, founders, etc.
    }
    mapping (address => bool) private _paidPresale;
    uint256 private constant _presaleUnlockPrice = 10000000000000000;  // This is 0.05 BNB
    uint256 private constant _presaleMinimum = 10000000000000000;  // This is 0.1 BNB - must include 18 zeroes
    uint256 private constant _presaleMaximum = 25000000000000000000;  // This is 20 BNB - must include 18 zeroes
    uint256 private constant _tokenPerBNB = 10000000;  //10,000,000
    uint256 private constant _presaleLockDurationSeconds = ( 6 * 2592000);  // Number of months times seconds in a 30 day period
    uint256 totalTokensTradedPresale;
    uint256 presaleMaxTokens = 200000000000;
    
    mapping (address => bool) private _isExcludedFromFee;

    mapping (address => bool) private _isExcluded;
    address[] private _excluded;

    uint256 private constant MAX = ~uint256(0);
    uint256 private constant _tTotal = 1000000 * 10**6 * 10**9;
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 private _tFeeTotal;

    string private constant _name = "VOYR";
    string private constant _symbol = "VOYR";
    uint8 private constant _decimals = 9;

    uint256 public _taxFee = 2;
    uint256 private _previousTaxFee = _taxFee;

    uint256 public _liquidityFee = 2;
    uint256 private _previousLiquidityFee = _liquidityFee;

    uint256 public _operationsFee = 1;
    uint256 private _previousOperationsFee = _operationsFee;

    uint256 public _charityFee = 1;
    uint256 private _previousCharityFee = _charityFee;

    address public operationsWallet;
    address public previousOperationsWallet;
    address public charityWallet;
    address public previousCharityWallet;

    IPancakeSwapV2Router02 public immutable PancakeSwapV2Router;
    address public immutable pancakeswapV2Pair;

    bool inSwapAndLiquify;
    bool public swapAndLiquifyEnabled = true;

    uint256 public _maxTxAmount = 5000000 * 10**6 * 10**9;
    uint256 private constant numTokensSellToAddToLiquidity = 500000 * 10**6 * 10**9;

    event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 bnbReceived,
        uint256 tokensIntoLiquidity
    );
    event BalanceWithdrawn(
        address withdrawer,
        uint256 amount
    );
    event LiquidityAdded(
        uint256 tokenAmount,
        uint256 bnbAmount
    );
    event MaxTxAmountChanged(
        uint256 oldValue,
        uint256 newValue
    );
    event CharityWalletChanged(
        address oldValue,
        address newValue
    );
    event CharityFeeChanged(
        uint256 oldValue,
        uint256 newValue
    );
    event OperationsWalletChanged(
        address oldValue,
        address newValue
    );
    event OperationsFeeChanged(
        uint256 oldValue,
        uint256 newValue
    );
    event LiquidityFeeChanged(
        uint256 oldValue,
        uint256 newValue
    );
    event TaxFeeChanged(
        uint256 oldValue,
        uint256 newValue
    );
    event presaleUnlockSuccessful(
        address sender,
        string message
    );
    event presalePaymentSuccessful(
        address sender,
        string message
    );

    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    constructor () {
        _rOwned[_msgSender()] = _rTotal;
        
        // Enable the following line for BSC Mainnet deployment
        //IPancakeSwapV2Router02 _PancakeSwapV2Router = IPancakeSwapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        // ****ONLY ONE OF THESE TWO LINES SHOULD NOT BE COMMENTED OUT
        // Enable the following line for BSC Testnet deployment
        IPancakeSwapV2Router02 _PancakeSwapV2Router = IPancakeSwapV2Router02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
         // Create a pancakeswap pair for this new token
        pancakeswapV2Pair = IPancakeSwapV2Factory(_PancakeSwapV2Router.factory())
            .createPair(address(this), _PancakeSwapV2Router.WETH());

        // set the rest of the contract variables
        PancakeSwapV2Router = _PancakeSwapV2Router;

        //exclude owner and this contract from fee
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;

        emit Transfer(address(0), _msgSender(), _tTotal);
    }
    /**
    * @dev This is the start of the basic token
    */
    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() public pure override returns (uint256) {
        return _tTotal;
    }

    /** @dev We have modified the balanceOf function to take into account two things:
    * First we have to account for reflections, this is the tokenFromReflection function
    * Second we have account for locked tokens when showing the balance
    */
    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _tOwned[account];
        // @dev we subtract the presale locked amount
        if (tokenLocks[account].amount != 0) return tokenFromReflection(_rOwned[account]).sub(getTokenLockAmount(account));  // if there is no presale entry for this wallet it will return 0
        return tokenFromReflection(_rOwned[account]);
    }

    /** @dev We are overriding the transfer function to call the _transfer function
    * which takes into account all the reflections and taxes
    */

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    // @dev typical token functions

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function isExcludedFromReward(address account) public view returns (bool) {
        return _isExcluded[account];
    }

    function totalFees() public view returns (uint256) {
        return _tFeeTotal;
    }
    /** @dev This section integrates the SafeSale methodology
                                                                                             
     _______.     ___       _______  _______      _______.     ___       __       _______ 
    /       |    /   \     |   ____||   ____|    /       |    /   \     |  |     |   ____|
   |   (----`   /  ^  \    |  |__   |  |__      |   (----`   /  ^  \    |  |     |  |__   
    \   \      /  /_\  \   |   __|  |   __|      \   \      /  /_\  \   |  |     |   __|  
.----)   |    /  _____  \  |  |     |  |____ .----)   |    /  _____  \  |  `----.|  |____ 
|_______/    /__/     \__\ |__|     |_______||_______/    /__/     \__\ |_______||_______|
                                                                                                                                
    *   SafeSale is meant to elimate bots and post-presale sell-off that only hurts legitimate projects.
    *   True tokens are meant to be a long term HODL.
    *   SafeSale is meant to provide a safe presale of your tokens by requiring
    *   registration and a small payment beforehand to elimiate, or at least reduce,
    *   the ability for bots to take over your presale reducing the dreaded plummet
    *   of price when the bots take their profits and screw everyone else.
    *   The second part of SafeSale is the linear lock which creates a linear lock schedule
    */

    // @dev This view is to display the wallet owner's locked\available tokens and endTime within dapp
    function getLockedWalletDetails(address account) public view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
        uint256 _startTime = tokenLocks[account].startTime;
        uint256 _endTime = tokenLocks[account].endTime;
        uint256 _totalAmount = tokenLocks[account].amount;
        uint256 _lockedAmount = getTokenLockAmount(account);
        uint256 _accessibleAmount = _totalAmount - _lockedAmount;
        return (_startTime, _endTime, _totalAmount, _lockedAmount, _accessibleAmount, block.timestamp);
    }

    // @dev This function figures the proportion of time that has passed since the start relative to the end date and returns the proportion of tokens accessible
    function getTokenLockAccessible(address account) private view returns (uint256) {
        if (block.timestamp > tokenLocks[account].endTime) return (tokenLocks[account].amount); // If endtime has passed then display all since they're unlocked
        return (tokenLocks[account].amount * (((block.timestamp - tokenLocks[account].startTime) * 100) / (tokenLocks[account].endTime - tokenLocks[account].startTime))) / 100;
    }

    // @dev This function figures the proportion of time that has passed since the start relative to the end date and returns the proportion of tokens locked
    function getTokenLockAmount(address account) private view returns (uint256) {
        if (block.timestamp > tokenLocks[account].endTime) return 0;
        return (tokenLocks[account].amount * (((tokenLocks[account].endTime - block.timestamp) * 100) / (tokenLocks[account].endTime - tokenLocks[account].startTime))) / 100;
    }

    // @dev This is the start of the SafeSale registrtation process. This function takes in the presale unlock amount and approves it
    function acceptPresaleUnlockPayment() public payable {
        require(msg.value == _presaleUnlockPrice);
        require(totalTokensTradedPresale <= presaleMaxTokens);
        _paidPresale[msg.sender] = true;
        emit presaleUnlockSuccessful(msg.sender, "Thank you, Presale is unlocked!");
    }

    /** @dev If the wallet is approved then the wallet can send coin to this function
    *   The function first requires that the amount falls within the presale limits
    *   Then it makes sure the sender is approved for the presale, that they paid the registration
    *   Then it figures out how many tokens to provide based on the amount sent in, this uses the variable set up top to determine ratio needed
    *   Then it calls the assignTokenLock function which records the lock and transfers the tokens
    */
    function acceptPresalePayment() public payable {
        require(msg.value >= _presaleMinimum); // This is the minimum
        require(msg.value <= _presaleMaximum); // This is the maximum
        require(_paidPresale[msg.sender]); // make sure they unlocked
        uint256 _tokensFromPayment = ((msg.value / 10**9) * _tokenPerBNB); // count the tokens to give based on value sent in
        uint256 _lockEndTime = _presaleLockDurationSeconds + block.timestamp; // How long to lock for
        assignTokenLock(msg.sender, _tokensFromPayment, block.timestamp, _lockEndTime ,"presale");
        totalTokensTradedPresale = totalTokensTradedPresale.add(_tokensFromPayment / 10**9);
        emit presalePaymentSuccessful(msg.sender, "Thank you, Presale payment is Successful!");
    }

    /** @dev This function provides a mechanism to provide tokens to anyone at anytime for any # of months
    *   This function uses a 30day period to account for 1 month, yes this will not calculate out to a full year however it is close enough
    */
    function assignManualLock(address account, uint256 _amount,uint256 _lengthInMonths, string memory _type) public onlyOwner {
        uint256 _lockEndTime = (_lengthInMonths * 2592000) + block.timestamp;
        assignTokenLock(account, (_amount * 10**9), block.timestamp, _lockEndTime ,_type);
    }

    // @dev This function records the transaction to keep track of the lock and then transfers the tokens to the wallet as normal
    function assignTokenLock(address account, uint256 _amount, uint256 _startTime, uint256 _endTIme, string memory _type) private {
        require(tokenLocks[account].amount == 0, "You already have tokens locked");
        tokenLocks[account].amount = _amount;
        tokenLocks[account].startTime = _startTime;
        tokenLocks[account].endTime = _endTIme;
        tokenLocks[account].lockType = _type;
        tokenLockAddresses[_type].push(account);
        _transfer(owner(), account, _amount);
    }

    // @dev A view to access the list of addresses that have locked tokens
    function getTokenLockAddresses(string memory _type) public view returns (address[] memory){
        return tokenLockAddresses[_type];
    }

    function checkWalletPresaleUnlock(address account) public view returns (bool) {
        return _paidPresale[account];
    }

    function getPresaleDetails() public view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256){
        return (_presaleUnlockPrice, _presaleMinimum, _presaleMaximum, _tokenPerBNB, _presaleLockDurationSeconds, totalTokensTradedPresale, presaleMaxTokens)
    }

    /** @dev This ends the SafeSale section
                                                                                             
     _______.     ___       _______  _______      _______.     ___       __       _______ 
    /       |    /   \     |   ____||   ____|    /       |    /   \     |  |     |   ____|
   |   (----`   /  ^  \    |  |__   |  |__      |   (----`   /  ^  \    |  |     |  |__   
    \   \      /  /_\  \   |   __|  |   __|      \   \      /  /_\  \   |  |     |   __|  
.----)   |    /  _____  \  |  |     |  |____ .----)   |    /  _____  \  |  `----.|  |____ 
|_______/    /__/     \__\ |__|     |_______||_______/    /__/     \__\ |_______||_______|
                                                                                                                                
    */
    

    // @dev This gets the amount of reflections based on the tokens
    function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
        require(tAmount <= _tTotal, "Amount must be less than supply");
        if (!deductTransferFee) {
            (uint256 rAmount,,,,,,,) = _getValues(tAmount);
            return rAmount;
        } else {
            (,uint256 rTransferAmount,,,,,,) = _getValues(tAmount);
            return rTransferAmount;
        }
    }
    //  @dev This gets the rate of reflections based on the tokens amount
    function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
        require(rAmount <= _rTotal, "Amount must be less than total reflections");
        uint256 currentRate =  _getRate();
        return rAmount.div(currentRate);
    }

    // @dev This will exclude the address from rewards
    function excludeFromReward(address account) public onlyOwner() {
        // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude pancakeswap router.');
        require(!_isExcluded[account], "Account is already excluded");
        if(_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcluded[account] = true;
        _excluded.push(account);
    }

    // @dev This will include the addres to rewards
    function includeInReward(address account) external onlyOwner() {
        require(_isExcluded[account], "Account is not excluded");
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                _tOwned[account] = 0;
                _isExcluded[account] = false;
                _excluded.pop();
                break;
            }
        }
    }

    //  @dev This is to exclude an account from fees, such as the owner wallet, charity and operations
    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }

    // @dev This reverts the excludeFromFee
    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }

    //  @dev This view returns true if the account is excluded from fees
    function isExcludedFromFee(address account) public view returns(bool) {
        return _isExcludedFromFee[account];
    }

    /** @dev These functions are needed to remove the fees during the transactions when needed
    *   These are used during the transfer to turn off the fees\taxes for excluded accounts
    *   These setters are public because there needs to be a level of control
    *   to be able reduce fees as necessary depending on market conditions.
    *   VOYR will utilizing multi-sig wallets to protect against any single person changing these values.
    */
    function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
        _previousTaxFee = _taxFee;
        _taxFee = taxFee;
        emit TaxFeeChanged(_previousTaxFee, _taxFee);
    }

    function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
        _previousLiquidityFee = _liquidityFee;
        _liquidityFee = liquidityFee;
        emit LiquidityFeeChanged(_previousLiquidityFee, _liquidityFee);
    }

    //  @dev The operations fee is to pay for the infrastructure of the platform
    function setOperationsFeePercent(uint256 operationsFee) external onlyOwner() {
        _previousOperationsFee = _operationsFee;
        _operationsFee = operationsFee;
        emit OperationsFeeChanged(_previousOperationsFee, _operationsFee);
    }

    // @dev This gives the owner the ability to change the operations wallet if something were to happen
    function setOperationsWallet(address _operationsWallet) external onlyOwner() {
        address previousOperationsWallet = operationsWallet;
        operationsWallet = _operationsWallet;
        _isExcluded[operationsWallet] = true;
        emit OperationsWalletChanged(operationsWallet, _oldwallet);
    }

    //  @dev The charity fee is to pay back to those in need
    function setCharityFeePercent(uint256 charityFee) external onlyOwner() {
        _previousCharityFee = _charityFee;
        _charityFee = charityFee;
        emit CharityFeeChanged(_previousCharityFee, _charityFee);
    }

    // @dev This gives the owner the ability to change the charity wallet if something were to happen
    function setCharityWallet(address _charityWallet) external onlyOwner() {
        previousCharityWallet = charityWallet;
        charityWallet = _charityWallet;
        _isExcluded[charityWallet] = true;
        emit CharityWalletChanged(previousCharityWallet, charityWallet);
    }

    //  @dev This sets a maximum transaction amount
    function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
        uint256 _previoiusAmount = _maxTxAmount;
        _maxTxAmount = _tTotal.mul(maxTxPercent).div(
            10**2
        );
        emit MaxTxAmountChanged(_previoiusAmount, _maxTxAmount);
    }

    // @dev This enables and disables the swapAndLiquify function as needed
    function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
        swapAndLiquifyEnabled = _enabled;
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }

    //  @dev needed to receive BNB from pancakeswapV2Router when swapping
    receive() external payable {}

    //  @dev This caluclates the reflect fee
    function _reflectFee(uint256 rFee, uint256 tFee) private {
        _rTotal = _rTotal.sub(rFee);
        _tFeeTotal = _tFeeTotal.add(tFee);
    }

    // @dev This adds the fees to the operations wallet
    function _takeOperationsFee(uint256 tOperations) private {
        _tOwned[operationsWallet] = _tOwned[operationsWallet].add(tOperations);
    }

    // @dev This adds the fees to the charity wallet
    function _takeCharityFee(uint256 tCharity) private {
        _tOwned[charityWallet] = _tOwned[charityWallet].add(tCharity);
    }

    //  @dev This is used to get the values of the reflections, fees and liquidity for the transactions
    function _getValues(uint256 tAmount) private view returns (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 , uint256, uint256, uint256, uint256) {
        (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tOperations, uint256 tCharity) = _getTValues(tAmount);
        {
            (rAmount, rTransferAmount, rFee) = _getRValues(tAmount, tFee, tLiquidity, tOperations, tCharity, _getRate());
            return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tOperations, tCharity);
        }
    }

    //  @dev This is used to get the tValues
    function _getTValues(uint256 tAmount) private view returns (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tOperations, uint256 tCharity) {
        tFee = calculateTaxFee(tAmount);
        tLiquidity = calculateLiquidityFee(tAmount);
        tOperations= calculateOperationsFee(tAmount);
        tCharity = calculateCharityFee(tAmount);
        tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tOperations).sub(tCharity);
        return (tTransferAmount, tFee, tLiquidity, tOperations, tCharity);
    }

    //  @dev This is used to get the rValues
    function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tOperations, uint256 tCharity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
        uint256 rAmount = tAmount.mul(currentRate); //reflection amount
        uint256 rFee = tFee.mul(currentRate);
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        uint256 rOperations = tOperations.mul(currentRate);
        uint256 rCharity = tCharity.mul(currentRate);
        uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rOperations).sub(rCharity);
        return (rAmount, rTransferAmount, rFee);
    }

    //  @dev This is used to get the rates
    function _getRate() private view returns(uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    //  @dev This is used to get the current supply
    function _getCurrentSupply() private view returns(uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
            rSupply = rSupply.sub(_rOwned[_excluded[i]]);
            tSupply = tSupply.sub(_tOwned[_excluded[i]]);
        }
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    //  @dev This is used to get the take the liquidity 
    function _takeLiquidity(uint256 tLiquidity) private {
        uint256 currentRate =  _getRate();
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
        if(_isExcluded[address(this)])
            _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
    }

    // @dev This is used to calculate the tax fee
    function calculateTaxFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_taxFee).div(
            10**2
        );
    }

    //  @dev This is used to calculate the Liquidity Fee
    function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_liquidityFee).div(
            10**2
        );
    }

    //  @dev This is used to calculate the Operations Fee
    function calculateOperationsFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_operationsFee).div(
            10**2
        );
    }

    //  @dev This is used to calculate the Charity Fee
    function calculateCharityFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_charityFee).div(
            10**2
        );
    }

    //  @dev This is used to remove the fees during a transaction that is excluded
    function removeAllFee() private {
        if(_taxFee == 0 && _liquidityFee == 0 && _operationsFee == 0 && _charityFee == 0) return;

        _previousTaxFee = _taxFee;
        _previousLiquidityFee = _liquidityFee;
        _previousOperationsFee = _operationsFee;
        _previousCharityFee = _charityFee;

        _taxFee = 0;
        _liquidityFee = 0;
        _operationsFee = 0;
        _charityFee = 0;
    }

    // @dev This is used to restore the fees after the transaction
    function restoreAllFee() private {
        _taxFee = _previousTaxFee;
        _liquidityFee = _previousLiquidityFee;
        _operationsFee = _previousOperationsFee;
        _charityFee = _previousCharityFee;
    }

    //  @dev This is used to approve future transactions and varifies it isn't to\from a 0 address    
    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /** @dev 
.___________..______           ___      .__   __.      _______. _______  _______ .______      
|           ||   _  \         /   \     |  \ |  |     /       ||   ____||   ____||   _  \     
`---|  |----`|  |_)  |       /  ^  \    |   \|  |    |   (----`|  |__   |  |__   |  |_)  |    
    |  |     |      /       /  /_\  \   |  . `  |     \   \    |   __|  |   __|  |      /     
    |  |     |  |\  \----. /  _____  \  |  |\   | .----)   |   |  |     |  |____ |  |\  \----.
    |__|     | _| `._____|/__/     \__\ |__| \__| |_______/    |__|     |_______|| _| `._____|
                                                                                              
    *   This is the start of the special transfers that have to happen due to the reflections
    *   This is the start of a long journey across multiple functions to get the transaction completed
    *   Verifications are being done at the beginning and then it calls _tokenTransfers
    *   _tokenTransfers then determines which function to call based on whether or not any of
    *   the addresses are excluded. This will go to one of 4 functions, we'll follow the standard one
    *   which is pretty much the same for the others just the others turn off the fees. The next step
    *   is to call _transferStandard which performs the actual transfer. Check the functions for more details.
    */
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        require(amount <= balanceOf(from),"You are trying to transfer more than has vested");
        if(from != owner() && to != owner())
            require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");

        // is the token balance of this contract address over the min number of
        // tokens that we need to initiate a swap + liquidity lock?
        // also, don't get caught in a circular liquidity event.
        // also, don't swap & liquify if sender is pancakeswap pair.
        uint256 contractTokenBalance = balanceOf(address(this));

        if(contractTokenBalance >= _maxTxAmount)
        {
            contractTokenBalance = _maxTxAmount;
        }

        bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
        if (
            overMinTokenBalance &&
            !inSwapAndLiquify &&
            from != pancakeswapV2Pair &&
            swapAndLiquifyEnabled
        ) {
            contractTokenBalance = numTokensSellToAddToLiquidity;
            //add liquidity
            swapAndLiquify(contractTokenBalance);
        }

        //indicates if fee should be deducted from transfer
        bool takeFee = true;

        //if any account belongs to _isExcludedFromFee account then remove the fee
        if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
            takeFee = false;
        }

        //transfer amount, it will take tax, burn, liquidity fee
        _tokenTransfer(from,to,amount,takeFee);
    }

        //this method is responsible for taking all fee, if takeFee is true
    function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
        if(!takeFee)
            removeAllFee();

        if (_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferFromExcluded(sender, recipient, amount);
        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
            _transferToExcluded(sender, recipient, amount);
        } else if (_isExcluded[sender] && _isExcluded[recipient]) {
            _transferBothExcluded(sender, recipient, amount);
        } else {
            _transferStandard(sender, recipient, amount);
        }

        if(!takeFee)
            restoreAllFee();
    }

    /** @dev This is the transfer that will be used most.
    *   There is a lot going on here because this function ends up calling _getValues
    *   this in turn calls _getTvalues, then it calls _getRValues which needs _getRate as in input value.
    *   Once it gets back here it calls each of the functions to take their share of the liquidity\reflect\operations\charity
    */
    function _transferStandard(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tOperations, uint256 tCharity) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        _reflectFee(rFee, tFee);
        _takeOperationsFee(tOperations);
        _takeCharityFee(tCharity);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    // @dev This follows the same path as _transferStandard but it turns off the fees
    function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tOperations, uint256 tCharity) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        _reflectFee(rFee, tFee);
        _takeOperationsFee(tOperations);
        _takeCharityFee(tCharity);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    //  @dev This will transfer when both accounts are excluded
    function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tOperations, uint256 tCharity) = _getValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        _reflectFee(rFee, tFee);
        _takeOperationsFee(tOperations);
        _takeCharityFee(tCharity);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    // @dev This follows the same path as _transferStandard but it turns off the fees
    function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tOperations, uint256 tCharity) = _getValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        _reflectFee(rFee, tFee);
        _takeOperationsFee(tOperations);
        _takeCharityFee(tCharity);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    /** This is the end of the transfer section
.___________..______           ___      .__   __.      _______. _______  _______ .______      
|           ||   _  \         /   \     |  \ |  |     /       ||   ____||   ____||   _  \     
`---|  |----`|  |_)  |       /  ^  \    |   \|  |    |   (----`|  |__   |  |__   |  |_)  |    
    |  |     |      /       /  /_\  \   |  . `  |     \   \    |   __|  |   __|  |      /     
    |  |     |  |\  \----. /  _____  \  |  |\   | .----)   |   |  |     |  |____ |  |\  \----.
    |__|     | _| `._____|/__/     \__\ |__| \__| |_______/    |__|     |_______|| _| `._____|
                                                                                              
    */

    // @dev This is used to provide liquidity back
    function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
        // split the contract balance into halves
        uint256 half = contractTokenBalance.div(2);
        uint256 otherHalf = contractTokenBalance.sub(half);

        // capture the contract's current BNB balance.
        // this is so that we can capture exactly the amount of BNB that the
        // swap creates, and not make the liquidity event include any BNB that
        // has been manually sent to the contract
        uint256 initialBalance = address(this).balance;

        // swap tokens for BNB

        swapTokensForBNB(half); // <- this breaks the BNB -> HATE swap when swap+liquify is triggered

        // how much BNB did we just swap into?
        uint256 newBalance = address(this).balance.sub(initialBalance);

        // add liquidity to pancakeswap
        addLiquidity(otherHalf, newBalance);

        emit SwapAndLiquify(half, newBalance, otherHalf);
    }

    // @dev This is used by the swapAndLiquify function to swap to BNB
    function swapTokensForBNB(uint256 tokenAmount) private {

        // generate the pancakeswap pair path of token -> wbnb
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = PancakeSwapV2Router.WETH();

        _approve(address(this), address(PancakeSwapV2Router), tokenAmount);

        // make the swap
        PancakeSwapV2Router.swapExactTokensForBNBSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of BNB
            path,
            address(this),
            block.timestamp
        );
    }

    // @dev This adds the liquidity back in
    function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(PancakeSwapV2Router), tokenAmount);

        // add the liquidity
        PancakeSwapV2Router.addLiquidityBNB{value: bnbAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            owner(),
            block.timestamp
        );
        emit LiquidityAdded(tokenAmount, bnbAmount);
    }

    /** @dev Per Certik's audit of SafeMoon it is recommended to have this withdraw function
    *   We do not intend to use this, please note that VOYR uses a multisig wallet for owner
    *   If you are going to copy/paste this contract please be aware that this will be a big
    *   red flag for anyone that isn't using a multisig wallet or have any other reason to 
    *   trust that the owner will not empty this contract.
    *   Since VOYR is a registered legal entity in the United States we are bound by the laws.
    */
    function withdraw() onlyOwner public {
      uint256 balance = address(this).balance;
      payable(msg.sender).transfer(balance);
      emit BalanceWithdrawn(msg.sender, balance);
    }

}
