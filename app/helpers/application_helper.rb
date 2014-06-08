module ApplicationHelper
  def resource_name
    :account
  end

  def resource
    @resource ||= Account.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:account]
  end
  
  # 格式化日期
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2014-06-08
  #
  # ==== 示例
  # format_to_date(DateTime.now)
  # ==== 返回类型
  # Date
  def format_to_date(time)
    return time unless time.is_a?(ActiveSupport::TimeWithZone) || time.is_a?(DateTime)
    return time.strftime("%Y-%m-%d")
  end
end
