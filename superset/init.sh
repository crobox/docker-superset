#!/bin/bash

set -e

if [ ! -f $SUPERSET_COMPLETE/.setup-complete ]; then
  echo "Running first time setup for Superset"

  echo "Creating admin user ${ADMIN_USERNAME}"
  cat > $SUPERSET_HOME/admin.config <<EOF
	${ADMIN_USERNAME}
	${ADMIN_FIRST_NAME}
	${ADMIN_LAST_NAME}
	${ADMIN_EMAIL}
	${ADMIN_PWD}
	${ADMIN_PWD}
EOF


  fabmanager create-admin --app superset < $SUPERSET_HOME/admin.config

  rm $SUPERSET_HOME/admin.config
  unset ADMIN_PWD

  echo "Initializing database"
  superset db upgrade

  echo "Creating default roles and permissions"
  superset init

  touch $SUPERSET_COMPLETE/.setup-complete

else
  superset db upgrade
fi

echo "Starting up Superset"
superset runserver
