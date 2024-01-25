require('dotenv').config();
const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const bcrypt = require('bcrypt-nodejs');
const jwt = require('jsonwebtoken');
const SALT_WORK_FACTOR = process.env.SALT_WORK_FACTOR;
const UserSchema = new Schema({
    email: {
        type: String,
        unique: true,
        required: true
    },
    name:{
        type:String,
        required:true
    },
    password: {
        type: String,
        required: true
    },
    total:{
        type:Number,
        default:0,
    },
    type:{
        type:String,
        enum:['admin','worker','driver'],
        required:true
    },
    autho: {
        type: String,
    },
    lastLogin: {
        type: Date,
        default: Date.now
    },
    History: [{
        startingTime: {
            type: Date,
            default: Date.now
        },
        endTime: {
            type: Date,
            default: () => {
                let nextYear = new Date();
                nextYear.setFullYear(nextYear.getFullYear() + 1);
                return nextYear;
            }
        },
        location: {
            type: String,
            required: true
        }
    }],
    queries:[{
        _id:{
            type:Schema.Types.ObjectId,
            ref:'queries'
        }
    }],
    equipment: {
        type: Schema.Types.ObjectId,
        refPath: 'onModel',
    },
    onModel: {
        type: String,
        enum: ['dumsters', 'shovels']
    },
    latitude:{
        type:Number,
        required:true,
        default:0
    },
    longitude:{
        type:Number,
        required:true,
        default:0
    },
    reached:{
        type:Boolean,
        required:true,
        default:false
    },
    status:{
        type:Boolean,
        required:true,
        default:false
    }
});
UserSchema.pre('save', function(next) {
    var user = this;
    if (!user.isModified('password')) return next();
    bcrypt.genSalt(SALT_WORK_FACTOR, function(err, salt) {
        if (err) return next(err);
        bcrypt.hash(user.password, salt, null, function(err, hash) {
            if (err) return next(err);
            user.password = hash;
            next();
        });
    });
});

UserSchema.methods.comparePassword = function(password, cb) {
    bcrypt.compare(password, this.password, function(err, isMatch) {
        if (err) return cb(err);
        cb(null, isMatch);
    });
};
UserSchema.methods.compareAutho = function(autho, cb) {
    if(!this.autho) return cb(null, false);
    bcrypt.compare(autho, this.autho, function(err, isMatch) {
        if (err) return cb(err);
        cb(null, isMatch);
    });
};
UserSchema.methods.generateAutho = function(cb) {
    var user = this;
    var autho = jwt.sign({ _id: user._id.toHexString() }, process.env.SECRET, { expiresIn: '1800s' });
    user.autho = autho;
    return user.save()
        .then(user => {
            return user;
        })
        .catch(err => {
            throw err;
        });
}
module.exports = mongoose.model('users', UserSchema);