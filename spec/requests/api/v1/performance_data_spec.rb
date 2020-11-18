RSpec.describe Api::V1::PerformanceDataController, type: :request do
  let(:headers) { { HTTP_ACCEPT: "application/json" } }

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
end
