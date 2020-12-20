module FoodRecordHelper
  def star(score)
    "☆" * score unless score.nil?
  end

  def cov_score_to_adverb(adj_m, adj_p, score)
    if score == 0
      "普通"
    elsif score == 1
      "少し" + adj_p
    elsif score == 2
      "まぁまぁ" + adj_p
    elsif score == 3
      adj_p
    elsif score == 4
      "とても" + adj_p
    elsif score == -1
      "少し" + adj_m
    elsif score == -2
      "まぁまぁ" + adj_m
    elsif score == -3
      adj_m
    elsif score == -4
      "とても" + adj_m
    end
  end
end
