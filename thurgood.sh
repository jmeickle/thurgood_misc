# Script to assist in the installation of Thurgood.
# Set the permissions on it to be executable and run it.

read -p "Download Thurgood to what directory?: " dir
if [ -e "$dir" ]; then
    echo "Sorry, there's already a file by that name here."
    exit 2
fi

echo "Creating and entering $dir..."
sudo mkdir $dir
if [ ! -d "$dir" ]; then
    echo "Sorry, making the new directory failed."
    exit 2
fi
cd $dir

echo "
Looks like we can use this directory. Let's set up our
MySQL database first, though - you'll need to enter the
MySQL root password to continue.
"

echo "
CREATE DATABASE \`ctreentry_sh_$dir\` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
GRANT ALL PRIVILEGES ON  \`ctreentry_sh_$dir\` . * TO  'ctreentry'@'localhost';
" | mysql --user="root" --password

read -p "

If there are any errors above, please go create a suitable
database manually. Record the database and user for later.

Press enter to continue when you're ready."

echo "Changing permissions..."
sudo chown -R eronarn:http .

echo "Downloading makefile from Github..."
wget https://github.com/Eronarn/Thurgood/raw/master/bootstrap.make --no-check-certificate
sleep 3
if [ ! -e "bootstrap.make" ]; then
    echo "Sorry, the bootstrap download didn't complete in time."
    exit 2
fi

echo "Running Drush Make..."
drush make --prepare-install bootstrap.make .

read -p "

If there are any errors above, please cancel this script
with Ctrl-C. Remove the database and folder that were
created before running it again.

Otheriwse, press enter to continue."

echo "Creating Backup and Migrate folders..."
mkdir -p sites/default/files/backup_migrate/manual
mkdir -p sites/default/files/backup_migrate/scheduled

echo "Changing permissions pre-install..."
sudo chown -R eronarn:http .
chmod -R 775 sites/default/files
chmod 775 sites/default/settings.php

echo "
Thurgood is ready to be installed. Please visit this address and
select \"Thurgood\" as the installation profile to be used. The
database is \"ctreentry_sh_$dir\", and the user is \"ctreentry\",
unless you created a database by hand earlier.

     http://li137-218.members.linode.com/$dir

"

read -p "
Done installing Thurgood? Let me know by pressing enter.

(There are still some post-installation tasks to take care of.)
"

echo "Changing permissions post-install..."
chmod 644 sites/default/settings.php

echo "   ...done!

Installation complete. Thanks for choosing Thurgood.

Note that this installation process doesn't handle the settings
tables that are dumped. These are necessary for the configuration
to work as expected. Import them with Backup and Migrate through
the site GUI."
