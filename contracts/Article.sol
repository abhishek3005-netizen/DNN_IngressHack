pragma solidity ^0.5.0;


contract Article {
    struct s_Com {
        uint256 c_id;
        string a_id;
        
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
    }
    
    uint256 com_nextId = 1;
    s_Com[] comments;
    s_Article[] articles;
    
    
    function create_article (string memory a_id) public {
        if(article_exists(a_id)){
            revert('create_article: invalid article id');
        }
        
        s_Article memory art;
        art.a_id = a_id;
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
        

        if(index >= comments.length)
            revert('get_comment1 : invalid index');
        
        uint256 k = 0;
        uint256 cur_index = 0;
        for(uint256 i = 0; i < comments.length; i++){

            if(comments[i].parent_cid == 0 && is_str_equal(comments[i].a_id, a_id)){
                cur_index = i;
                k++;
            }

            if(k - 1 == index) break;
        }
        
        if(k - 1 != index)
            revert('get_comment2 : invalid index');
        
        s_Com memory com = comments[cur_index];
        return (com.c_id, com.user_name, com.text, com.date, com.time, com.upvotes, com.downvotes);
    }
    
    function get_reply(uint256 index, uint256 p_c_id, string memory a_id) public view returns
    (uint256 c_id, string memory user_name, string memory text, string memory date, string memory time, uint256 upvotes, uint256 downvotes){
        //uint256 num_rep = num_replies_to_com(p_c_id, a_id);
        
        if(index >= comments.length){
            revert('get_reply1 : invalid index');
        }
        

        uint256 k = 0;
        uint256 cur_index = 0;
        for(uint256 i = 0; i < comments.length; i++){

            if(comments[i].parent_cid == p_c_id && is_str_equal(comments[i].a_id, a_id)){
                k++;
                cur_index = i;
            }
            if(k - 1 == index) break;
        }

        if(k - 1 != index)
            revert('get_reply2 : invalid index');

        s_Com memory com = comments[cur_index];
        return (com.c_id, com.user_name, com.text, com.date, com.time, com.upvotes, com.downvotes);
    }

    function add_comment_to_article(string memory a_id,
                                    string memory user_name,
                                    string memory text,
                                    string memory date,
                                    string memory time,
                                    uint256 upvotes, 
                                    uint256 downvotes) public {

        s_Com memory com = create_comment(com_nextId, a_id, 0, user_name, text, date, time, upvotes, downvotes);
        comments.push(com);
        com_nextId++;
    }
    
    
    function add_reply_to_comment(string memory a_id,
                                  uint256 c_id,
                                  string memory user_name,
                                  string memory text,
                                  string memory date,
                                  string memory time,
                                  uint256 upvotes, 
                                  uint256 downvotes) public {
        
        s_Com memory rep = create_comment(com_nextId, a_id, c_id, user_name, text, date, time, upvotes, downvotes);
        comments.push(rep);
        com_nextId++;
    }
    
    
    function create_comment(uint256 c_id,
                            string memory a_id,
                            uint256 parent_cid,
                            string memory user_name,
                            string memory text,
                            string memory date,
                            string memory time,
                            uint256 upvotes, 
                            uint256 downvotes) internal pure returns(s_Com memory){
    
        s_Com memory com;
        com.c_id = c_id;
        com.a_id = a_id;
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
    
    function find_comment(uint256 c_id) internal view returns (uint256){
        for(uint256 i = 0; i < comments.length; i++){
            if(comments[i].c_id == c_id){
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
    
    function num_replies_to_com(uint256 p_c_id, string memory a_id) internal view returns(uint256){
        uint256 count = 0;
        for(uint256 i = 0; i < comments.length; i++){
            if(comments[i].parent_cid == p_c_id && is_str_equal(comments[i].a_id, a_id)){
                count++;
            }
        }
        
        return count;
    }
    
    function is_str_equal(string memory s1, string memory s2) internal pure returns(bool){
        return keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2));
    }
}