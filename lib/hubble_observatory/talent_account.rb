module HubbleObservatory
  # Provides methods to interact with the Hubble API talent-accounts endpoint
  # @see https://hubble.fullscreen.net/api/docs#talentaccounts-create-talent-account
  class TalentAccount

    def initialize(id:)
      @hubble_uuid = id
    end

    # @return [String] the hubble uuid associated with the email
    def self.create(email:)
      request = HubbleObservatory::Request.new(attrs: {body_attrs: {email: email}, request_type: :post, auth_header: true})
      @response = request.run_request
      process_account_data(@response)
    end

    # @return [String] the hubble uuid associated with the email
    def update(email:)
      request = HubbleObservatory::Request.new(attrs: {body_attrs: {email: email}, route: "talent-accounts/#{@hubble_uuid}", request_type: :put, auth_header: true})
      @response = request.run_request
      self.class.process_account_data(@response)
    end

    private

    def self.process_account_data(account_data)
      if account_data
        extract_attribute_from_data(data: account_data, attribute: :id) || extract_uuid_from_errors(data: account_data)
      end
    end

    def self.extract_attribute_from_data(data:, attribute:)
      data.fetch(:data, {}).fetch(attribute, nil)
    end

    def self.extract_uuid_from_errors(data:)
      data.fetch(:errors, [{}])[0].fetch(:hubble_uuid, nil)
    end
  end
end
