class User
  require 'rest-client'
  include ActiveModel::Model
  attr_accessor :first_name, :last_name, :email, :mobile_number, :password, :password_confirmation, :username

  def create_user
    url = Rails.application.credentials.api_server
    payload = JsonWebToken.encode self.as_json
    begin
      request = RestClient.post "#{url}/user", {user: payload}, {content_type: :json, accept: :json}
      if request
        response = JSON.parse request
        response.each{|k,v| response[k] = JsonWebToken.decode(v) unless k == "status_code"}
        self.errors.add(:base, response['errors']['message']) if response['status_code'] == 400
      end
      return true
    rescue => e
      return false
    end
  end

  def self.create_session(params)
    url = Rails.application.credentials.api_server
    payload = JsonWebToken.encode({username: params[:username], password: params[:password]})
    begin
      request = RestClient.post "#{url}/user/authenticate_user", {user: payload}, {content_type: :json, accept: :json}
      if request
        response = JSON.parse request
        response.each{|k,v| response[k] = JsonWebToken.decode(v) unless k == "status_code"}
      end
      return (response["status_code"] == 200 ? response["user"] : false)
    rescue => e
      return false
    end
  end

  def self.get_user_details(user_id)
    url = Rails.application.credentials.api_server
    payload = JsonWebToken.encode({id: user_id})
    begin
      request = RestClient::Request.execute({method: :get, url: "#{url}/user", headers: {params: {user: payload}}})
      if request
        response = JSON.parse request
        response.each{|k,v| response[k] = JsonWebToken.decode(v) unless k == "status_code"}
      end
      return (response["status_code"] == 200 ? response["user"] : false)
    rescue => e
      return false
    end
  end
end