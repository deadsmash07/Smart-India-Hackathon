const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const querySchema = new Schema({
    user:{
        type:Schema.Types.ObjectId,
        ref:'users'
    },
    description:{
        type:String,
        required:true
    },
    status:{
        type:Boolean,
        default:false
    },
    response:{
        type:String,
        default:""
    }
});
module.exports = mongoose.model('queries', querySchema);