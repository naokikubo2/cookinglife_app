module TagsHelper

  def food_link(food_record)
    if food_record.present?
      return link_to food_record.food_name, food_record_path(food_record)
    else
      return link_to "料理名未登録", food_record_path(food_record)
    end
  end

end
