require "srobo_ldap"

if Rails.env.development?
  SRoboLDAP.dummy = true
end

SRoboLDAP.key = "osadifjoqijfqwoefjoqiefjoqi"
SRoboLDAP.ldappwd = "oasifjasoidfja"
