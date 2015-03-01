class BorrowsController < ApplicationController
  before_action :set_borrow, except: :index
  def index
  end

  def delete
    @borrow.delete
    redirect_to root_path
  end

  def confirm
    @borrow.confirm
    redirect_to root_path
  end

  private
  def set_borrow
    @borrow = Borrow.where(id: params[:id]).first
  end
end
