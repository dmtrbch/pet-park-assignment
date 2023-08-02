//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/access/Ownable.sol";

contract PetPark is Ownable {
    enum AnimalType {
        Fish,
        Cat,
        Dog,
        Rabbit,
        Parrot,
        None
    }

    enum Gender {
        Male,
        Female
    }

    struct User {
        uint256 age;
        Gender gender;
        bool borrowed;
        AnimalType animalType;
    }

    mapping(AnimalType => uint256) public animalCounts;
    mapping(address => User) public userDetails;

    event Added(AnimalType animalType, uint256 animalCount);
    event Borrowed(AnimalType animalType);
    event Returned(AnimalType animalType);

    function add(
        AnimalType _animalType,
        uint256 _animalCount
    ) external onlyOwner {
        require(_animalType != AnimalType.None, "Invalid animal");
        animalCounts[_animalType] += _animalCount;

        emit Added(_animalType, _animalCount);
    }

    function borrow(
        uint256 _age,
        Gender _gender,
        AnimalType _animalType
    ) external {
        require(_animalType != AnimalType.None, "Invalid animal type");
        require(animalCounts[_animalType] > 0, "Selected animal not available");

        if (
            _gender == Gender.Female &&
            _age < 40 &&
            _animalType == AnimalType.Cat
        ) revert("Invalid animal for women under 40");

        User memory user = userDetails[msg.sender];

        if (user.age == 0) {
            user.age = _age;
        }

        require(user.age == _age && _age != 0, "Invalid Age");
        require(user.gender == _gender, "Invalid Gender");
        require(!user.borrowed, "Already adopted a pet");

        if (
            _gender == Gender.Male &&
            (_animalType == AnimalType.Cat ||
                _animalType == AnimalType.Rabbit ||
                _animalType == AnimalType.Parrot)
        ) revert("Invalid animal for men");

        animalCounts[_animalType]--;

        user.borrowed = true;
        user.gender = _gender;
        user.animalType = _animalType;

        userDetails[msg.sender] = user;

        emit Borrowed(_animalType);
    }

    function giveBackAnimal() external {
        User memory user = userDetails[msg.sender];

        require(user.borrowed, "No borrowed pets");

        user.borrowed = false;
        animalCounts[user.animalType]++;
    }
}
