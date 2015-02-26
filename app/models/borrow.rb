class Borrow
  include Mongoid::Document
  include Mongoid::Timestamps

  field :end_up, type: Time
  field :return_back, type: Boolean, default: false
  field :target, type: String, default: "A Friend"

  def state
  	return_back ? "可借阅" : "已借出"
  end

  belongs_to :book, class_name: "Book", inverse_of: :borrow

end
