class HomeController < ApplicationController
  def index
    respond_to do |format|
        format.html
    end
  end

  def make_qr
    string = params[:data]
    render :qrcode => string
  end

  def make_ticket
    @user_name = params[:user]
    @check = params[:check]
    if @check
        @details = SRoboLDAP.instance.ldap_user_details({"username" => "ticket-manager", "password" => SRoboLDAP.ldappwd}, @user_name)
        @school  = team_to_school(SRoboLDAP.instance.ldap_groups({"username" => "tickets", "password" => SRoboLDAP.ldappwd}, @user_name))
        @data_string = params[:user].lstrip.rstrip + ":" + @details[:cn] + ":" + @details[:sn] + ":" + @details[:mail]
        digest = OpenSSL::Digest.new("sha256")
        key = SRoboLDAP.key
        @hmac = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), SRoboLDAP.key, @data_string))
        
        respond_to do |format|
            format.html
        end
    else
        redirect_to "/"
    end
  end

end
