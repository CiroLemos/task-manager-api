require 'rails_helper'

RSpec.describe 'Session API', type: :request do 
    before { host! 'api.taskmanager.test' }
    let(:user) { create(:user) }
    let!(:auth_data) { user.create_new_auth_token }
    let(:headers) do 
        {
            'Accept' => 'application/vnd.taskmanager.v2',
            'Content-Type' => Mime[:json].to_s,
            'access-token' => auth_data['access-token'],
            'uid' => auth_data['uid'],
            'client' => auth_data['client']
        }
    end

    describe 'POST /auth/sign_in' do
        before do 
            post '/auth/sign_in', params: credentials.to_json, headers: headers
        end

        context 'when credentials are correct' do 
            let(:credentials) { { email: user.email, password: '123456' } }

            it 'returns status code 200' do 
                expect(response).to have_http_status(200)
            end
    
            it 'returns the authentication data in the headers' do 
                expect(response.headers).to have_key('access-token')
                expect(response.headers).to have_key('uid')
                expect(response.headers).to have_key('client')

            end
        end


        context 'when credentials are incorrect' do 
            let(:credentials) { { email: user.email, password: '56545' } }

            it 'returns status code 401' do 
                expect(response).to have_http_status(401)
            end
    
            it 'returns the json data for the errors' do 
                expect(json_body).to have_key(:errors)
            end
        end
    end

    describe 'DELETE /sessions/:id' do 
        let(:auth_token) { user.auth_token }

        before do
          delete "/sessions/#{auth_token}", params: {}, headers: headers
        end

        it 'returns status code 204' do 
            expect(response).to have_http_status(204)
        end

        it 'changes the user auth token' do 
            expect(User.find_by(auth_token: auth_token)).to be_nil
        end

    end
end