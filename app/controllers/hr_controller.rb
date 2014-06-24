class HrController < ApplicationController
  before_action :authenticate_account!
  
  def index
    #判断用户是否为hr，不是则跳转到首页
    redirect_to index_index_path and return unless current_account.account_type == Account::ACCOUNT_TYPE_HR
    #已发布职位的标签列表
    tags = current_account.posts.tag_counts.map &:name
    @resumes = AccountResume.tagged_with(tags, :any => true).by_ct_desc.includes(:account).page(params[:page]).per(5)
    #读取搜索记录
    @search_logs = current_account.hr_search_logs.by_search_num_desc.by_ct_desc.limit(4)
  end
  
  def search
    tags = params[:tags].to_s
    area = params[:area].to_s
    year = params[:year]
    
    #记录搜索日志
    if tags.present?
      log = current_account.hr_search_logs.find_or_create_by(area: (area.blank? ? nil : area), post: tags, year: (year.to_i == 0 ? nil : year))
      log.search_num = log.search_num.to_i + 1
      log.save
    end
    #搜索
    @resumes = AccountResume.search(tags, area, year).page(params[:page]).per(5)
    
    
    #读取搜索记录
    @search_logs = current_account.hr_search_logs.by_search_num_desc.by_ct_desc.limit(4)
    render :index
  end
  
  def show
    @resume = AccountResume.find(params[:id])
    @account = @resume.account
    @experiences = @resume.account_resume_experiences.order_start_time_desc
  end
end
