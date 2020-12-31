RSpec.describe User, type: :model do
  describe 'Factory Bot' do
    it 'is expected to have valid Factory' do
      expect(create(:user)).to be_valid
    end
  end

  describe 'Database table' do
    it { is_expected.to have_db_column :encrypted_password }
    it { is_expected.to have_db_column :email }
    it { is_expected.to have_db_column :tokens }
  end

  describe 'Relations' do
    it { is_expected.to have_many :performance_data }
  end
end
