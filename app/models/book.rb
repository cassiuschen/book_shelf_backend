require 'net/http'
require 'open-uri'
class Book
  include Mongoid::Document
  field :_id, type: String, default: -> { isbn }
  field :isbn, type: String
  field :title, type: String
  field :author, type: String
  field :rating, type: Float, default: 5.0

  after_create do
    @date = self.douban_info
    if @data
      self.title = @data["title"]
      self.author = @data["author"].join ','
      self.rating = @data["rating"]["average"].to_f
    else
      self.title = self.author = "Unknown"
    end
    self.save
  end

  has_many :borrows, inverse_of: :book

  def status
    begin
      self.borrows.all.sort(&:created_at).first.state
    rescue
      "可借阅"
    end
  end

  def can_borrow?
    begin
      self.borrows.all.sort(&:created_at).first.return_back
    rescue
      true
    end
  end
  
  DOUBAN_API = "https://api.douban.com/v2/book/isbn/"
  def douban_info
    begin
      open "#{Book::DOUBAN_API}#{isbn}?apikey=#{Setting.douban_api_key}" do |http|
        @data = JSON.parse http.read.to_s
      end
    rescue
      @data = nil
    end
    @data
  end

  def return
    @event = self.borrows.all.sort(&:created_at).first
    @event.return_back = true
    @event.save
  end

  def update_from_douban
    @date = self.douban_info
    if @data
      self.title = @data["title"]
      self.author = @data["author"].join ','
      self.rating = @data["rating"]["average"].to_f
      self.save
    end
  end

  def info
    douban_info || {
      "title" => title,
      "author" => author.split(',') ,
      "rating" => rating
    }
  end

  def avaliable_on_douban?
    !!(self.douban_info)
  end
end
