require 'net/http'
require 'open-uri'
class Book
  include Mongoid::Document
  field :_id, type: String, default: -> { isbn }
  field :isbn, type: String
  field :title, type: String
  field :author, type: String

  after_create do
    @date = self.douban_info
    if @data
      self.title = @data["title"]
      self.author = @data["author"].join ','
    else
      self.title = self.author = "Unknown"
    end
    self.save
  end

  has_many :borrows, inverse_of: :book

  def status
    self.borrows.all.sort(&:created_at).first.state
  end

  def can_borrow?
    self.borrows.all.sort(&:created_at).first.return_back
  end
  
  DOUBAN_API = "https://api.douban.com/v2/book/isbn/"
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
end
