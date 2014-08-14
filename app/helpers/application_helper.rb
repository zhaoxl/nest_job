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
  
  # 自己的热门搜索标签
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2014-06-12
  #
  # ==== 示例
  # self_hot_search_tags
  # ==== 返回类型
  # [HotSearchTag]
  def self_hot_search_tags
    if current_account.present?
      tags = HotSearchTag.by_account_id(current_account.id)
    elsif cookies[:cookie_id].present?
      tags = HotSearchTag.by_cookie_id(cookies[:cookie_id])
    end
    
    return tags
  end
  
  # 热门搜索标签
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2014-06-12
  #
  # ==== 示例
  # self_hot_search_tags
  # ==== 返回类型
  # [HotSearchTag]
  def self_hot_search_tags
    tags = HotSearchTag.by_search_count_desc.limit(4)
    
    if current_account.present?
      tags = tags.by_industry_id(current_account.industry_id).group("name")
    elsif cookies[:cookie_id].present?
      #:TODO 先留着，据说是显示人工编辑的
      tags = []
    end
    
    return tags
  end
  
  # 格式化日期
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2014-06-24
  #
  # ==== 示例
  # strftime(Date.today, "%Y-%m-%d")
  # ==== 返回类型
  # String
  def strftime(date, format)
    return "" if date.blank?
    date.strftime format
  end
end
