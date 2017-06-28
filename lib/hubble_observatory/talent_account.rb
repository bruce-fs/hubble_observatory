module HubbleObservatory
  # Provides methods to interact with the Hubble API talent-accounts endpoint
  # @see https://hubble.fullscreen.net/api/docs#talentaccounts-create-talent-account
  class TalentAccount
    def initialize(id:)
      @hubble_uuid = id
    end

    # @return [String] the hubble uuid associated with the email
    def self.create(email:)
      request = Request.new(attrs: {body_attrs: {email: email}, request_type: :post, auth_header: true})
      if request.response.is_a? Net::HTTPSuccess
        extract_hubble_uuid_from(request.response_body)
      elsif request.response.is_a? Net::HTTPUnprocessableEntity
        first_error = request.response_body[:errors][0]
        if first_error[:hubble_uuid]
          first_error[:hubble_uuid]
        end
      end
    end

    # @return [String] the hubble uuid associated with the email
    def update(email:)
      request = Request.new(attrs: {body_attrs: {email: email}, route: "talent-accounts/hubble-uuid/#{@hubble_uuid}", request_type: :patch, auth_header: true})
      if request.response.is_a? Net::HTTPSuccess
        self.class.extract_hubble_uuid_from(request.response_body)
      end
    end

    private

    def self.extract_hubble_uuid_from(data)
      data[:data][:attributes][:hubble_uuid].to_s
    end
  end
end
