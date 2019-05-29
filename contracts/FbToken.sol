pragma solidity ^0.5.0;



contract FbToken {

  address payable public owner;

  string public name = "FbToken";
  string public symbol = "FBT";
  string public standard = "FbToken v1.0";

  uint256 private _totalSupply;

  mapping(address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowances;

  event Transfer(
    address indexed _from,
    address indexed _to,
    uint256 _value
  );

  event Approval(
    address indexed _owner,
    address indexed _spender,
    uint256 _value
  );

  modifier onlyOwner() {
      require(msg.sender == owner);
      _;
  }

  constructor(uint256 _initialSupply) public{
    _totalSupply = _initialSupply;
    _balances[msg.sender] = _totalSupply;
    owner = msg.sender;
  }

  /**
   * Total number of tokens exists.
   */
  function totalSupply() public view returns (uint256) {
      return _totalSupply;
  }

  /**
   * Gets the balance of the specified address.
   * @param account The address to query the balance of.
   * @return A uint256 representing the amount owned by the passed address.
   */
  function balanceOf(address account) public view returns (uint256) {
      return _balances[account];
  }

  /**
   * Function to check the amount of tokens that an owner allowed to a spender.
   * @param account address The address which owns the funds.
   * @param spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address account, address spender) public view returns (uint256 remaining) {
      return _allowances[account][spender];
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param spender The address which will spend the funds.
   * @param value The amount of tokens to be spent.
   */
  function approve(address spender, uint256 value) public returns (bool success) {
    _approve(msg.sender, spender, value);
    return true;
  }

  /**
   * @dev Transfer tokens from one address to another.
   * Note that while this function emits an Approval event, this is not required as per the specification,
   * and other compliant implementations may not emit the event.
   * @param from address The address which you want to send tokens from
   * @param to address The address which you want to transfer to
   * @param value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address from, address to, uint256 value) public returns (bool) {
    require(value <= _allowances[from][msg.sender]);
    require(from != address(0), "ERC20: transfer from the zero address");
    require(to != address(0), "ERC20: transfer to the zero address");
    require(balanceOf(from) >= value, "You not have the ammount");

    _balances[from] = _balances[from] - value;
    _balances[to] = _balances[to] + value;
    _allowances[from][msg.sender] -= value;

    emit Transfer(from, to, value);

    return true;
  }

  /**
   * Transfer token to a specified address.
   * @param to The address to transfer to.
   * @param value The amount to be transferred.
   */
  function transfer(address to, uint256 value) public returns (bool success) {
    _transfer(msg.sender, to, value);
    return true;
  }

  /**
   * @dev Internal function that mints an amount of the token and assigns it to
   * an account. This encapsulates the modification of balances such that the
   * proper events are emitted.
   * @param account The account that will receive the created tokens.
   * @param value The amount that will be created.
   */
  function mint(address account, uint256 value) public onlyOwner returns (bool success){
    require(account != address(0), "ERC20: mint to the zero address");

    _totalSupply += value;
    _balances[account] += value;
    emit Transfer(address(0), account, value);
    return true;
  }

  /**
   * @dev Transfer token for a specified addresses.
   * @param from The address to transfer from.
   * @param to The address to transfer to.
   * @param value The amount to be transferred.
   */
  function _transfer(address from, address to, uint256 value) internal {
      require(from != address(0), "ERC20: transfer from the zero address");
      require(to != address(0), "ERC20: transfer to the zero address");
      require(balanceOf(from) >= value, "You not have the ammount");

      _balances[from] = _balances[from] - value;
      _balances[to] = _balances[to] + value;
      emit Transfer(from, to, value);
  }

  /**
   * @dev Approve an address to spend another addresses' tokens.
   * @param account The address that owns the tokens.
   * @param spender The address that will spend the tokens.
   * @param value The number of tokens that can be spent.
   */
  function _approve(address account, address spender, uint256 value) internal {
    require(account != address(0), "ERC20: approve from the zero address");
    require(spender != address(0), "ERC20: approve to the zero address");

    _allowances[account][spender] = value;
    emit Approval(account, spender, value);
  }


}
