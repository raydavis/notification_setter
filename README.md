# Notification Setter

Loops through 'uid' (SIS User ID) and 'email' columns in a user generated CSV report, and connects to the [Canvas-LMS](https://github.com/instructure/canvas-lms) API for [Notification Preferences](https://canvas.instructure.com/doc/api/notification_preferences.html) to update the 'Conversations Created By Me' and 'Announcement Created By You' settings to ASAP (defined as 'immediately' in API for frequency).

# Usage

## First Time Use

The first time you use this script, you will need to install required gems using Bundler.

	$ bundle install

Next you will need to copy the contents of config.example.yml into a new file named config.yml. To properly authenticate with the
Canvas LMS system you are using this script with, you'll need to [generate an API access token](https://guides.instructure.com/m/4214/l/40399-how-do-i-obtain-an-api-access-token) for your user account and then insert that token into the 'config.yml' file as the 'admin_token'.

## Providing CSV Report

Unfortunately Canvas does not include both a user ID and email address in the exports reports it provides, as the contact address for the user is stored separate of the user account itself in a one-to-many (user-to-email) relationship.

Luckily the API supports the specification of an SIS User ID in the URL, rather than a Canvas User ID, so it's possible to obtain a
report containing SIS User IDs and email addresses from our own SIS systems and use this to specify the mass user update of preferences. In the case of UC Berkeley, the SIS User IDs are the UIDs provided by the CalNet LDAP paired with the official email address on file that is maintained via a daily user profile sync in the Canvas system.

Simply put a CSV file with the 'uid' and 'email' columns inside of the 'reports' folder. This file must include the column names
in the first row (header row). Once this file is placed in the 'reports' folder, edit the config.yml file so that the 'report_filename' value reflects the name of the report file that you've placed in the directory.

## Admin User with Masquerading Permissions

Because the Canvas API for Notification Preferences is limited to only update the current [user](https://canvas.instructure.com/doc/api/notification_preferences.html#method.notification_preferences.update) (self), this tool must use an option to [masquerade as another user](https://canvas.instructure.com/doc/api/file.masquerading.html) when performing the update.

For this tool to work properly, you must use an admin_token in your config.yml for a user that has the "Become other users" permission, likely an Account Admin user.

## Run the primary script

From the command line simply run the 'main.rb' script.

	$ ./main.rb
