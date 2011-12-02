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




