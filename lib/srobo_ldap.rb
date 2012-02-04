#!/usr/bin/ruby -w

require 'rubygems'
require 'net/ldap'
require "pp"
require "singleton"

class SRoboLDAP
    
  include Singleton
   
  class << self

    attr_accessor :key,:ldappwd

    def dummy= (arg)
        @dummy = arg
    end

    def dummy?
        @dummy || false
    end

  end

    def ldap_groups(auth_hash, user_search)
        return dummy_groups auth_hash, user_search if self.class.dummy?
        ldap = Net::LDAP.new :host => "localhost",
             :port => 389,
             :auth => {
                   :method => :simple,
                   :username => "uid=" + auth_hash["username"] + ",ou=users,o=sr",  
                   :password => auth_hash["password"]
             }
        if ldap.bind
            treebase= "ou=users,o=sr"
            filter = "memberUid=" + user_search
            ldap.search(:base => treebase, :filter => filter) do |entry|
                entry.each do |attribute, value|
                    puts attribute, value
                end
            end
        
        end
    end


    def dummy_groups(auth_hash, user_search)
        return ["team1"]
    end

    def ldap_user_details(auth_hash, user_search)
        return dummy_get_ldap_user_details auth_hash, user_search if self.class.dummy?
   
        ldap = Net::LDAP.new :host => "localhost",
             :port => 389,
             :auth => {
                   :method => :simple,
                   :username => "uid=" + auth_hash["username"] + ",ou=users,o=sr",  
                   :password => auth_hash["password"]
             }
        if ldap.bind
            treebase="ou=users,o=sr"
            filter="uid=" + user_search
            result = {}
            ldap.search(:base => treebase, :filter => filter) do |entry|
                entry.each do |attribute, values|
                    result[attribute] = values.each.next
                end
            end        

            correct_entry = ""
    
            for i in 1..21
                treebase = "ou=groups,o=sr"
                filter = "memberUid=" + user_search

                ldap.search(:base => treebase, :filter => filter) do |entry|
                    entry.each do |attribute, values|
                        if attribute == "cn" && values.next =~ "^college-"
                            correct_entry = entry
                        end

                    end 

                end
                
            end


            correct_entry.each do |attribute, values|
                if attribute == "description"
                    result["school"] = values.next
                end
            end

            return result
        else
            puts "losing"
            p ldap.get_operation_result
        end
    end

    private
    def dummy_get_ldap_user_details(auth_hash, user_search)
        return {:uidnumber=>"2096",
         :uid=>"sphippen",
         :gidnumber=>"1999",
         :homedirectory=>"/home/sphippen",
         :sn=>"phippen",
         :cn=>"sam",
         :dn=>"uid=sphippen,ou=users,o=sr",
         :loginshell=>"/bin/bash",
         :objectclass=>"inetOrgPerson",
         :mail=>"samphippen@gmail.com"}
    end

  end




