require 'rails_helper'

RSpec.describe WebCrawlController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #scrap' do
    it 'returns a success response' do
      post :crawl, params: { twitter_url: 'https://twitter.com/realDonaldTrump', api_token: 'Q83hrXsMBj1URbwRWBF50g' }
      expect(response).to have_http_status(302)
    end
  end
end
