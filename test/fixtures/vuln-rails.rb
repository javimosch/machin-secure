class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  def show
    render params[:template]
  end
  attr_accessible :name, :email
end
