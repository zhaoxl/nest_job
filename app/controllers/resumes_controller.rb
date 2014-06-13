class ResumesController < ApplicationController
  def index
    @resumes = AccountResume.ct_desc
  end
end
