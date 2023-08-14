//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

// UUPS upgradeable contract

contract BatchTransferUpgradeable is OwnableUpgradeable, UUPSUpgradeable {
    bool public feeOn;
    address public feeTo;
    uint256 public fee;

    uint256[49] __gap;

    event TransferERC20(
        address from,
        address to,
        address token,
        uint256 amount
    );

    event SetFee(uint256 fee);

    function initialize() public initializer {}

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    function batchTransferERC20(
        address[] calldata tokens,
        uint256[] calldata amounts,
        address[] calldata receiver
    ) public payable {
        require(tokens.length == amounts.length, "Invalid params");
        require(amounts.length == receiver.length, "Invalid params");
        _checkFee();

        for (uint i = 0; i < tokens.length; i++) {
            IERC20Upgradeable(tokens[i]).transferFrom(
                msg.sender,
                receiver[i],
                amounts[i]
            );
            emit TransferERC20(msg.sender, receiver[i], tokens[i], amounts[i]);
        }
    }

    function setFeeOn(bool _feeOn) external onlyOwner {
        feeOn = _feeOn;
    }

    function setFee(uint256 _fee) external onlyOwner {
        fee = _fee;

        emit SetFee(fee);
    }

    function _checkFee() internal {
        if (feeOn) {
            require(msg.value == fee, "Invalid Fee");
        }
    }
}
