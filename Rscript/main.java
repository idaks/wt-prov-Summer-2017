import { Template } from 'meteor/templating';
import { ReactiveVar } from 'meteor/reactive-var';
import { GoogleMaps } from 'meteor/dburles:google-maps';
import { Meteor } from 'meteor/meteor';
import './main.html';




 
 // @begin paleocar_web-app_data_flow 
 // @in user_map_marker_pos  @desc Coordinates of location for reconstruction of paleoclimate. 
 // @in user_prediction_years @desc Prediction years for reconstruction of paleoclimate. 
 
 // @param calibration_years @desc period for calibrating the information for predicting the climate. 
 // @param label @desc a user label
 // @param verbose @desc set to true for writing output to a logfile.
 // @param min_width
 // @param historical_precip_data 
 // @param tree_ring_data



 // @out prediction_graph
 // @out paleocar_models 
 // @out prediction_model  
 // @out paleocar_log_file 
 // @out uncertainty_model 
 // @out uncertainty_graph 
 
 
// @begin get_client_data @desc get the data from the user and generate the client side metadata for storing the information of each run.
// @in user_map_marker_pos 
// @in user_prediction_years 


// @out session_id 
// @out run_id 
// @out coordinates 
// @out prediction_years 
 
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
const show_pros_prov_img = new ReactiveVar(false);
const show_tree_ring_data = new ReactiveVar(false);

const display_image = new ReactiveVar('');
const wait_img = new ReactiveVar(false);

//const res_img1 = new ReactiveVar('');
const prediction_years = new ReactiveVar("1850:2000");

//Generate a unique Id which will also be a output directoru for the result.
var uuid = Meteor.uuid();

//Generate run counter for each run. 
var run_id = 0; 

var session_id;

var user_label = "GRCA";
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

var calibration_yearss="1924:1983";



Meteor.startup(function() { 
  session_id = uuid.slice(0,8); 
  img_dir = curr_dir + '\\.prov_scripts\\graphs';

/*  if(DataSource.find({label:run_id,run_id:0}).count() < 1 )
  {
    //alert(run_id);
    Meteor.call('insert_pros_prov_img',img_dir,run_id,run_id,function(error, result)
      {
        if (error) 
        {
          alert(error);
        } 
        else 
        {
           //alert("Called Meteor method");
        }

      });
  }
*/  
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

    coord_bound= bound_region();
    // bound_region(37.2309,-108);
    //alert(coord_bound);
     map: new google.maps.LatLng(latLng);
     
     g_Lat.set(latLng.lat);
     g_Lng.set(latLng.lng);
    

    // Add the marker to display the location of the marker. 
    // make the marker draggable 
    // position the marker to the 
    // Used animation to drop the marker. 
    
 

    // @end get_client_data
    
	
	// @begin acccess_static_server_files @desc the static files available and required for execution of PaleoCAR on the server.
    
    // @param historical_precip_data 
    // @param tree_ring_data 
    
    // @out prism_data @uri file:data/112W36N.nc @desc file containing the precipitation values for the particular region.
    // @out itrdb @uri file:data/itrdb.rda @desc tree ring chronologies database
    // @end acccess_static_server_files
 
 
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
    // alert(bound.west);
    // alert(bound.south);
    // alert(event.latLng.lng());

    if(!(
          (bound.north > parseFloat(event.latLng.lat()) ) &&  
          (bound.south < parseFloat(event.latLng.lat()) ) &&
          (bound.west  < parseFloat(event.latLng.lng()) ) && 
          (bound.east  > parseFloat(event.latLng.lng()) )
      ))       
    {
        alert("Cannot Choose a point outside the polygon. Resetting the marker.");
        marker.setPosition(latLng);
        marker.setAnimation(google.maps.Animation.DROP);
        
        g_Lat.set(latLng.lat());
        g_Lng.set(latLng.lng());
        

        // Resetting the values for image result to hide.
        show_res_img.set(false);    
/*        // Resetting the values for result of the table to hide. 
        show_res_tbl.set(false);*/
        // Resetting the values for prospective images to hide. 
        show_pros_prov_img.set(false);
    }
    else 
    {
      
      g_Lat.set(event.latLng.lat());
      g_Lng.set(event.latLng.lng());

      //alert(g_Lng + g_Lat);
      //show_res_img.set(false);    
      show_res_tbl.set(false);
    }
    });

    function polygon(coord){
          //coord = r_coord.get().split(" ");
          //alert("ors");
          //alert(coord);
          bound =
              {
                north: parseFloat(coord[3]),
                south: parseFloat(coord[2]),
                east:  parseFloat(coord[1]),
                west:  parseFloat(coord[0])
              };

          rectangle: new google.maps.Rectangle({
          strokeColor: '#FF01230',
          strokeOpacity: 0.8,
          strokeWeight: 2,
          fillColor: '#FF0015',
          fillOpacity: 0.35,
          map:map.instance,
          bounds: bound

          });

          return bound;
               
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
    //session_id = uuid.slice(0,8); 
    return session_id;
  }

});

    // @begin extract_prism_data @desc get the prism data file on the server with precipitation values and extract the data for the input coordinates and save as a csv file.
    // @in coordinates @desc Coordinates of location for reconstruction of paleoclimate. 
    // @in session_id
    // @in run_id 
    // @in prism_data
                          
Template.btn_exec_paleocar.events({

  'click .exec_PaleoCar':function(){

  //Counter for maintaing the execution run.
    run_id = run_id + 1 ;
   //alert(run_id);
  // start the Progress bar
    NProgress.start();

    // Display image for the provenance 
    wait_img.set(true);

    // hide the prospective provenance     
    show_pros_prov_img.set(false);
  
    // sEt the test directory
    test_dir= curr_dir + '.output\\' + session_id + '\\Run_output_'+ run_id ;
  // Before execution of paleocar generate the prism data. 
    //alert(test_dir);  
 
 

    

  var cmd_prism_data = 'Rscript  '+ curr_dir + 'Rscript\\extract_prism_data.R ' + curr_dir + ' ' +  g_Lat.get() + ' ' + g_Lng.get() +' ' + in_file_name_ext  + ' '  + out_file_prism_data  + ' ' + test_dir ;
  
  //alert(cmd_prism_data);
  // Display and Start loading of the Prgoress Bar. 
  Meteor.call('exec_Rscript',cmd_prism_data,curr_dir,function(error, result)
    {
      if (error) 
      {
        alert(error);
      } 
      else 
      {
        display_image.set(result);
      }
    });
    
	// @out prism_data_for_coordinates @uri file:.output/{session_id}/{run_id}/112W36N.csv @desc file containing the precipitation values for the selected region.  @desc file containing the precipitation values for the selected region.
	//    @end extract_prism_data
 
 
    // @begin exec_paleocar @desc execute paleocar for reconstruction of paleoclimate of the study region. Generate the timeseries graphs, and  paleocar models of paleoclimatic reconstruction. 
    // @in prediction_years @desc period for reconstruction of the paleoclimate using paleocar. 
    // @in prism_data_for_coordinates
    // @in itrdb 
    // @param calibration_years  @desc period for calibrating the information for predicting the climate. 
    // @param label @desc user entered label for the study region. 
    // @param min_width 
    // @param verbose 
    session_id = session_id
	run_id = run_id
    
    // @out pred_model @as prediction_model @uri file:.output/{session_id}/{run_id}/{label}_prediction.Rds 
    // @out pred_plot @as prediction_graph  @uri file:.output/{session_id}/{run_id}/{label}_predictions.jpg
    // @out uncertain_model @as uncertainty_model @uri file:.output/{session_id}/{run_id}/{label}_uncertainty.Rds
    // @out pal_model @as paleocar_models   @uri file:.output/{session_id}/{run_id}/{label}_model.Rds 
    // @out uncertain_plot @as uncertainty_graph  @uri file:.output/{session_id}/{run_id}/{label}_uncertainty.jpg
    // @out log_file @as paleocar_log_file @uri file:.output/{session_id}/{run_id}/paleocar_model_log.txt  
    // @end exec_paleocar
 
  // Execute  PaleoCAr for the Vector region for now. 
  var cmd_exe_paleocar = 'Rscript  '+ curr_dir + 'Rscript\\exec_paleocar.R ' + curr_dir + ' ' + 
                           test_dir + ' ' +  out_file_prism_data + ' ' + user_label + ' ' +  calibration_yearss + ' ' +
                           prediction_years.get() + ' '+ 'T'+ ' ' + "v" ;
  
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
   
    Meteor.call('srv_rd_pc_result',test_dir,session_id,run_id,user_label,function(error, result)
    {
      if (error) 
      {
        alert(error);
      } 
      else 
      {
        //console.log(result);
        NProgress.done();

        // hide the image of Loading. 
        wait_img.set(false);

        // now load the output of the result.
        show_res_img.set(true);  
      }

    });


   }
});

// code for displaying the Result images and hiding it when the execute button is not submitted. 

Template.res_img.onCreated(function(){
    //show_res_img.set(false);
});



Template.res_img.helpers({
  show_res_img: function(){
    return show_res_img.get();
  },
  show_image: function()
  {
    return DataSource.find({label:session_id});
  },
  files: function () {
    //alert(run_id);
    return Files.find({label: session_id});
  //return Files.find();
  }
});


Template.btn_show_provenance.events({
'click .dis_prov_img': function()
  {
    show_pros_prov_img.set(true);
  }

})

Template.provenance.onCreated(function()
{
  
})

Template.provenance.helpers({
  
  dis_session_id:function()
  {
    return session_id;
  },
  show_prov_img: function()
  {
    return DataSource.find({label:session_id,run_id: run_id });
  },
  show_dir_struture: function()
  { 
    console.log(Dir_Structure.find({parent: session_id }).fetch());
    return Dir_Structure.find({parent: session_id +'_' + run_id });
    //return "Pratik";
  }

})


Template.execpaleocar.helpers({
  wait_img:function()
  {
    //alert(wait_img.get());
    return wait_img.get();
  },
  prediction_years:function()
  {
    return prediction_years.get();
  },
  show_pros_prov_img:function()
  {
    return show_pros_prov_img.get();
  },
  display_image:function()
  {
    return display_image.get();
  }
})

Template.execpaleocar.events({
  'input #prediction_year': function (event) {
    prediction_years.set(Template.instance().$("#prediction_year").val());
  }
})



Template.fileList.helpers({
result_data: function () 
{
    //alert(run_id);
    return Files.find({label: session_id});
  //return Files.find();
},
show_res_img:function()
{
  return show_res_img.get();
},
show_tree_ring_data:function()
{
  //alert(show_tree_ring_data.get());
  return show_tree_ring_data.get();
},
show_tree_ring_files:function()
{
  return Tree_Ring_Files.find({label:session_id});
}
});

Template.fileList.events({

  'click .button': function(event)
  { 
    var calibration_years =  Template.instance().$("#chronological_year").val() ; 
    var output_file =  calibration_years + "_tree_ring_data.csv" ;
    //alert(output_file)
   
    var cmd_get_tree_ring_val = 'Rscript  '+ curr_dir + 'Rscript\\get_tree_ring_values.R ' + test_dir + 
    ' ' +   test_dir + '\\' + user_label+'_model.Rds' + ' ' + calibration_years +' ' + output_file ; 

    Meteor.call('exec_Rscript',cmd_get_tree_ring_val,function(error, result)
    {
      if (error) 
      {
        alert("Kindly check the year entered. It should be between 1924 and 1983.");
      } 
      else 
      {
        show_tree_ring_data.set(true);
        Tree_Ring_Files.insert({label:session_id,filename:output_file, year:calibration_years, path:test_dir.slice(72) + '\\' + output_file});
      }
    });
  },
  'input #chronological_year': function (event) 
  {
  }
})

// @end paleocar_web-app_data_flow 


