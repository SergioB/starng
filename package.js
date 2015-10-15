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
  api.versionsFrom('1.1.0.2');

  api.use('templating');
  api.use('coffeescript');
  api.addFiles('lib/star_record.coffee');
  api.addFiles('lib/star_field.coffee');
  api.addFiles('client/create.html', 'client');
  api.addFiles('client/create.coffee', 'client');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('coffeescript');
  api.use('netforza:starng');
  api.addFiles('starng-tests.js');
  api.addFiles('test/star_record_test.coffee');
});
