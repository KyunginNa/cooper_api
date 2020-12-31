RSpec.describe PerformanceData, type: :model do
  describe 'Factory Bot' do
    it 'is expected to have valid Factory' do
      expect(create(:performance_data)).to be_valid
    end
  end

  describe 'Database table' do
    it { is_expected.to have_db_column :data }
  end

  describe 'Relations' do
    it { is_expected.to belong_to :user }
  end
end
