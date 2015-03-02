require 'net/http'
require 'open-uri'
class Book
  include Mongoid::Document
  field :_id, type: String, default: -> { isbn }
  field :isbn, type: String
  field :title, type: String
  field :author, type: String
  field :rating, type: Float, default: 5.0
  field :douban_data, type: Hash, default: {}
  field :douban_can_get, type: Boolean, default: true
  field :publisher, type: String, default: ""
  field :summary, type: String


  after_create do
    @date = self.douban_info
    if @data
      self.title = @data["title"]
      self.author = @data["author"].join ','
      self.rating = @data["rating"]["average"].to_f
      self.douban_data = @data.to_hash
    else
      self.douban_can_get = false
      self.title = self.author = "Unknown"
    end
    self.save
    self.clear_ISBN
  end

  has_many :borrows, inverse_of: :book

  def status
    begin
      self.confirmed_applications.map{|x| x.return_back ? 0 : 1}.sum < 1 ? '可借阅' : '已借出'
    rescue
      "可借阅"
    end
  end

  def can_borrow?
    begin
      !!(self.confirmed_applications.map{|x| x.return_back ? 0 : 1}.sum == 0)
    rescue
      true
    end
  end
  
  DOUBAN_API = "https://api.douban.com/v2/book/isbn/" #?apikey=#{Setting.douban_api_key}
  def douban_info
    begin
      open "#{Book::DOUBAN_API}#{isbn}" do |http|
        @data = JSON.parse http.read.to_s
      end
    rescue
      @data = nil
    end
    @data
  end

  def return_back
    @event = self.current_borrow
    @event.return_back = true
    @event.save
  end

  def update_from_douban
    @date = self.douban_info
    if @data
      self.title = @data["title"]
      self.author = @data["author"].join ','
      self.rating = @data["rating"]["average"].to_f
      self.douban_data = @data
      self.save
    end
  end

  def info
    info = (self.douban_can_get)?(douban_data):({
      "title" => title,
      "author" => author.split(',') ,
      "rating" => rating,
      "isbn13" => isbn,
      "publisher" => publisher,
      "summary" => summary
    })
    info[:can_borrow] = can_borrow?
    info
  end

  def avaliable_on_douban?
    !!(self.douban_info)
  end

  def confirmed_applications
    self.borrows.where(confirmed: true)
  end

  def current_borrow
    self.borrows.where(confirmed: true, return_back: false).first
  end

  def clear_ISBN
    isbn.gsub('-','')
    self.save
  end
end
