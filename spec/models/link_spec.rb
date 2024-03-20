require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe 'URL validation' do
    it { should allow_value("https://google.com").for(:url)}

    it { should_not allow_value("plain text").for(:url)}
  end

  describe '.gist?' do
    let(:question) { create(:question) }

    it 'should return True if url is gist' do
      link = create(:link, url: 'https://gist.github.com/DmitryZyablitsev/11b2834129c6e9897f680ae4fd6c59d8', linkable: question)
      expect(link.gist?).to eq true
    end

    it 'should return False if url is not gist' do
      link = create(:link, url: 'https://thinknetica.com', linkable: question)
      expect(link.gist?).to eq false
    end
  end
end
