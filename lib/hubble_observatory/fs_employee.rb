module HubbleObservatory
# Provides methods to interact with the Hubble API fs-employees endpoint
# @see https://hubble.fullscreen.net/api/docs#fsemployees-getting-jwt-token
  class FsEmployee
    # @return [String] the token associated with the employee
    def self.create(access_token:)
      request = HubbleObservatory::Request.new(attrs: {request_type: :get, route: "fs-employees/jwt-token", query_params: { access_token: access_token}, include_auth_header: false} )
      response= request.run_request
      if response && response[:data]
        response[:data][:attributes][:jwt_token]
      end
    end
  end
end
