class HrController < ApplicationController
  before_action :authenticate_account!
  
  def index
    #判断用户是否为hr，不是则跳转到首页
    redirect_to index_index_path and return unless current_account.account_type == Account::ACCOUNT_TYPE_HR
    #已发布职位的标签列表
    tags = current_account.posts.tag_counts.map &:name
    @accounts = Account.tagged_with(tags, :any => true).by_resume_ct_desc.includes(:account_resumes).page(params[:page]).per(5)
  end
  
  def search
    area = params[:area]
    year = params[:year]
    post = params[:post]
    
    #Account.by_resume_ct_desc.by_
  end
end
