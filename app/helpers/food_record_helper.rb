module FoodRecordHelper
  def star(score)
    "☆" * score unless score.nil?
  end

  def cov_score_to_adverb(adj_m, adj_p, score)
    case score
    when 0
      "普通"
    when 1
      "少し" + adj_p
    when 2
      "まぁまぁ" + adj_p
    when 3
      adj_p
    when 4
      "とても" + adj_p
    when -1
      "少し" + adj_m
    when -2
      "まぁまぁ" + adj_m
    when -3
      adj_m
    when -4
      "とても" + adj_m
    end
  end

  def cov_en_to_ja(eng)
    lists = {
      'morning' => '朝',
      'lunch' => '昼',
      'dinner' => '夜',
      'snack' => '間食'
    }
    lists[eng]
  end

  def tag_link(tag)
    link_to "#{tag.name}(#{tag.taggings_count})", tags_path(tag: tag.name)
  end

  def date_format(date)
    return l date, format: :long if date.present?
  end
end
