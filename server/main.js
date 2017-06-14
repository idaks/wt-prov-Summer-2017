import { Meteor } from 'meteor/meteor';

//import { GoogleMaps } from 'meteor/dburles:google-maps';
//import Future from 'fibers/future';

DataSets = new Mongo.Collection('datasets');


Meteor.startup(function () {
    exec = Npm.require('child_process').exec;
    var Future = Npm.require("fibers/future");
    var future=new Future();
//    Meteor.publish('stdout', function() { return Stdout.find(); } );
//    Meteor.publish('stderr', function() { return Stderr.find(); } );

    Meteor.methods({
        exec_srv_paleoCar : function(cmd) {
        	    exec(cmd,function(error,stdout,stderr){
        	    if(error)
                {
                    console.log(error.toString());
                }
                else
                {
                    console.log(stdout.toString());
              		future.return(stdout.toString());
                }
      			});
		      	return future.wait();
        },
    });
});