module WorkerHelper
  def worker_wait_audition_count
    count = Workflow.by_status(:status_wait_audition).by_worker_account_id(current_account.id).count
    return "" if count.zero?
    raw <<-HTML
    <span>#{count}</span>
    HTML
  end
end