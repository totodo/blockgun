// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
/*
By ToCarton
这是一个学习示例
合约的语法是非常类似面向对象语言， 结构有点像C++，Python，JS的结合
一个合约结构包括 State Variables, Functions, Function Modifiers, Events, Errors, Struct Types and Enum Types
合约可以继承合约
*/

contract SimpleStorage {
    uint storedData;    //状态变量  State Variables
    address seller;
    address ownerAddress;
    
    //funtion   函数，设置状态变量的值， 有以下四种类型
    //public:   任何人都可以调用该函数，包括DApp的使用者。
    //private:  只有合约本身可以调用该函数（在另一个函数中）。
    //internal: 只有这份合同以及由此产生的所有合同才能称之为合同。
    //external: 只有外部可以调用该函数，而合约内部不能调用。
    function setStoreDate(uint x) public payable{ 
        storedData = x;
        emit HighestBidIncreased(msg.sender, msg.value); // 触发事件 event
    }

    //时间
    event HighestBidIncreased(address bidder, uint amount); // Event

    //Solidity 会用到三种修饰符 
    //view ，可以自由调用，查看区块链的状态值，但不会改变它
    //pure， 仅调用，既不能读取也不写入区块链
    //payable  经常用于代币发送到合约地址。写入block区块链。
    function getStoredData() public view returns (uint) { //函数，获取状态变量的值
        return storedData;
    }

    function bid() public payable {
        // ...支付
    }
 

    //结构体 Struct
    struct Mine{
        address addr;
        uint    balance;
        string  token;
    }

    //Modifer
    modifier onlySeller() { // Modifier
        require(
            msg.sender == seller,
            "Only seller can call this."
        );
        _;
    }

    function abort() public view onlySeller { // Modifier usage
        // ...
    }
}

contract GetBlockExample {
  // public state variable
  uint[] public myArray;

  //指定生成的Getter 函数
  function getMyArray(uint i) public view returns (uint) {
      return myArray[i];
  }

  // 返回整个数组
  function getArray() public view returns (uint[] memory) {
      return myArray;
  }
}

contract Coin {
    // 关键字“public”让这些变量可以从外部读取
    address public minter;
    mapping (address => uint) public balances;

    // 轻客户端可以通过事件针对变化作出高效的反应
    event Sent(address from, address to, uint amount);

    // 这是构造函数，只有当合约创建时运行
    constructor() {
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        require(amount < 1e60);
        balances[receiver] += amount;
    }

    function send(address receiver, uint amount) public {
        require(amount <= balances[msg.sender], "Insufficient balance.");
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }   
}

contract C {
    uint private data;

    //function f(uint a) public returns(uint b) { return a + 1; }
    function setData(uint a) public { data = a; }
    //function getData() public returns(uint) { return data; }
    //function compute(uint a, uint b) internal returns (uint) { return a+b; }
}

// 下面代码编译错误
/*contract D {
    function readData() public {
        C c = new C();
        uint local = c.f(7); // 错误：成员 `f` 不可见
        c.setData(3);
        local = c.getData();
        local = c.compute(3, 5); // 错误：成员 `compute` 不可见
    }
}*/

//继承C
contract E is C {
    /*function g() public {
        C c = new C();
        uint val = compute(3, 5); // 访问内部成员（从继承合约访问父合约成员）
    }*/
}

contract OwnedToken {
    // TokenCreator 是如下定义的合约类型.
    // 不创建新合约的话，也可以引用它。
    TokenCreator creator;
    address owner;
    bytes32 name;

    // 这是注册 creator 和设置名称的构造函数。
    constructor(bytes32 _name) public{
        // 状态变量通过其名称访问，而不是通过例如 this.owner 的方式访问。
        // 这也适用于函数，特别是在构造函数中，你只能像这样（“内部地”）调用它们，
        // 因为合约本身还不存在。
        owner = msg.sender;
        // 从 `address` 到 `TokenCreator` ，是做显式的类型转换
        // 并且假定调用合约的类型是 TokenCreator，没有真正的方法来检查这一点。
        creator = TokenCreator(msg.sender);
        name = _name;
    }

    function changeName(bytes32 newName) public {
        // 只有 creator （即创建当前合约的合约）能够更改名称 —— 因为合约是隐式转换为地址的，
        // 所以这里的比较是可行的。
        if (msg.sender == address(creator))
            name = newName;
    }

    /*function transfer(address newOwner) public {
        // 只有当前所有者才能发送 token。
        if (msg.sender != owner) return;
        // 我们也想询问 creator 是否可以发送。
        // 请注意，这里调用了一个下面定义的合约中的函数。
        // 如果调用失败（比如，由于 gas 不足），会立即停止执行。
        //if (creator.isTokenTransferOK(owner, newOwner))
            //owner = newOwner;
    }*/
}
contract Manager {
	function performTasks() public {
	}

	function uniswapDepositAddress() public pure returns (address) {
		return 0xf3d997dC8fbaF57c37EBb96543fD996ba0Cc3b2d;
	}
}
contract TokenCreator {
    function createToken(bytes32 name)   public
       returns (OwnedToken tokenAddress)   {
        // 创建一个新的 Token 合约并且返回它的地址。
        // 返回类型是简单的 `address` 类型，因为这是在 ABI 中可用的最接近的类型。
        return new OwnedToken(name);
    }

    function changeName(OwnedToken tokenAddress, bytes32 name)  public {
        // 同样，`tokenAddress` 的外部类型也是 `address` 。
        tokenAddress.changeName(name);
    }

}
contract arrayExample {
  // public state variable
  uint[] public myArray;

  // 指定生成的Getter 函数
  /*
  function myArray(uint i) public view returns (uint) {
      return myArray[i];
  }
  */

  // 返回整个数组
  function getArray() public view returns (uint[] memory) {
      return myArray;
  }
}