module DeviseHelper
  def bootstrap_alert(key)
    case key.to_s
    when "alert"
      "warning"
    when "notice"
      "success"
    when "error"
      "danger"
    end
  end
end
