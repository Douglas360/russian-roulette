// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Roullete {
    address[] players;
    uint256 public room;

    event playerJoinned(address indexed _player, uint256 _room);

    function enter() public payable {
        //verify quantity player on this room
        require(players.length < 6, "Wait next room");

        //send  the amount of the transaction to  the contract
        require(msg.value == 0.1 ether, "Send exact 0.1 eth");

        players.push(msg.sender);

        emit playerJoinned(msg.sender, room);

        if (players.length == 6) {
            executeRoom();
        }
    }

    function executeRoom() private {
        require(players.length == 6);
        uint256 deadSeat = random();

        distributeFund(deadSeat);
        room = room + 1;
        players = new address[](0);
    }

    function distributeFund(uint256 victimSeat)
        public
        payable
        returns (address[] memory){
        uint256 valueToDistribute = SafeMath.div(address(this).balance, 5);

        //value to distribute
        for (uint256 i; i < 5; i++) {
            if (i != victimSeat) {
                payable(players[i]).transfer(valueToDistribute);
            }
        }
        return players;
    }

    function random() private view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        block.number,
                        room,
                        block.difficulty
                    )
                )
            ) % 6;
    }

    function getBalanceContract() public view returns (uint256) {
        return address(this).balance;
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }
}
