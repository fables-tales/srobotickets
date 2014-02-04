class HomeController < ApplicationController

  def capitalize_parts(thing, delim)
    parts = thing.split(delim)
    result = []
    parts.each do |part|
        letter = part[0]
        letter = letter.to_s.capitalize
        part = letter + part[1..-1]
        result << part
    end

    return result.join(delim)
  end

  def index
    respond_to do |format|
        format.html
    end
  end

  def make_qr
    string = params[:data]
    begin
        string = Base64.decode64(string)
    rescue
    end
    render :qrcode => string
  end

  def make_ticket
    @user_name = params[:user]
    @check = params[:check]
    if @check
        @details = SRoboLDAP.instance.ldap_user_details({"username" => "tickets", "password" => SRoboLDAP.ldappwd}, @user_name)
        @school  = team_to_school(SRoboLDAP.instance.ldap_groups({"username" => "tickets", "password" => SRoboLDAP.ldappwd}, @user_name))
        name = @details[:cn] + " " + @details[:sn]
        name = capitalize_parts(name, " ")
        name = capitalize_parts(name, "-")

        @person_name = name 
        @user_name   = params[:user]
        @year        = DateTime.now.year
        @hmac_string =  "#{@user_name}:#{@year}"
        
        digest = OpenSSL::Digest.new("sha256")
        key = SRoboLDAP.key
        @hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, SRoboLDAP.key, @hmac_string))
        
        respond_to do |format|
            format.html
        end
    else
        redirect_to "/"
    end
  end

end
