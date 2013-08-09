#!/bin/sh
# Author: Christoph Galuschka <christoph.galuschka@chello.at>

t_Log "Running $0 - Postfix plain SASL test."
t_Log "Installing prerequisits"

t_InstallPackage dovecot nc

if [ $centos_ver = 6 ]
  then
  #creating backups of changed files
  cp -a /etc/postfix/main.cf /etc/postfix/main.cf_testing
  cp -a /etc/dovecot/dovecot.conf /etc/dovecot/dovecot.conf_testing

  #adding parameters to postfix
  cat >> /etc/postfix/main.cf <<EOF
smtpd_sasl_auth_enable = yes
broken_sasl_auth_clients = yes
smtpd_sasl_type = dovecot
smtpd_sasl_path = private/auth
smtpd_sasl_security_options = noanonymous

smtpd_recipient_restrictions =
      permit_mynetworks,
      permit_sasl_authenticated,
      reject_unauth_destination
EOF

  #adding parameters to dovecot
  cat >> /etc/dovecot/dovecot.conf <<EOF
service auth {
  unix_listener /var/spool/postfix/private/auth {
    mode = 0660
    user = postfix
    group = postfix
  }
}
EOF
  #restarting services
  t_ServiceControl postfix restart
  t_ServiceControl dovecot restart

  #Running test
  echo "ehlo test" | nc -w 3 localhost 25 | grep -q 'AUTH PLAIN'
  ret_val=$?
else
  t_Log 'C5 System, test not yet working, skipping'
  ret_val=0
fi
# restoring changed files
mv -f /etc/postfix/main.cf_testing /etc/postfix/main.cf
mv -f /etc/dovecot/dovecot.conf_testing /etc/dovecot/dovecot.conf

t_CheckExitStatus $ret_val
