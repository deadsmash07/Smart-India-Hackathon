const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const shovel= new Schema({
    id:{
        type:String,
        required:true
    },
    name: {
        type: String,
        required: true
    },
    size: {
        type: Number,
        required: true
    },
    worker: {
        type: Schema.Types.ObjectId,
        ref: 'User'
    },
    status: {
        type: Boolean,
        required: true,
        default: false
    }
});
module.exports = mongoose.model('Shovel', shovel);