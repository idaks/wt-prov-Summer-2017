import { Meteor } from 'meteor/meteor';
import { Mongo } from 'meteor/mongo';

//DataSource = new Meteor.Collection('dataSource');
//Chart_Data = new Meteor.Collection('Chart_Data');

Meteor.startup(function () {
  // Load future from fibers
  var Future = Npm.require("fibers/future");
  // Load exec
  var exec = Npm.require("child_process").exec;
  var cmd = Meteor.wrapAsync(exec);
  var fs = Npm.require("fs");
  
/*  var download = Npm.require('file-download');
  var data = Npm.require('fs');*/

//DataSource.remove();

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
       // console.log(uuid);
    },

    'srv_rd_pc_result': function (filedir,session_id,run_id,user_label) 
    {
        prediction_file= '/' + user_label  + '_predictions.jpg' 
        uncertainty_file= '/' + user_label + '_uncertainty.jpg'
        var data = fs.readFileSync(filedir + prediction_file);
        prediction = new Buffer(data, 'binary').toString('base64');
        prediction = "data:image/jpg;base64,"+ prediction;
        
        data = fs.readFileSync(filedir + uncertainty_file);
        uncertainty= new Buffer(data, 'binary').toString('base64');
        uncertainty = "data:image/jpg;base64,"+ uncertainty;

        DataSource.insert({label: session_id, img_prediction: prediction, img_uncertainty: uncertainty,  dir_loc:filedir, run_id: run_id});
        //Files.insert({label:session_id,})
        folder = fs.readdirSync(filedir);
        var files=[] ;
        folder.forEach(function (file) {
        //someFn(item);
        //filename= filedir+'\\' +file;
        files.push({filename:file,path: filedir.slice(72) + '\\' + file});

         // Files.insert({label: session_id, counter: run_id, filename:file, path: filedir + '\\' + file, test_dir:filedir});  
        })
        //console.log(files);
        Files.insert({label: session_id, counter: run_id, files:files, test_dir:filedir.slice(72)});  
        
    },
/*    prov_gen : function (test_dir) 
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
*/
    'insert_pros_prov_img' : function (graphs_dir,session_id,run_id) 
    {
      var res;
      //console.log("Called pros_prov_img.");
      folder=fs.readdirSync(graphs_dir);
      folder.forEach(function (file) {
      //someFn(item);
      filepath= graphs_dir+'\\' +file;
      data=fs.readFileSync(filepath);
      data= new Buffer(data, 'binary').toString('base64');
      data = "data:image/png;base64," + data;
      

      DataSource.insert({label: session_id,name:file,image_data:data, dir_loc: curr_dir, counter: run_id});

      })
      //console.log ("completed");
    }
  });
});

