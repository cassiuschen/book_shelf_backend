class Borrow
  include Mongoid::Document
  include Mongoid::Timestamps

  field :end_up, type: Time
  field :phone, type: String
  field :confirmed, type: Boolean, default: false
  field :return_back, type: Boolean, default: false
  field :target, type: String, default: "A Friend"

  belongs_to :book, class_name: "Book", inverse_of: :borrow

  def state
    return_back ? "可借阅" : "已借出"
  end

  def table_class
    if confirmed
      if return_back
        'success'
      else
        'warning'
      end
    end
  end

  def time_from_now
    Time.now - created_at
  end

  def confirm
    self.confirmed = true
    self.save
  end

  #def can_borrow?
  #  !!(Borrow.where(book_id: self.book_id, confirmed: true, return_back: false).size < 1)
  #end 

end
