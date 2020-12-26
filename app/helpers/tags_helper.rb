module TagsHelper
  def food_link(food_record)
    if food_record.food_name.present?
      link_to food_record.food_name, food_record_path(food_record)
    else
      link_to "料理名未設定", food_record_path(food_record)
    end
  end
end
