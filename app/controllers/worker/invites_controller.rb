class Worker::InvitesController < ApplicationController
  before_action :authenticate_account!
  
  def index
    @items = Workflow.unscoped.by_worker_account_id(current_account.id).by_status(["status_invite_audition", "status_apply_audition"]).order_ct_desc
  end
end
