//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract PetPark {
    enum AnimalType {
        Fish,
        Cat,
        Dog,
        Rabbit,
        Parrot
    }

    event Aded(AnimalType animalType, uint256 animalCount);

    function add() external {}
}
