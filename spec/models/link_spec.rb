require 'rails_helper'

RSpec.describe Link do
  it { is_expected.to belong_to :linkable }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :url }

  describe 'URL validation' do
    it { is_expected.to allow_value('https://google.com').for(:url) }

    it { is_expected.not_to allow_value('plain text').for(:url) }
  end

  describe '.gist?' do
    let(:question) { create(:question) }

    it 'return True if url is gist' do
      link = create(:link, url: 'https://gist.github.com/DmitryZyablitsev/11b2834129c6e9897f680ae4fd6c59d8',
                           linkable: question)
      expect(link.gist?).to be true
    end

    it 'returns False if url is not gist' do
      link = create(:link, url: 'https://thinknetica.com', linkable: question)
      expect(link.gist?).to be false
    end
  end
end
