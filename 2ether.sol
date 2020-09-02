// SPDX-License-Identifier: GPL-3.0
pragma solidity >0.5.99 <0.8.0;

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

contract Coin is SafeMath {
    
    string public constant name = "Moris Token";
    string public constant symbol = "MST";
    uint32 public constant decimals = 18;
    uint256 public INITIAL_SUPPLY = 100000000 * 1 ether;
    
    
    constructor() {
    //totalSupply = INITIAL_SUPPLY;
    minter = msg.sender;
    balances[msg.sender] = INITIAL_SUPPLY;
    }
    
    address public minter;
    mapping (address => uint) public balances;
    event Sent(address from, address to, uint amount);
    
    //constructor() {
        //minter = msg.sender;
    //}
    
    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        require(amount < 1e60);
        //balances[receiver] += amount; 
        balances[receiver] = add(amount, balances[receiver]);
    }
    
    function sendtoken(address receiver, uint amount) public returns (bool){
        require(amount <= balances[msg.sender], "Insufficient balance.");
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
        return true;
    }
    
    function balanceOf(address _who) view public returns (uint256 _a)
    {
        return balances[_who];
    }
}
 
contract TwoEther is SafeMath { 
    
    address owner = msg.sender;
    address public token;
    
    function change_tok_address(address _a) public {
        assert(msg.sender == owner);
        token = _a;
    }
     /*
   //address public token = 0x015dad94128C0550093E51Ff3396713d895356E0;
    fallback() external payable {
        assert (msg.value > 2 * 10**18);
    }
        //_c =  Coin(token).balanceOf(address(this));
        //Coin(_token).send(msg.sender, _c);
        //_token.call(abi.encodeWithSignature("send1(address,uint256)", _token, _c));
        //Coin _coin = Coin(_token);
    */
    
    function sendme() public {
        uint256 _a = address(this).balance;
        msg.sender.transfer(_a);
    }
   
    function sendmetoken(uint _c, address _token) public {
        
        if(Coin(_token).sendtoken(msg.sender, _c))
        {
            
        }
        else
        {
            revert();
        }
    }
    
    
    function queryMe(address _token) view public returns (uint256 _b)
    {
        return Coin(_token).balanceOf(address(this));
    }
    
    function AmITowEther() pure public returns (bool _test)
    {
        return true;
    }
    
    function send_tok_for_ether() public payable{
        /*uint _a = 1;
        uint _b = 2;
        uint _c = add(_a, _b); */
        
        uint _tok = msg.value/1 ether;
        Coin(token).sendtoken(msg.sender, _tok);
    }
    
    receive() external payable {
    send_tok_for_ether();
  }
}
