import { Template } from 'meteor/templating';
import { ReactiveVar } from 'meteor/reactive-var';
import { GoogleMaps } from 'meteor/dburles:google-maps';
//import { Mongo } from 'meteor/mongo';
import { Meteor } from 'meteor/meteor';
import { Chart }from 'chart.js';
//import { DataSource } from '../data/DataSource';
import './main.html';


var map_zoom=6; 

// global reactive var for storing lat and long values. 
const g_Lat = new ReactiveVar('');
const g_Lng = new ReactiveVar('');
const r_coord = new ReactiveVar('');


// Reactive variable for hiding the result images 
// On click event of the button btn_exe_palecoar
// it will be set to true.
//Template.show_res_img.someReactiveVar = new ReactiveVar(false);

const show_res_img = new ReactiveVar(false);
const show_res_tbl = new ReactiveVar(false);
const show_prov_img_data = new ReactiveVar('');
const res_img1 = new ReactiveVar('');

//Generate a unique Id which will also be a output directoru for the result.
var uuid = Meteor.uuid();

//Generate run counter for each run. 
var run_count = 0; 

var run_id;

// The current Project Directory,

var curr_dir = "D:\\Study\\Internship\\WT_PaleoCar_2017\\meteor_example\\wt-prov-summer-2017\\";


// variable for stoing the file name being passed to the
// R-script for getting the boundary
var in_file_name_ext="112W36N.nc";

var out_file_prism_data="112W36N.csv";

// Variable for executing the paleocar Output
var in_file_name_paleocar= "exe_paleocar.R";

// test directory
var test_dir='';

// Calibration year 

var calibration_years="1924:1983";

// Prediction year
var prediction_years="1:2000";
 

Meteor.startup(function() {  
  GoogleMaps.load({key: "AIzaSyCaNgs-oPrH7UbrrFq_jt-BPlL3c6orer8"});
});


  // Helper template for creating the map and setting the 
  // current location to the current location of the user.


Template.map.helpers({  
  mapOptions: function() {
    if (GoogleMaps.loaded({key: "AIzaSyCaNgs-oPrH7UbrrFq_jt-BPlL3c6orer8"})) {
      return {
        //center: new google.maps.LatLng(Geolocation.latLng().lat,Geolocation.latLng().lng),
        center: new google.maps.LatLng(35,-112),
        zoom: map_zoom,
        mapTypeId: 'terrain'
      };
    }
  },
});


Template.map.onCreated(function() {  
  var marker,latLng ;
  var map, rectangle;


  // Get the map ready for display 

  GoogleMaps.ready('map', function(map)
  {
    var map, latLng;

    // position the marker to the current location for now 
    latLng = {lat: 36.5, lng: -111.5};


    //Display all the South-West US regions. 
    // With the boundary and later post a validation 
    // check which makes the user to click in that boundary only. 

     bound_region();
    // bound_region(37.2309,-108);
  
     map: new google.maps.LatLng(latLng);
     
     g_Lat.set(latLng.lat);
     g_Lng.set(latLng.lng);
    

    // Add the marker to display the location of the marker. 
    // make the marker draggable 
    // position the marker to the 
    // Used animation to drop the marker. 
    marker = new google.maps.Marker
    ({
      position: latLng,
      map: map.instance,
      draggable: true,
      animation: google.maps.Animation.DROP
    });

    
    // Adding a listener for the marker drage event. 
    // Will get the current lat and long values of the marker 
    // This would be used for running the paleocar 

 
    marker.addListener('dragend', function(event){
    
    // For ebugging purpose
    // alert the marked location for now.
    //alert(event.latLng);

    g_Lat.set(event.latLng.lat());
    g_Lng.set(event.latLng.lng());
    //alert(g_Lng + g_Lat);

    // Check whether the marker falls in the South-West Region or not?
    // if yes, then execute PaleoCar
    // If not, raise an error
     //gm_geom.poly.containsLocation(event.latLng, rectangle);

      show_res_img.set(false);    
      show_res_tbl.set(false);
    });

    function polygon(coord){
          //coord = r_coord.get().split(" ");
          //alert("ors");
          //alert(coord);
      
          rectangle: new google.maps.Rectangle({
          strokeColor: '#FF01230',
          strokeOpacity: 0.8,
          strokeWeight: 2,
          fillColor: '#FF0015',
          fillOpacity: 0.35,
          map:map.instance,
          bounds: 
              {
                north: parseFloat(coord[3]),
                south: parseFloat(coord[2]),
                east:  parseFloat(coord[1]),
                west:  parseFloat(coord[0])
              }
          });

     }

    // Function for creating the boundary region
    // AS of now simply created the boundary, 
    // but some more logic would be required to display the correct thing.
    function bound_region()
    {
      var cmd_ras_ext = 'Rscript  '+ curr_dir + 'Rscript\\raster_extent.R ' +  curr_dir + ' ' + in_file_name_ext ;
      //alert(cmd_ras_ext);
      Meteor.call('exec_Rscript', cmd_ras_ext, function(error, result) {
          if (error) {
            return console.log(error);
          } else 
          {
            polygon(result.split(" "));
            //return console.log(result);
          }
        });     
      }
   });
});


// Template for setting the lat/long values on the labels 
// using the current marker postions. 

Template.pop_lat_lng.helpers({
  txt_lat:function(){
    //alert(g_lat)
    return g_Lat.get() ;
  },
  txt_lng:function(){
    return g_Lng.get();
  },
  txt_ROI:function(){
    return "Grand Canyon National Park."
  },
  txt_runid:function()
  { 
    run_id = uuid.slice(0,8); 
    return run_id;
  }

});



Template.btn_exec_paleocar.events({

  'click .exec_PaleoCar':function(){
    // start the Progress bar
     NProgress.start();

  
  // Before execution of paleocar generate the prism data. 
  //alert(g_Lat.get() + g_Lng.get());  
  var cmd_prism_data = 'Rscript  '+ curr_dir + 'Rscript\\prism_data.R ' + curr_dir + ' ' +  g_Lat.get() + ' ' + g_Lng.get() +' ' + in_file_name_ext  + ' ' + out_file_prism_data ;
  
  
  // Display and Start loading of the Prgoress Bar. 
  Meteor.call('exec_Rscript',cmd_prism_data,function(error, result)
    {
      if (error) 
      {
        alert(error);
      } 
      else 
      {

      }
    });

  //Counter for maintaing the execution run. 
  
  run_count = run_count + 1 ;

  //Test directory for storing the information of every run.
    test_dir= curr_dir + '.output\\' + run_id ;
    Dir_Structure.insert({ id: run_id , name:run_id, path: test_dir, parent:null});
    
    
    test_dir= curr_dir + '.output\\' + run_id + '\\Run_output_'+ run_count;
    Dir_Structure.insert({ id: run_id +'_'+ run_count, name: 'Run_output_' + run_count, counter:run_count, path: test_dir, parent:run_id});

    test_dir= curr_dir + '.output\\' + run_id + '\\Run_output_'+ run_count + '\\PaleoCar_Results'; 
    Dir_Structure.insert({id: run_id +'_'+ run_count +'_PO', name: "PaleoCar_Results", path: test_dir, parent:run_id +'_'+ run_count});
    
    test_dir= curr_dir + '.output\\' + run_id + '\\Run_output_'+ run_count +'\\Provenance_Output';
    Dir_Structure.insert({id: run_id +'_'+ run_count +'_PRO_OUT', name:"Provenance_Output", path:test_dir, parent:run_id +'_'+ run_count});
    
    test_dir= curr_dir + '.output\\' + run_id + '\\Run_output_'+ run_count +'\\Retro_Provenance_Output';
    Dir_Structure.insert({id: run_id +'_'+ run_count +'_REP_PRO_OUT', name:"Retro_Provenance_Output",path:test_dir,  parent:run_id +'_'+ run_count});
        
    test_dir= curr_dir + '.output\\' + run_id + '\\Run_output_'+ run_count ;
  // Execute  PaleoCAr for the Vector region for now. 
  var cmd_exe_paleocar = 'Rscript  '+ curr_dir + 'Rscript\\exec_paleocar.R ' + curr_dir + ' ' + 
                           test_dir + ' ' + out_file_prism_data + ' ' + "Grca_Region "  +  calibration_years + ' ' +
                           prediction_years + ' '+ 'T'+ ' ' + "v" ;
  
  Meteor.call('exec_Rscript',cmd_exe_paleocar,function(error, result)
    {
      if (error) 
      {
        alert(error);
      } 
      else 
      {

      }
    }); 

// Block for reading a csv file into a collection 
/*    Meteor.call('read_csv',test_dir + '/recon_vector_predict.csv',uuid,function(error, result)
    {
      if (error) 
      {
        alert(error);
      } 
      else
      { 
        Run_Log.insert(
          {
            label : uuid,
            run_time: run_count,
            DateTime: new Date().toJSON()
          });
      }
    });*/

    //console.log(DataSource.find({label:uuid}).fetch())

    var cmd_read_image= test_dir +'/predictions.jpg';

    Meteor.call('imgSend',cmd_read_image,uuid,run_count,function(error, result)
    {
      if (error) 
      {
        alert(error);
      } 
      else 
      {
        //console.log(result);
        res_img1.set(result);
       // Stop the Progress bar
        NProgress.done();

        // now load the output of the 
        show_res_img.set(true);        
        show_res_tbl.set(true);
        //alert(show_res_tbl.get())
      }

    }); 
    //alert(run_count); 

   }
});




// code for displaying the Result images and hiding it when the execute button is not submitted. 

Template.res_img.onCreated(function(){
    show_res_img.set(false);
});



Template.res_img.helpers({
  show_res_img: function(){
    //show_res_img.set(true);
    return show_res_img.get();
  },
  show_image: function()
  {
    //return res_img1.get();
    //console.log(DataSource.find({label:uuid}));
    return DataSource.find({label:uuid});
  }
});

Template.run_result_tbl.onCreated(function(){
    show_res_tbl.set(false);
});

Template.run_result_tbl.helpers({
  show_res_tbl: function()
  {
    //alert(show_res_tbl.get())
    return show_res_tbl.get();
  },
  run_log_info: function()
  { 
    return Run_Log.find({label:uuid});
  }
});


/*Template.execpaleocar.helpers({
  show_image: function()
  {
    return res_img1.get();
  }
});*/


Template.btn_show_provenance.events({
  'click .show_provenance':function()
  {
    test_dir=curr_dir + '\\.output' 
    Meteor.call('prov_gen',test_dir,function(error, result)
    {
      if (error) 
      {
        alert(error);
      } 
      else 
      {
        show_prov_img_data.set(result);
      }

    });
  }


})

Template.provenance.onCreated(function()
{

img_dir = curr_dir + '\\.prov_scripts\\graphs';
//alert(img_dir);

Meteor.call('pros_prov_img',img_dir,run_id,run_count,function(error, result)
  {
    if (error) 
    {
      alert(error);
    } 
    else 
    {
    }

  });
})

Template.provenance.helpers({
  dis_run_id:function()
  {
    return run_id; 
  },
  show_prov_img: function()
  {
    return DataSource.find({label:run_id,run_count: run_count });
  },
  show_dir_struture: function()
  { 
    console.log(Dir_Structure.find({parent: run_id }).fetch());
    return Dir_Structure.find({parent: run_id +'_' + run_count });
    //return "Pratik";
  }

})




// Adding Routing information into the code. 

Router.route('/', function () {
// render the Home template with a custom data context
this.render('home');
});
// when you navigate to "/provenance" automatically render the template named "Provenance".
Router.route('/provenance');
// when you navigate to "/execpaleocar" automatically render the template named "Execute Paleocar".
Router.route('/execpaleocar');

// when you navigate to "/contactus" automatically render the template named "ContactUs".
Router.route('/contactus');



//====================================================================================================

//============================================================================

/*let barChartOptions = {
    scales: {
        yAxes: getY()
    }
}
*/
//Template.myLineChart.helpers(chartdata());

//Template.myLineChart.helpers(ChartOptions());

/*Template.barChart.onRendered(function () {
      console.log("barChart is rendered")
      let ctx = $("#barChart");
      let myBarChart = new Chart(ctx, {
        type   : 'line',
        data   : barChartData,
        //options: barChartOptions
      });

});*/

Template.myLineChart.onRendered(function () 
{
  console.log("myLineChart is rendered")
  let ctx = $("#myLineChart");
  //var cur = DataSource.find({label:uuid},{field}).fetch();

  this.autorun(() => {

  console.log(chartdata());
  var myLineChart = new Chart(ctx, 
  {
        type: 'line',
        data: chartdata(),
//        options: getY()
        options: {
        scales: {
        yAxes: [{
            ticks: 
            {
                suggestedMin: -800,
                suggestedMax:  800
            }
        }]
      }
    } 
  });
});


function chartdata () 
{
let  chart_data = 
  {
    labels: getX(),
    datasets: 
    [{
      label: 'Mean PPT Values Vs Prediction Years',
      data: getY()
    }]
  }
//console.log(chart_data);
return chart_data;
}

function getX()
{
  var colX = [];
  var cur = DataSource.find({label:uuid}).fetch();
  
  cur.forEach(function(cat){
      colX.push([cat.X]);
      //collData.push([cat.X]);
    })
  //console.log(colX);
  return colX;
}

function getY()
  {
  var colY = [];
  var cur = DataSource.find({label:uuid}).fetch();
  
  cur.forEach(function(cat){
      colY.push([{x:cat.X,y: cat.Y}]);
      //collData.push([cat.X]);
    })
  console.log(colY);
  return colY;
  }
});

