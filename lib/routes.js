
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
