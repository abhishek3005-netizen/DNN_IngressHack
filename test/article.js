const Article = artifacts.require('Article');


contract ('Article', () => {
    let article_c = null;
    before ( async () => {
        article_c = await Article.deployed();
    });

    //Create article
    it ('Test create article successful', async () => {
        await article_c.create_article("art1");
        await article_c.create_article("art2");
        await article_c.create_article("art3");

        const article0 = await article_c.get_article(0);
        const article1 = await article_c.get_article(1);
        const article2 = await article_c.get_article(2);

        assert (article0 === 'art3');
        assert (article1 === 'art2');
        assert (article2 === 'art1');
    });

    it ('Test create article unsuccessful', async () => {
        try {
            await article_c.create_article("art1");
        }catch(e){
            assert(e.message.includes('create_article: invalid article id'));
            return;
        }

        assert(false);
    });

    //Get article
    it ('Test get article unsuccessful', async () => {
        try {
            await article_c.get_article(3);
        } catch(e){
            assert(e.message.includes('get_articles : invalid index'));
            return;
        }

        assert(false);
    });

    //Add comment
    it ('Test add comment to article', async () => {
        await article_c.add_comment_to_article(
            'art1',
            'user_one',
            'This is a comment',
            '2021',
            '10:30 AM',
            3,
            5        
        );

        await article_c.add_comment_to_article(
            'art1',
            'user_two',
            'This is a comment',
            '2021',
            '10:30 AM',
            3,
            5,
        );
        
        await article_c.add_comment_to_article(
            'art2',
            'user_three',
            'This is a comment',
            '2021',
            '10:30 AM',
            3,
            5,
        );

        const comment1 = await article_c.get_comment(0, 'art1');
        const comment2 = await article_c.get_comment(1, 'art1');
        const comment3 = await article_c.get_comment(0, 'art2');
        
        assert(comment1[0].toNumber() === 1);
        assert(comment1[1] === 'user_one');
        assert(comment1[2] === 'This is a comment');
        assert(comment1[3] === '2021');
        assert(comment1[4] === '10:30 AM');
        assert(comment1[5].toNumber() === 3);
        assert(comment1[6].toNumber() === 5);
        
        assert(comment2[0].toNumber() === 2);
        assert(comment2[1] === 'user_two');
        assert(comment2[2] === 'This is a comment');
        assert(comment2[3] === '2021');
        assert(comment2[4] === '10:30 AM');
        assert(comment2[5].toNumber() === 3);
        assert(comment2[6].toNumber() === 5);

        assert(comment3[0].toNumber() === 3);
        assert(comment3[1] === 'user_three');
        assert(comment3[2] === 'This is a comment');
        assert(comment3[3] === '2021');
        assert(comment3[4] === '10:30 AM');
        assert(comment3[5].toNumber() === 3);
        assert(comment3[6].toNumber() === 5);
    });

    //get comment
    it ('Test get comment unsuccessful exceed max limit', async () => {
        try {
            await article_c.get_comment(3, 'art1');
        }catch (e){
            assert(e.message.includes('get_comment1 : invalid index'));
            return;
        }

        assert(false);
    });

    it ('Test get comment unsuccessful exceed max limit under 1 article', async () => {
        try {
            await article_c.get_comment(2, 'art1');
        }catch (e){
            assert(e.message.includes('get_comment2 : invalid index'));
            return;
        }

        assert(false);
    });

    //Add reply to comment
    it ('Test add reply to comment successful', async () => {
        await article_c.add_reply_to_comment (
            'art1',
            1,
            'user_four',
            'This is a comment', '2021', '11:00', 3, 5
        );

        await article_c.add_reply_to_comment (
            'art1',
            1,
            'user_five',
            'This is a comment', '2021', '11:00', 3, 5
        );

        await article_c.add_reply_to_comment (
            'art2',
            2,
            'user_six',
            'This is a comment', '2021', '11:00', 3, 5
        );

        const rep1 = await article_c.get_reply(0, 1, 'art1');
        const rep2 = await article_c.get_reply(1, 1, 'art1');
        const rep3 = await article_c.get_reply(0, 2, 'art2');

        assert(rep1[0].toNumber() === 4);
        assert(rep1[1] === 'user_four');
        assert(rep1[2] === 'This is a comment');
        assert(rep1[3] === '2021');
        assert(rep1[4] === '11:00');
        assert(rep1[5].toNumber() === 3);
        assert(rep1[6].toNumber() === 5);

        
        assert(rep2[0].toNumber() === 5);
        assert(rep2[1] === 'user_five');
        assert(rep2[2] === 'This is a comment');
        assert(rep2[3] === '2021');
        assert(rep2[4] === '11:00');
        assert(rep2[5].toNumber() === 3);
        assert(rep2[6].toNumber() === 5);

        
        assert(rep3[0].toNumber() === 6);
        assert(rep3[1] === 'user_six');
        assert(rep3[2] === 'This is a comment');
        assert(rep3[3] === '2021');
        assert(rep3[4] === '11:00');
        assert(rep3[5].toNumber() === 3);
        assert(rep3[6].toNumber() === 5);
    });

    //Test get reply
    it ('Test get comment unsuccessful exceed max limit comment', async () => {
        try {
            await article_c.get_reply(6, 1, 'art1');
        }catch (e){
            assert(e.message.includes('get_reply1 : invalid index'));
            return;
        }

        assert(false);
    });

    it ('Test get comment unsuccessful exceed max limit under 1 comment', async () => {
        try {
            await article_c.get_reply(2, 1, 'art1');
        }catch (e){
            assert(e.message.includes('get_reply2 : invalid index'));
            return;
        }

        assert(false);
    });

});