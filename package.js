Package.describe({
  name: 'netforza:starng',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: 'Next Generation persistence with views',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.2.1');


  api.use('ddp');
  api.use('templating');
  api.use('coffeescript');
  api.use('react');
  api.use('ccorcos:cjsx');
  api.use('momentjs:moment@2.8.4');
  api.addFiles('lib/collections.coffee');
  api.addFiles('lib/star_field.coffee');
  api.addFiles('lib/star_record.coffee');
  api.addFiles('lib/utils.coffee');
  api.addFiles('lib/validators.coffee');
  api.addFiles('client/create.html', 'client');
  api.addFiles('client/create.coffee', 'client');
  api.addFiles('client/view/text_editor.cjsx', 'client');
  api.addFiles('client/view/boolean_editor.cjsx', 'client');
  api.addFiles('client/view/password.cjsx', 'client');
  api.addFiles('client/view/label.cjsx', 'client');
  api.addFiles('client/view/elements.cjsx', 'client');

  api.addFiles('client/view/date_picker/date_picker.css', 'client');
  api.addFiles('client/view/date_picker/tiny_date_picker.js', 'client');
  api.addFiles('client/view/date_picker/react_datepicker.cjsx', 'client');
  api.addFiles('client/view/date_editor.cjsx', 'client');

  api.addFiles('client/new_object.cjsx', 'client');
  api.addFiles('client/edit_object.cjsx', 'client');
  api.addFiles('server/methods.coffee', 'server');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('coffeescript');
  api.use('netforza:starng');
  api.addFiles('starng-tests.js');
  api.addFiles('test/star_record_test.coffee');
});
