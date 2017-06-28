DataSource = new Meteor.Collection('dataSource');
Chart_Data = new Meteor.Collection('Chart_Data');
Run_Log    = new Mongo.Collection('Run_Log');
Dir_Structure = new Mongo.Collection('Dir_Structure');

//Chart_Data.remove({});

/*if(Meteor.isClient) {
  Meteor.startup(function() {
    if (!DataSource.find({}).fetch().length) {
      DataSource.insert({x: 1924, value: 6371664});
      DataSource.insert({x: 'Discount Stores', value: 7216301});
      DataSource.insert({x: 'Men\'s/Women\'s Stores', value: 1486621});
      DataSource.insert({x: 'Juvenile Specialty Stores', value: 786622});
      DataSource.insert({x: 'All other outlets', value: 900000});
    }
  });
}*/