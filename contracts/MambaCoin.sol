// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract MambaCoin is Ownable, ERC20("MambaCoin","MAMBA") {
    
    mapping(address => uint256) public balances;
    mapping(address => Payment[]) records;
    
    address administrator;
    uint currentPaymentId=0;

    struct Payment {
        uint id;
        address recipient;
        uint amount;
        PaymentType paymentType;
        string comment;
        uint timestamp;
    }

    struct Log {
        address sender;
        uint id;
    }
    mapping(uint => Log) public recordLog;

    enum PaymentType {Unknown, BasicPayment, Refund, Dividend, GroupPayment}
       
    event supplyChanged(uint256);
    event Transfer(string, address indexed, uint256);
   
   constructor () {
        administrator = msg.sender;
        _mint(owner(), 10000);
        balances[owner()] = totalSupply();
   }
   
   
   function updateTotalSupply() external onlyOwner {
        _mint(msg.sender, totalSupply());
      emit supplyChanged(totalSupply());
   }
   
    function transfer(address _to, uint _amount) public override returns (bool) {
        _transfer(msg.sender, _to, _amount);

      //record the payment...
        Payment memory new_payment = Payment({ 
            amount: _amount,
            recipient: _to,
            timestamp: block.timestamp,
            id: currentPaymentId,
            paymentType: PaymentType.Unknown,
            comment: ""
        });

        records[msg.sender].push(new_payment);
        recordLog[currentPaymentId] = Log({sender: msg.sender, id: records[msg.sender].length-1});
        currentPaymentId++;

        emit Transfer('Transfer Successful', _to, _amount);

        return true;
   }
     
   function getRecords(address _user) external view returns (Payment[] memory) {
       return records[_user];
   }

    /**
     * @dev shows all payments made by the user
     * @return the array for Payment elements
     */
    function ownRecords() external view returns (Payment[] memory) { 
        return records[msg.sender];
    }

    /**
     * @dev updates details of a payment
     * @param _id the id of the payment
     * @param _type the type of payment
     * @param _comment a comment
     */
    function updateDetails(uint _id, PaymentType _type, string calldata _comment) public {
        require(_id < currentPaymentId, "Non existing payment ID");
        require(uint(_type) < 5, "Invalid payment type");
        if (msg.sender==administrator){
            Log memory record = recordLog[_id];
            //Payment storage payment = record[record.sender][] 
            records[record.sender][record.id].paymentType = _type;
            records[record.sender][record.id].comment = string(abi.encodePacked(_comment, " updated by ", Strings.toHexString(uint256(uint160(administrator)))));
        }
        else{
            for (uint i=0; i<records[msg.sender].length; i++){
                if (records[msg.sender][i].id == _id){
                    records[msg.sender][i].paymentType = _type;
                    records[msg.sender][i].comment = _comment;
                    break;
                }                
            }
        }
        
    }

   
}