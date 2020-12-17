module FoodRecordHelper

  def star(score)
    "☆" * score unless score == nil
  end

end
