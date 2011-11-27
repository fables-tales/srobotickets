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
    @data_string = params[:user]
    respond_to do |format|
        format.html
    end
  end

end
