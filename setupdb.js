var mongoose = require('mongoose'),
    schemas = require('./schema');

mongoose.connect('mongodb://localhost/osd');

var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', init );

function init() {
    console.log("Connected! ^_^");
    var User = mongoose.model('user', schemas.UserSchema);

    var testusr = new User({
        email: Math.random() + "@random.com",
        password: Math.random() + ""
    });

    console.dir(testusr);

    testusr.save( function( err, usersaved ) {
        if( err ) {
            console.log(err);
        }
        else if( usersaved ) {
            console.log('added user ' + usersaved.id);
        }
        else {
            console.log('wut');
        }
        db.close();
    });

    console.log('done');
}

