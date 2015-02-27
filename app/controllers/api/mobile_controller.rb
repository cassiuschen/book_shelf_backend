class Api::MobileController < Api::BaseController
  def books
    @books = Book.all.sort_by{|b| -b.rating}.map(&:info)
    render json: @books
  end

  def book
    @book = Book.where(isbn: params[:id]).first || Book.where(isbn: '978' + params[:id]).first
    @info = @book.douban_data || {}
    @info[:status] = @book.status
    @info[:can_borrow] = @book.can_borrow?
    @info[:times] = @book.borrows.all.size
    render json: @info
  end
end
