import {ERC20} from "solady/tokens/ERC20.sol";
import {ERC721} from "solady/tokens/ERC721.sol";

interface INFTOutlet {
    function puzzle() external returns (address);
    function paymentToken() external returns (ERC20);
    function nftDealOfTheDay() external returns (ERC721);
    function treasury() external returns (address);
    function validAssets(address _asset) external returns (bool);
    function mintsClaimed(address _minter) external returns (bool);
    function magicFlagsUsed(bytes32 _magicFlag) external returns (bool);
    function pay(address _from, uint256 _amount) external returns (bool);
    function mint(address _to, uint256 _tokenId) external returns (bool);
    function setMagicFlagUsed(bytes32 _magicFlag) external;
    function changePaymentToken(address _newStablecoin) external;
    function rescueERC20(address _token) external;
}
