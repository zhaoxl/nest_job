class Worker::InvitesController < ApplicationController
  before_action :authenticate_account!
  
  def index
    @items = WorkflowInvite.by_worker_account_id(current_account.id).order_ct_desc
    @items = @items.by_status([:status_invite_normal]) if params[:status] == "status_invite_normal"
    @items = @items.by_status([:status_invite_reject]) if params[:status] == "status_invite_reject"
  end
end
