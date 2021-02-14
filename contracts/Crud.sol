pragma solidity ^0.5.0;


contract Crud {
    struct s_User {
        string name;
        string pass_hash;
        uint256 id;
    }
    
    s_User[] public users;
    uint256 nextId = 1;
    
    function create (string memory in_name, string memory in_hash) public {
        if(user_exists(in_name)){
            revert('create: invalid username');
        }else{
            users.push( s_User( {name:in_name, pass_hash:in_hash, id:nextId} ) );
            nextId++;
        }
    }
    
    function read(string memory in_name) public view returns (string memory, uint256){
        if(!user_exists(in_name)){
            revert('read: invalid username');
        }

        uint256 i = find(in_name);
        
        return (users[i].name, users[i].id);
    }
    
    function update(string memory old_user_name, string memory new_user_name) public {
        if(user_exists(new_user_name)){
            revert('update: new username is invalid');
        }

        if(!user_exists(old_user_name)){
            revert('update: invalid username');
        }
        
        uint256 i = find(old_user_name);
        users[i].name = new_user_name;
    }
    
    function destroy(string memory user_name) public {
        if(user_exists(user_name)){
            uint256 i = find(user_name);
            delete users[i];
        }else 
            revert('destroy: invalid username');
    }    


    function find (string memory name) internal view returns(uint256) {
        for(uint256 i = 0; i < users.length; i++){
            if(is_str_equal(users[i].name, name)){
                return i;
            }
        }
        
        revert('find: invalid username');
    }
    
    function user_exists (string memory name) internal view returns(bool){
        for(uint256 i = 0; i < users.length; i++){
            if(is_str_equal(users[i].name, name)){
                return true;
            }
        }
        
        return false;
    }
    
    function is_str_equal(string memory s1, string memory s2) internal pure returns(bool){
        return keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2));
    }
}
