require "srobo_ldap"

#if Rails.env.development?
  SRoboLDAP.dummy = true
#end

SRoboLDAP.key = "osadifjoqijfqwoefjoqiefjoqi"
SRoboLDAP.ldappwd = "oasifjasoidfja"


def team_to_school(groups)
    lines = open("teams.csv").read.strip.split("\n")
    
    
    groups.each do |team|
        lines.each do |line|
            puts line
            puts "team#{line.split(",")[0]}"
            puts team
            if "team#{line.split(",")[0]}".strip == team.strip
                puts "bees"
                return line.split(",")[1].strip
            end
        end
    end
    
    return nil

end
