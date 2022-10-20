// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Ownable.sol";

contract RealEstate is Ownable {
     mapping(address=>address) private _admins;
     mapping(address=> uint256) private _paymentsTransferFrom;
     mapping(address=> uint256) private _paymentsTransferTo;


    event amountTransfered(address indexed _from, address indexed _to,uint256 _amount); 
    event depositAmountInContract(address indexed _from, address indexed _to,uint256 _amount); 
     
    constructor() payable {
        _admins[owner()] = owner();
    }

    modifier onlyOwners() {
        require(_admins[owner()] == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function tranferPayment(address payable from_, address payable to_, uint256 amount_) public payable{
        require(from_ !=address(0) && to_ !=address(0) , "Addresses should not be null");
        require(amount_ >= 0 && msg.value >= 0 && msg.value >= amount_, "Amount should be greater then 0");
        payable(to_).transfer(amount_);
        _paymentsTransferFrom[from_] = amount_;
        _paymentsTransferFrom[to_] = amount_;
        emit amountTransfered( from_, to_, amount_); 
    }

     function depositPaymentInContract(address payable from_, address payable contractAddress_, uint256 amount_) public payable onlyOwners{
        require(from_ !=address(0) && contractAddress_ !=address(0) , "Addresses should not be null");
        require(contractAddress_ == address(this) , "Contract address does not match with the provided address");
        require(amount_ >= 0 && msg.value >= 0 && msg.value >= amount_, "Amount should be greater then 0");
        _paymentsTransferFrom[from_] = amount_;
        _paymentsTransferFrom[contractAddress_] = amount_;
        emit depositAmountInContract( from_, contractAddress_, amount_); 
    }

    function addOwner(address _newOwner) public onlyOwner {
        require(_newOwner !=address(0), "Address should not be null");
        _admins[_newOwner] = _newOwner;
    }

    function isOwner(address userAddress_) public view returns(address) {
        require(userAddress_ !=address(0), "Address should not be null");
       return _admins[userAddress_];
    }

    function getUserAccountBalance() public view returns(uint256) {
        return (msg.sender).balance;
    }
    
    function getUserAccountHistory(address userAddress_) public view returns(uint256) {
        return (msg.sender).balance;
    }

}