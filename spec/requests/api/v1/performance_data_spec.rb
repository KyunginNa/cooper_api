RSpec.describe Api::V1::PerformanceDataController, type: :request do
  let(:user) { create(:user, email:"test@test.com") }
  let(:credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: "application/json" }.merge!(credentials) }
  let(:headers_no_credentials){ { HTTP_ACCEPT: "application/json" }}
  let(:user_another){ create(:user) }

  describe "POST /api/v1/performance_data" do
    before do
      post "/api/v1/performance_data",
           params: {
             performance_data: {
               data: { message: "Average" },
             },
           },
           headers: headers
    end

    it "returns a 200 response status" do
      expect(response).to have_http_status 200
    end

    it "successfully creates a data entry" do
      entry = PerformanceData.last
      expect(entry.data).to eq "message" => "Average"
    end
  end

  describe 'GET /api/v1/performance_data' do
    let!(:existing_entries) do
      5.times do
        create(:performance_data,
        data: { message: 'Average' },
        user: user)
      end
      3.times do
        create(:performance_data,
        data: { message: 'Bad' },
        user: user_another)
      end
    end

    before do
      get '/api/v1/performance_data', headers: headers
    end

    it 'return a 200 response status' do
      expect(response).to have_http_status 200
    end

    it 'returns a collection of performance data' do
      expect(response_json['entries'].count).to eq 5
    end

    it 'returns the performance data of the current user' do
      expect(response_json['entries']).not_to include 'Bad'
    end
  end
  describe "without user credentials information " do
    before do
      post "/api/v1/performance_data",
           params: {
             performance_data: {
               data: { message: "Average" },
             },
           },
           headers: headers_no_credentials
    end

    it "returns 401 response status" do
      expect(response).to have_http_status 401
    end

    it "returns error message" do
     expect(response_json['errors']).to eq ["You need to sign in or sign up before continuing."]
    end
  end
end

