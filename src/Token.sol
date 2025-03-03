//SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.18;

contract Token {
    constructor() {}

    mapping(address => uint256) s_balance;

    function name() public pure returns (string memory) {
        return "Token";
    }

    function totalSupply() public pure returns (uint256) {
        return 100 ether;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function balanceOf(address _owner) public returns (uint256) {
        return s_balance[_owner];
    }

    function transfer(address _to, uint256 _amount) public {
        uint256 previousBalance = balanceOf(msg.sender) + balanceOf(_to);
        s_balance[msg.sender] -= _amount;
        s_balance[_to] += _amount;

        require(balanceOf(msg.sender) + balanceOf(_to) == previousBalance);
    }
}
