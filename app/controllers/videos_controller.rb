class VideosController < ApplicationController
  def index
    query_arrays = []
    query_arrays << (0..9).to_a
    query_arrays << ('a'..'z').to_a
    query_arrays << %w"、 。 / ー"
    result = RestClient::Request.execute(
      method: :get,
      url: 'http://api.search.nicovideo.jp/api/v2/video/contents/search',
      timeout: 10,
      headers: {params: {
        q: query_arrays.join(' OR '),
        targets: 'title,description,tags',
        fields: 'contentId,title,description,tags,categoryTags,viewCounter,startTime',
        _sort: '-viewCounter',
        _limit: 31,
        'filters[startTime][gte]': Time.now.years_ago(10).strftime('%FT00:00:00+09:00'),
        'filters[startTime][lt]': Time.now.years_ago(10).since(1.days).strftime('%FT00:00:00+09:00')
      }}
    )
    if result.body
      @data = JSON.parse(result.body)['data']
    end
  end
  def random
    query_arrays = []
    query_arrays << (0..9).to_a
    query_arrays << ('a'..'z').to_a
    query_arrays << %w"、 。 / ー"
    result = RestClient::Request.execute(
      method: :get,
      url: 'http://api.search.nicovideo.jp/api/v2/video/contents/search',
      timeout: 10,
      headers: {params: {
        q: query_arrays.join(' OR '),
        targets: 'title,description,tags',
        fields: 'contentId,title,description,tags,categoryTags,viewCounter,startTime',
        _sort: '-viewCounter',
        _limit: 100,
        'filters[startTime][gte]': Time.now.years_ago(10).strftime('%FT00:00:00+09:00'),
        'filters[startTime][lt]': Time.now.years_ago(10).since(1.days).strftime('%FT00:00:00+09:00')
      }}
    )
    if result.body
      @data = JSON.parse(result.body)['data']
    end
  end
end
