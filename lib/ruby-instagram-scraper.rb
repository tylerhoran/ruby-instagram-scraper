require 'open-uri'
require 'json'

module RubyInstagramScraper

  BASE_URL = "https://www.instagram.com"
  USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36"

  def self.search ( query )
    # return false unless query

    url = "#{BASE_URL}/web/search/topsearch/"
    params = "?query=#{ query }"

    JSON.parse( open( "#{url}#{params}" ).read )
  end

  def self.get_user_media_nodes ( username, max_id = nil )
    url = "#{BASE_URL}/#{ username }/?__a=1"
    params = ""
    params = "&max_id=#{ max_id }" if max_id

    JSON.parse( open( "#{url}#{params}" ).read )["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"].map { |n| n["node"] }
  end

  def self.get_user ( username, max_id = nil )
    url = "#{BASE_URL}/#{ username }/"
    data = open(url, "User-Agent" => USER_AGENT).read
    matches = data.match(/window._sharedData =(.*);<\/script>/)
    return nil if matches.nil?
    json = JSON.parse(matches[1])
    return nil if json["entry_data"]["ProfilePage"].nil?
    json["entry_data"]["ProfilePage"][0]["graphql"]["user"]
  end

  def self.get_tag_media_nodes ( tag, max_id = nil )
    url = "#{BASE_URL}/explore/tags/#{ tag }/?__a=1"
    params = ""
    params = "&max_id=#{ max_id }" if max_id

    JSON.parse( open( "#{url}#{params}" ).read )["graphql"]["hashtag"]["edge_hashtag_to_media"]["edges"].map { |n| n["node"] }
  end

  def self.get_media ( code )
    url = "#{BASE_URL}/p/#{ code }/?__a=1"
    params = ""

    JSON.parse( open( "#{url}#{params}" ).read )["graphql"]["shortcode_media"]
  end
  #
  # def self.get_media_comments ( shortcode, count = 40, before = nil )
  #   params = before.nil?? "comments.last(#{ count })" : "comments.before( #{ before } , #{count})"
  #   url = "#{BASE_URL}/query/?q=ig_shortcode(#{ shortcode }){#{ params }\
  #     {count,nodes{id,created_at,text,user{id,profile_pic_url,username,\
  #     follows{count},followed_by{count},biography,full_name,media{count},\
  #     is_private,external_url,is_verified}},page_info}}"
  #
  #   JSON.parse( open( url ).read )["comments"]
  # end

end
