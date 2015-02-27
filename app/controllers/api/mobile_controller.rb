class Api::MobileController < Api::BaseController
  def books
    @books = Book.all.sort_by{|b| -b.rating}.map(&:info)
    render json: @books
  end

  def book
    @book = Book.where(isbn: params[:id]).first
    render json: @book
  end
end
