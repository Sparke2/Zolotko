// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.4.25;

contract SafeMath {
    
  function mul(uint256 a, uint256 b) public pure  returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }
 
  function div(uint256 a, uint256 b)  public pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }
 
  function sub(uint256 a, uint256 b) public pure  returns (uint256) {
    assert(b <= a);
    return a - b;
  }
 
  function add(uint256 a, uint256 b)  public pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract Coin_1 is SafeMath {
    
    string public constant name = "Moris Token";
    string public constant symbol = "MST";
    uint32 public constant decimals = 18;
    uint256 public INITIAL_SUPPLY = 100000000 * 1 ether;
    
    uint256 totalTokens;
    mapping (address => mapping (address => uint256)) allowed;
    
    function totalSupply() view public returns (uint256 _totalSupply){
        return totalTokens;
    }
    
    constructor() public{
    totalTokens = INITIAL_SUPPLY;
    minter = msg.sender;
    balances[msg.sender] = INITIAL_SUPPLY;
    }
    
    address public minter;
    mapping (address => uint) public balances;
    event Transfer(address indexed _from, address indexed _to, uint amount);
    
    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        require(amount < 1e60);
        //balances[receiver] += amount; 
        balances[receiver] = add(amount, balances[receiver]);
    }
    
    function transfer(address receiver, uint amount) public returns(bool success) {
        require(amount <= balances[msg.sender], "Insufficient balance.");
        
        //balances[msg.sender] -= amount;
        //balances[receiver] += amount;
        
        balances[msg.sender] = sub(balances[msg.sender], amount);
        balances[receiver] = add(balances[receiver], amount);
        emit Transfer(msg.sender, receiver, amount);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        if (balances[_from] < _value || allowed[_from][msg.sender] < _value) {
            // Balance or allowance too low
            revert();
        }
        
        //balances[_to] += _value;
        //balances[_from] -= _value;
        //allowed[_from][msg.sender] -= _value;
        
        balances[_to] = add(balances[_to], _value);
        balances[_from] = sub(balances[_from], _value);
        allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
        emit Transfer(_from, _to, _value);
        return true;
    }
     event Approval(address indexed owner, address indexed spender, uint256 value);
     
     function approve(address _spender, uint256 _value) public returns (bool)
    {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function balanceOf(address _who) view public returns(uint256 _balance)
    {
        return balances[_who];
    }
    
    function allowance(address _owner, address _spender) view public returns (uint256)
    {
        return allowed[_owner][_spender];
    }
}
