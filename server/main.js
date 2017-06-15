import { Meteor } from 'meteor/meteor';

Meteor.startup(function () {
  // Load future from fibers
  var Future = Npm.require("fibers/future");
  // Load exec
  var exec = Npm.require("child_process").exec;
  var  cmd = Meteor.wrapAsync(exec);
  
/*  // Server methods
  Meteor.methods({
    exec_srv_paleoCar: function (command) {
      // This method call won't return immediately, it will wait for the
      // asynchronous code to finish, so we call unblock to allow this client
      // to queue other method calls (see Meteor docs)
      //this.unblock();
      var future=new Future();
      //var command="pwd";
      exec(command,function(error,stdout,stderr){
        if(error){
          console.log(error);
          throw new Meteor.Error(500,command+" failed");
        }
        console.log(stdout.toString());
        future.return(stdout.toString());
      });
      return future.wait();
    }
  });*/

    Meteor.methods({
        'exec_Rscript': function(command) 
        {
          var res;
          res = cmd(command);
          console.log(res); 
          return res;
        }   
    });
});

/*
Meteor.startup(function () {
    exec = Npm.require('child_process').exec;
    var Future = Npm.require("fibers/future");
    var future=new Future();

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
        }
    });
});
*/
