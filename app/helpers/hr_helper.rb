module HrHelper
  def hr_apply_normal_count
    count = Workflow.by_status(:status_apply_normal).by_hr_account_id(current_account.id).count
    return "" if count.zero?
    raw <<-HTML
    <span>#{count}</span>
    HTML
  end
end
