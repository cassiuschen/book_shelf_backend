class BooksController < ApplicationController
  before_action :set_book, except: [:index, :new, :create]
  def index
  end

  def new
    @book = Book.new
  end

  # GET /ar/1/edit
  def edit
  end

  # POST /ar
  # POST /ar.json
  def create
    @book = Book.create(create_book_params)
    redirect_to root_path
  end

  # PATCH/PUT /ar/1
  # PATCH/PUT /ar/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to root_path, notice: '书籍更新成功' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ar/1
  # DELETE /ar/1.json
  def destroy
    @book.delete
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def update_from_douban
    @book.update_from_douban
    redirect_to root_path
  end

  def return_back
    @book.return_back
    redirect_to root_path
  end

  private
  def set_book
    @book = Book.where(isbn: params[:id]).first
  end

  def book_params
    params.require(:book).permit(:title, :author, :rate, :isbn)
  end

  def create_book_params
    params.require(:book).permit(:isbn)
  end
end
