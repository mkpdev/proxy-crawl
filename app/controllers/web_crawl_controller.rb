class WebCrawlController < ApplicationController

  def new; end

  def index
    @twitter_profile = params.except('controller', 'action').as_json
  end

  def crawl
    response = TwitterCrawlService.new(crawl_params).crawling
    redirect_to web_crawl_index_path(response.as_json)
  end

  private
    def crawl_params
      params.permit(:twitter_url, :api_token)
    end
end
