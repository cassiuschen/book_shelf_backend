class Api::MobileController < Api::BaseController
  def books
    @books = Book.all.sort_by{|b| -b.rating}.map(&:info)
    render json: @books
  end
end
