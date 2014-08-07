class RenameCompanyFinancingStageToFinancingStageId < ActiveRecord::Migration
  def change
    rename_column :companies, :financing_stage, :financing_stage_id
    change_column :companies, :financing_stage_id, :integer
  end
end
