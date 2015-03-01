class Api::MobileController < Api::BaseController
  def books
    @books = Book.all.sort_by{|b| -b.rating}.map(&:info)
    render json: @books
  end

  def book
    @book = Book.where(isbn: params[:id]).first || Book.where(isbn: '978' + params[:id]).first
    unless params[:attr]
      @info = @book.info || {}
      @info[:status] = @book.status
      @info[:can_borrow] = @book.can_borrow?
      @info[:times] = @book.confirmed_applications.size
      render json: @info
    else
      begin
        attr = params[:attr]
        render json: {result: @book.method(attr.to_sym).call}
      rescue
        render json: nil
      end
    end
    
  end

  def borrow
    begin
      @book = Book.where(isbn: params[:id]).first
      @book.borrows.create(borrow_params)
      render json: {status: 200}
    rescue
      render json: {status: 503}
    end
  end

  private
  def borrow_params
    params.require('borrow').permit(:target, :phone)
  end
end
