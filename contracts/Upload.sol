// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0  <0.9.0;

contract Upload{
//0xqwerty -- imagine address 
    struct Access{
// giving address access 
    address user; // jisko address diya h 
    bool access; // true or false 
    }
    mapping(address => string[]) value;
    mapping(address => mapping(address=> bool))ownership;
    mapping(address => Access[]) accessList;
    mapping (address=> mapping(address=>bool)) previousData;

    function add (address _user, string memory url) external{
        value[_user].push(url);
    }
    function allow(address user) external {
        ownership[msg.sender][user]=true; // access given to user
        if(previousData[msg.sender][user]){
            for (uint i=0 ; i< accessList[msg.sender].length ; i++){
                if(accessList[msg.sender][i].user==user){
                    accessList[msg.sender][i].access=true;
                }
            }
        }else{
            accessList[msg.sender].push(Access(user,true));
            previousData[msg.sender][user] = true;
        }
        accessList[msg.sender].push(Access(user,true));
    }
    function disallow(address user) public{
        ownership[msg.sender][user]=false; // revoke kiya use hatana hoga 
        for (uint i=0; i<accessList[msg.sender].length; i++){
            if(accessList[msg.sender][i].user == user){    // user access false 
                accessList[msg.sender][i].access = false;
            }
        }
    }
    function display(address _user) external view returns (string[] memory){
        require(_user == msg.sender || ownership[_user][msg.sender], " you don't have access" );
        return value[_user];
    }

    function shareAccess() public view returns (Access[] memory){
        return accessList[msg.sender];
    }
}