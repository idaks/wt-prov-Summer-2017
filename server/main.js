import { Meteor } from 'meteor/meteor';
//import { DataSource } from '../data/DataSource';
import { Mongo } from 'meteor/mongo';

//DataSource = new Meteor.Collection('dataSource');
//Chart_Data = new Meteor.Collection('Chart_Data');

Meteor.startup(function () {
  // Load future from fibers
  var Future = Npm.require("fibers/future");
  // Load exec
  var exec = Npm.require("child_process").exec;
  var cmd = Meteor.wrapAsync(exec);
  var require = __meteor_bootstrap__.require ? __meteor_bootstrap__.require : Npm.require;
  var fs = Npm.require("fs");
  var http = require('http');



DataSource.remove();

Meteor.methods({
    'exec_Rscript': function(command) 
    {
      var res;
      res = cmd(command);
      console.log(res); 
      return res;
    },

    'read_csv' : function(file,uuid)
    {
/*      fs.readFile(file,'utf-8' ,function (err, data)
       {
          if (err) throw err;
          else
        {

            //data = Papa.parse(data, {header: true});
            //console.log(data.toString().split(",")[0]);
            //console.log(data.toString().split(",")[1]);
            //console.log(data.toString().split(",")[10]);
            //return Papa.parse(data);
            //DataSource.insert(data);
            //Chart_Data.insert(data);
            //console.log("==========================================");
            //console.log(DataSource.find({}).fetch());
        }
      })*/
       
      DataSource.remove({label: uuid});
      fs.readFileSync(file).toString().split('\n').forEach(function (line) { 
        //console.log(line);
        line=line.split(",");

        DataSource.insert({label: uuid, X: parseInt(line[0]), Y: parseFloat(line[1])});
     });
        //console.log(DataSource.find({label: uuid}).fetch());
        console.log(uuid);
    },

    imgSend : function (imageName,uuid,run_count) 
    {

        //var filePath = curr_dir + '/.images/' + imgName;
         var filePath=imageName;
        //console.log(imageName.slice(0,-15));
        //console.log(fs.readdirSync(imageName.slice(0,-15)));
        filePath=imageName.slice(0,-15)+'/'+fs.readdirSync(imageName.slice(0,-15))[2];
        //console.log(filePath);
        var data = fs.readFileSync( filePath );
       
        prediction = new Buffer(data, 'binary').toString('base64');
        prediction = "data:image/jpeg;base64,"+ prediction;
        data=fs.readFileSync(imageName.slice(0,-15)+'/'+fs.readdirSync(imageName.slice(0,-15))[5]);
        
        uncertainty= new Buffer(data, 'binary').toString('base64');
        uncertainty = "data:image/jpeg;base64,"+ uncertainty;
        
        DataSource.insert({label: uuid, img_prediction: prediction, img_uncertainty: uncertainty, run_count: run_count});
        //console.log("data:image/jpeg;base64,"+data );
        return  prediction + "---" + uncertainty ;
    },
      prov_gen : function (test_dir) 
      {
          var res;
          file = test_dir.slice(0,-8) + '/.prov_scripts/yw_generator.sh'
          filepath=test_dir + '\\paleocar_model123.png';
          command = 'C:\\msys64\\usr\\bin\\sh.exe ' + file + ' ' + filepath ;  
          console.log(command);
          
          res = cmd(command);
          //console.log(res); 
          
          filepath=test_dir + '\\paleocar_model123.png';
          data=fs.readFileSync(filepath);
          
          data= new Buffer(data, 'binary').toString('base64');
          //console.log(data);
          return  "data:image/png;base64," + data ;
          
      },
      pros_prov_img : function (graphs_dir,run_id,run_count) 
      {
        var res;
        //console.log(graphs_dir);
        folder=fs.readdirSync(graphs_dir);
        folder.forEach(function (file) {
        //someFn(item);
        filepath= graphs_dir+'\\' +file;
        data=fs.readFileSync(filepath);
        data= new Buffer(data, 'binary').toString('base64');
        data = "data:image/png;base64," + data;
        
        DataSource.insert({label: run_id,name:file,image_data:data ,run_count: run_count});

        })
        console.log ("completed");
      }
  });
});

