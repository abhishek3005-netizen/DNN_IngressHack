pragma solidity ^0.5.0;


contract Article {
    struct s_Com {
        uint256 c_id;
        
        string user_name;
        string text;
        string date;
        string time;
        
        uint256 upvotes;
        uint256 downvotes;
        
        uint256 parent_cid;
    }
    
    struct s_Article {
        string a_id;
        uint256 com_nextId;
        s_Com[] comments;
    }
    
    s_Article[] articles;
    
    
    function create_article (string memory a_id) public {
        if(article_exists(a_id)){
            revert('create_article: invalid article id');
        }
        
        s_Article memory art;
        art.a_id = a_id;
        art.com_nextId = 1;
        articles.push(art);
    }
    
    function get_article(uint256 index) public view returns(string memory) {
        if(index >= articles.length){
            revert('get_articles : invalid index');
        }
        
        return articles[articles.length - 1 - index].a_id;
    }
    
    function get_comment(uint256 index, string memory a_id) public view returns 
    (uint256 c_id, string memory user_name, string memory text, string memory date, string memory time, uint256 upvotes, uint256 downvotes){
        
        uint256 j = find_article(a_id);
        
        s_Com[] memory coms = articles[j].comments;
        
        if(index >= coms.length)
            revert('get_comment : invalid index');
        
        uint256 k = 0;
        uint256 i = 0;
        for(i = 0; i < coms.length; i++){
            if(k == index) break;
            if(coms[i].parent_cid == 0) k++;
        }
        
        if(k != index)
            revert('get_comment : invalid index');
        
        s_Com memory com = coms[i];
        return (com.c_id, com.user_name, com.text, com.date, com.time, com.upvotes, com.downvotes);
    }
    
    function get_reply(uint256 index, uint256 p_c_id, string memory a_id) public view returns
    (uint256 c_id, string memory user_name, string memory text, string memory date, string memory time, uint256 upvotes, uint256 downvotes){
        uint256 j = find_article(a_id);
        uint256 num_rep = num_replies_to_com(articles[j].comments, p_c_id);
        
        if(index >= num_rep){
            revert('get_reply : invalid reply');
        }
        
        s_Com[] memory coms = articles[j].comments;
        uint256 k = 0;
        uint256 i = 0;
        for(i = 0; i <= coms.length; i++){
            if(k == index) break;
            if(coms[i].parent_cid == p_c_id)
                k++;
        }
    
        s_Com memory com = coms[i];
        return (com.c_id, com.user_name, com.text, com.date, com.time, com.upvotes, com.downvotes);
    }

    function add_comment_to_article(string memory a_id,
                                    string memory user_name,
                                    string memory text,
                                    string memory date,
                                    string memory time,
                                    uint256 upvotes, 
                                    uint256 downvotes) public {
        
        uint256 i = find_article(a_id); 
        s_Com memory com = create_comment(articles[i].com_nextId, 0, user_name, text, date, time, upvotes, downvotes);
        articles[i].comments.push(com);
        articles[i].com_nextId++;
    }
    
    
    function add_reply_to_comment(string memory a_id,
                                  uint256 c_id,
                                  string memory user_name,
                                  string memory text,
                                  string memory date,
                                  string memory time,
                                  uint256 upvotes, 
                                  uint256 downvotes) public {
        uint256 i = find_article(a_id);
        uint256 j = find_comment(c_id, articles[i].comments);
        
        s_Com memory rep = create_comment(articles[i].com_nextId, c_id, user_name, text, date, time, upvotes, downvotes);
        articles[i].comments.push(rep);
    }
    
    
    function create_comment(uint256 c_id,
                            uint256 parent_cid,
                            string memory user_name,
                            string memory text,
                            string memory date,
                            string memory time,
                            uint256 upvotes, 
                            uint256 downvotes) internal view returns(s_Com memory){
    
        s_Com memory com;
        com.c_id = c_id;
        com.parent_cid = parent_cid;
        com.user_name = user_name;
        com.text = text;
        com.date = date;
        com.time = time;
        com.upvotes = upvotes;
        com.downvotes = downvotes;
        
        return com;
    }
    
    function find_article (string memory a_id) internal view returns(uint256) {
        for(uint256 i = 0; i < articles.length; i++){
            if(is_str_equal(articles[i].a_id, a_id)){
                return i;
            }
        }
        
        revert('find article: invalid article id');
    }
    
    function find_comment(uint256 c_id, s_Com[] memory coms) internal view returns (uint256){
        for(uint256 i = 0; i < coms.length; i++){
            if(coms[i].c_id == c_id){
                return i;
            }
        }
        
        revert('find comment: invalid comment id');
    }
    
    function article_exists (string memory a_id) internal view returns(bool){
        for(uint256 i = 0; i < articles.length; i++){
            if(is_str_equal(articles[i].a_id, a_id)){
                return true;
            }
        }
        
        return false;
    }
    
    function num_replies_to_com(s_Com[] memory coms, uint256 p_c_id) internal view returns(uint256){
        uint256 count;
        for(uint256 i = coms.length - 1; i >= 1; i++){
            if(coms[i].parent_cid == p_c_id){
                count++;
            }
        }
        
        return count;
    }
    
    function is_str_equal(string memory s1, string memory s2) internal pure returns(bool){
        return keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2));
    }
}