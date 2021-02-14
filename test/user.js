const User = artifacts.require('User');

contract ('User', () => {
    let user_c = null;
    before(async () => {
        user_c = await User.deployed();
    });

    //User create
    it ('Test user create successful', async () => {
        await user_c.create('user_one', 'pass1');
        const user = await user_c.read('user_one');
        assert (user[0] === 'user_one');
        assert (user[1].toNumber() === 1);
    });

    it ('Test user create unsuccessful', async () => {
        try {
            await user_c.create('user_one', 'pass2');
        } catch(e){
            assert (e.message.includes('create: invalid username'))
            return;
        }
        
        assert(false)
    });
    //User read
    it ('Test user read unsuccessful', async () => {
        try {
            await user_c.read('user_ten');
        }catch (e){
            assert (e.message.includes('read: invalid username'))
            return;
        }

        assert(false);
    });

    //Verify
    it ('Test user verify successful', async () => {
        const b = await user_c.verify('user_ten', 'pass1');
        const b2 = await user_c.verify('user_one', 'pass2');
        const b3 = await user_c.verify('user_one', 'pass1');
        
        assert(b === false);
        assert(b2 === false);
        assert(b3 === true);
    });

    //User update
    it ('Test user update successful', async () => {
        await user_c.create('user_too', 'pass2');
        await user_c.update('user_too', 'user_two');
        const user = await user_c.read('user_two');

        assert(user[0] === 'user_two');
        assert(user[1].toNumber() === 2);
    });

    it ('Test user update unsuccessful - bad new user', async () => {
        try {
            await user_c.update('user_two', 'user_one');
        }catch(e){
            assert(e.message.includes('update: new username is invalid'))
            return;
        }

        assert(false);
    });

    it ('Test user update unsuccessful - bad old user', async () => {
        try {
            await user_c.update('user_to', 'user_ten');
        }catch(e){
            assert(e.message.includes('update: invalid username'))
            return;
        }

        assert(false);
    });

    //User destroy
    it ('Test user delete successful', async () => {
        await user_c.destroy('user_two');
        try {
            await user_c.read('user_two');
        }catch(e){
            assert(e.message.includes('read: invalid username'));
            return;
        }
        assert(false);
    });

    it ('Test user delete unsuccessful', async () => {
        try {
            await user_c.destroy('user_ten');
        }catch(e){
            assert(e.message.includes('destroy: invalid username'));
            return;
        }
        assert(false);
    });
});