ujamii/update-cronjobs
======================

Bash script to update the cronjobs of the current project and only those.  
`update-cronjobs.sh` takes cronjobs via the standard input in normal crontab format
and puts them in a special block without touching the already existing cronjobs in the cron file.

This allows you to build a script to automatically update your project cronjobs on deployment.  
If you are not the one deploying your application, you can just pass the system admin the name of
the script to execute to setup your cronjobs instead of having to tell him every single line that you want in your cronjobs file.  

If you put the script to update your cronjobs into your projects git / svn repository, you also suddenly have your cronjobs,
including the time they should be executed, in version control, without installing big cron-like-behaviour bundles for your framework / cms. 

Setup with composer:
--------------------

```shell
composer require ujamii/update-cronjobs
```

**Add a scripts/setupCronjobs.sh to your project:**

```shell
#!/usr/bin/env bash

PROJECT_ROOT=$(cd $(dirname $0)/..; pwd -P)
CRONJOBS_NAME='My great project'

${PROJECT_ROOT}/vendor/ujamii/update-cronjobs/update-cronjobs.sh "${CRONJOBS_NAME}" $1 <<-EOF
	@daily      ${PROJECT_ROOT}/bin/console daily-cronjob-example

	# Send mails every 5 minutes
	*/5 * * * * ${PROJECT_ROOT}/bin/console sendmails

	# ... Your other cronjobs ...
EOF
```

Now you can run `./scripts/setupCronjobs.sh` to update your project
cronjobs without touching the other cronjobs already in the crontab.

**This will result in the following crontab:**

```shell
#---- My great project cronjobs start here ----#
@daily      bin/console daily-cronjob-example

# Send mails every 5 minutes
*/5 * * * * bin/console sendmails

# ... Your other cronjobs ...
#---- My great project cronjobs end here ------#
```

To remove the whole block again, including the start and end markers,
call `./scripts/setupCronjobs.sh -r`  
This again won't affect the other cronjobs in the crontab and just
remove the project block.
