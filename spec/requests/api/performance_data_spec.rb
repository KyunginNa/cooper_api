# frozen_string_literal: true

RSpec.describe Api::PerformanceDataController, type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:user, email: 'another@user.com') }
  let(:headers) { user.create_new_auth_token }

  describe 'POST /api/performance_data' do
    context 'with valid credentials' do
      before do
        post '/api/performance_data',
             params: {
               performance_data: {
                 data: { result: 'Average' }
               }
             },
             headers: headers
      end

      it 'is expected to return a 201 response status' do
        expect(response).to have_http_status 201
      end

      it 'is expected to create a data successfully' do
        entry = PerformanceData.last
        expect(entry.data).to eq 'result' => 'Average'
      end
    end

    context 'with invalid credentials' do
      before do
        post '/api/performance_data',
             params: {
               performance_data: {
                 data: { result: 'Average' }
               }
             },
             headers: { HTTP_ACCEPT: 'application/json' }
      end

      it 'is expected to return a 401 response status' do
        expect(response).to have_http_status 401
      end

      it 'is expected to return an error message' do
        expect(response_json['errors'])
          .to eq ['You need to sign in or sign up before continuing.']
      end
    end
  end

  describe 'GET /api/performance_data' do
    context 'with valid credentials' do
      let!(:past_data) do
        3.times do
          create(:performance_data, data: { result: 'Average' }, user: user)
        end
        3.times do
          create(:performance_data, data: { result: 'Above Average' }, user: another_user)
        end
      end

      before do
        get '/api/performance_data', headers: headers
      end

      it 'is expected to return a 200 response status' do
        expect(response).to have_http_status 200
      end

      it 'is expected to return a collection of performance data' do
        expect(response_json['entries'].count).to eq 3
      end

      it 'is expected to return performance data of the current user' do
        expect(response_json['entries']).not_to include('Above')
      end
    end
  end
end
