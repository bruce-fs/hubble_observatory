require 'spec_helper'

describe 'HubbleObservatory::FsEmployee.create' do
  let(:token) { HubbleObservatory::FsEmployee.create access_token: access_token }

  context 'with a valid access token' do
    let(:access_token) { 'ya29.valid-token' }
    it 'returns the employee token' do
      expect(token).to be_a(String)
    end

    # NOTE: This test needs to be mocked because getting a real access token
    # requires a web interaction from a real user.
    before do
      expect_any_instance_of(HubbleObservatory::Request).
       to receive(:response_body).and_return data: {attributes: {jwt_token: 'a-token'}}
    end
  end

  context 'with an invalid access token' do
    let(:access_token) { 'not-a-valid-access_token' }
    it 'returns nil' do
      expect(token).to be_nil
    end
  end

  context 'in case of network error' do
    let(:access_token) { 'user@example.com' }
    HubbleObservatory::ConnectionError.errors.each do |error_class|
      it "#{error_class} raises a connection error" do
        expect(Net::HTTP).to(receive(:start).and_raise error_class.new)
        expect{token}.to raise_error HubbleObservatory::ConnectionError
      end
    end
  end
end
